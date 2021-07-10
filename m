Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B8E3C2CC7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhGJCUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhGJCUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E08D613C7;
        Sat, 10 Jul 2021 02:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883483;
        bh=p7VlPFXuhYUrlLGzWVBlKVGGGZ/ormNZxuIr4IHfc5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFolTdgGl4YETgXLeHfZX79BpQrjcouJh9q9tZayjRnLNf29egOJ2litSKERgUtnn
         Z/N/BIktIrTaM7NwPBZhhQHheOWr2V2dvsXqJlIP29IXVAi3ZATIWNgvJD9hFeDBuT
         IsEK7+yLYyy4epiwEpo66qZ8A2hrthjVilc6CoUPs9BOUbcpJsNXmjjh8tA1Hbk7m/
         CZh98bR+yxNm7c7Jz3wqD0DNE58+20qAvP3QJ9H9dUowrjzkPlLma5wwZT7ajCauI/
         g8gTfp5bZlvz4NazdW/jgf2A2PO+iGNrJq1tDT8dmZbg4rwZegrtVIMzS5WWaSxawD
         OQxXBtnTMTvCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 009/114] soundwire: bus: handle -ENODATA errors in clock stop/start sequences
Date:   Fri,  9 Jul 2021 22:16:03 -0400
Message-Id: <20210710021748.3167666-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b50bb8ba369cdc8814e82558117711c12ef3af3d ]

If a device lost sync and can no longer ACK a command, it may not be
able to enter a lower-power state but it will still be able to resync
when the clock restarts. In those cases, we want to continue with the
clock stop sequence.

This patch modifies the behavior during clock stop sequences to only
log errors unrelated to -ENODATA/Command_Ignored. The flow is also
modified so that loops continue to prepare/deprepare other devices
even when one seems to have lost sync.

When resuming the clocks, all issues are logged with a dev_warn(),
previously only some of them were checked. This is the only part that
now differs between the clock stop entry and clock stop exit
sequences: while we don't want to stop the suspend flow, we do want
information on potential issues while resuming, as they may have
ripple effects.

For consistency the log messages are also modified to be unique and
self-explanatory. Errors in sdw_slave_clk_stop_callback() were
removed, they are now handled in the caller.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210511030048.25622-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 69 +++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index dc4033b6f2e9..100d904bf700 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -829,11 +829,8 @@ static int sdw_slave_clk_stop_callback(struct sdw_slave *slave,
 
 	if (slave->ops && slave->ops->clk_stop) {
 		ret = slave->ops->clk_stop(slave, mode, type);
-		if (ret < 0) {
-			dev_err(&slave->dev,
-				"Clk Stop type =%d failed: %d\n", type, ret);
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	return 0;
@@ -860,7 +857,8 @@ static int sdw_slave_clk_stop_prepare(struct sdw_slave *slave,
 	} else {
 		ret = sdw_read_no_pm(slave, SDW_SCP_SYSTEMCTRL);
 		if (ret < 0) {
-			dev_err(&slave->dev, "SDW_SCP_SYSTEMCTRL read failed:%d\n", ret);
+			if (ret != -ENODATA)
+				dev_err(&slave->dev, "SDW_SCP_SYSTEMCTRL read failed:%d\n", ret);
 			return ret;
 		}
 		val = ret;
@@ -869,9 +867,8 @@ static int sdw_slave_clk_stop_prepare(struct sdw_slave *slave,
 
 	ret = sdw_write_no_pm(slave, SDW_SCP_SYSTEMCTRL, val);
 
-	if (ret < 0)
-		dev_err(&slave->dev,
-			"Clock Stop prepare failed for slave: %d", ret);
+	if (ret < 0 && ret != -ENODATA)
+		dev_err(&slave->dev, "SDW_SCP_SYSTEMCTRL write failed:%d\n", ret);
 
 	return ret;
 }
@@ -922,6 +919,9 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 	 * In order to save on transition time, prepare
 	 * each Slave and then wait for all Slave(s) to be
 	 * prepared for clock stop.
+	 * If one of the Slave devices has lost sync and
+	 * replies with Command Ignored/-ENODATA, we continue
+	 * the loop
 	 */
 	list_for_each_entry(slave, &bus->slaves, node) {
 		if (!slave->dev_num)
@@ -937,9 +937,8 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 		ret = sdw_slave_clk_stop_callback(slave,
 						  SDW_CLK_STOP_MODE0,
 						  SDW_CLK_PRE_PREPARE);
-		if (ret < 0) {
-			dev_err(&slave->dev,
-				"pre-prepare failed:%d", ret);
+		if (ret < 0 && ret != -ENODATA) {
+			dev_err(&slave->dev, "clock stop pre-prepare cb failed:%d\n", ret);
 			return ret;
 		}
 
@@ -950,9 +949,8 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 			ret = sdw_slave_clk_stop_prepare(slave,
 							 SDW_CLK_STOP_MODE0,
 							 true);
-			if (ret < 0) {
-				dev_err(&slave->dev,
-					"pre-prepare failed:%d", ret);
+			if (ret < 0 && ret != -ENODATA) {
+				dev_err(&slave->dev, "clock stop prepare failed:%d\n", ret);
 				return ret;
 			}
 		}
@@ -960,7 +958,7 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 
 	/* Skip remaining clock stop preparation if no Slave is attached */
 	if (!is_slave)
-		return ret;
+		return 0;
 
 	/*
 	 * Don't wait for all Slaves to be ready if they follow the simple
@@ -969,6 +967,12 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 	if (!simple_clk_stop) {
 		ret = sdw_bus_wait_for_clk_prep_deprep(bus,
 						       SDW_BROADCAST_DEV_NUM);
+		/*
+		 * if there are no Slave devices present and the reply is
+		 * Command_Ignored/-ENODATA, we don't need to continue with the
+		 * flow and can just return here. The error code is not modified
+		 * and its handling left as an exercise for the caller.
+		 */
 		if (ret < 0)
 			return ret;
 	}
@@ -986,13 +990,13 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 						  SDW_CLK_STOP_MODE0,
 						  SDW_CLK_POST_PREPARE);
 
-		if (ret < 0) {
-			dev_err(&slave->dev,
-				"post-prepare failed:%d", ret);
+		if (ret < 0 && ret != -ENODATA) {
+			dev_err(&slave->dev, "clock stop post-prepare cb failed:%d\n", ret);
+			return ret;
 		}
 	}
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(sdw_bus_prep_clk_stop);
 
@@ -1015,12 +1019,8 @@ int sdw_bus_clk_stop(struct sdw_bus *bus)
 	ret = sdw_bwrite_no_pm(bus, SDW_BROADCAST_DEV_NUM,
 			       SDW_SCP_CTRL, SDW_SCP_CTRL_CLK_STP_NOW);
 	if (ret < 0) {
-		if (ret == -ENODATA)
-			dev_dbg(bus->dev,
-				"ClockStopNow Broadcast msg ignored %d", ret);
-		else
-			dev_err(bus->dev,
-				"ClockStopNow Broadcast msg failed %d", ret);
+		if (ret != -ENODATA)
+			dev_err(bus->dev, "ClockStopNow Broadcast msg failed %d\n", ret);
 		return ret;
 	}
 
@@ -1063,8 +1063,7 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 		ret = sdw_slave_clk_stop_callback(slave, SDW_CLK_STOP_MODE0,
 						  SDW_CLK_PRE_DEPREPARE);
 		if (ret < 0)
-			dev_warn(&slave->dev,
-				 "clk stop deprep failed:%d", ret);
+			dev_warn(&slave->dev, "clock stop pre-deprepare cb failed:%d\n", ret);
 
 		/* Only de-prepare a Slave device if needed */
 		if (!slave->prop.simple_clk_stop_capable) {
@@ -1074,8 +1073,7 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 							 false);
 
 			if (ret < 0)
-				dev_warn(&slave->dev,
-					 "clk stop deprep failed:%d", ret);
+				dev_warn(&slave->dev, "clock stop deprepare failed:%d\n", ret);
 		}
 	}
 
@@ -1087,8 +1085,11 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 	 * Don't wait for all Slaves to be ready if they follow the simple
 	 * state machine
 	 */
-	if (!simple_clk_stop)
-		sdw_bus_wait_for_clk_prep_deprep(bus, SDW_BROADCAST_DEV_NUM);
+	if (!simple_clk_stop) {
+		ret = sdw_bus_wait_for_clk_prep_deprep(bus, SDW_BROADCAST_DEV_NUM);
+		if (ret < 0)
+			dev_warn(&slave->dev, "clock stop deprepare wait failed:%d\n", ret);
+	}
 
 	list_for_each_entry(slave, &bus->slaves, node) {
 		if (!slave->dev_num)
@@ -1098,8 +1099,10 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 		    slave->status != SDW_SLAVE_ALERT)
 			continue;
 
-		sdw_slave_clk_stop_callback(slave, SDW_CLK_STOP_MODE0,
-					    SDW_CLK_POST_DEPREPARE);
+		ret = sdw_slave_clk_stop_callback(slave, SDW_CLK_STOP_MODE0,
+						  SDW_CLK_POST_DEPREPARE);
+		if (ret < 0)
+			dev_warn(&slave->dev, "clock stop post-deprepare cb failed:%d\n", ret);
 	}
 
 	return 0;
-- 
2.30.2

