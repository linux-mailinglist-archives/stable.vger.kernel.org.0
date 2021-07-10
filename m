Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7EC3C2CC5
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhGJCUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhGJCUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B808613C3;
        Sat, 10 Jul 2021 02:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883481;
        bh=BzEBpleatGRrw0kXVuk8Cw6ahi6FDczfg30IAZx5yME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXk5GaDO2oHi0jgPYwY482MkEPr4UrhqPb+seqsV/NDr8mZL3QaBpov9QKXs5+Ny9
         qieU5YtT4SdenJd9WMzkTZPexnNVniYULz9f+KWFoA9ygf2qHas3UJjl3w7gk3UvUG
         k3MvsnVQUeW3+vMyGQtIZkoodQF+nlUnZXttuSSZe/fAcaZ3oGHiorNSSKhQbsO98p
         Z9Dvg0lexUCiVhHyFdYG6MU3qO4hFTO1zm1FoK4zDNVcfjHFBRn5P8XvYTkOV5JshD
         lARdZB+jLAZGAzAjz8+ZrndD0Qu9trwnPMZgDOqiafg1XLpDBxPGh1dCYpYHZQG4Fw
         HlxbjpAVom0ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 008/114] soundwire: bus: only use CLOCK_STOP_MODE0 and fix confusions
Date:   Fri,  9 Jul 2021 22:16:02 -0400
Message-Id: <20210710021748.3167666-8-sashal@kernel.org>
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

[ Upstream commit 345e9f5ca798600e44c0843646621f2804eb99f4 ]

Existing devices and implementations only support the required
CLOCK_STOP_MODE0. All the code related to CLOCK_STOP_MODE1 has not
been tested and is highly questionable, with a clear confusion between
CLOCK_STOP_MODE1 and the simple clock stop state machine.

This patch removes all usages of CLOCK_STOP_MODE1 - which has no
impact on any solution - and fixes the use of the simple clock stop
state machine. The resulting code should be a lot more symmetrical and
easier to maintain.

Note that CLOCK_STOP_MODE1 is not supported in the SoundWire Device
Class specification so it's rather unlikely that we need to re-add
this mode later.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210511030048.25622-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c       | 100 ++++++++++++++--------------------
 include/linux/soundwire/sdw.h |   2 -
 2 files changed, 40 insertions(+), 62 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index a9e0aa72654d..dc4033b6f2e9 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -821,26 +821,6 @@ static void sdw_modify_slave_status(struct sdw_slave *slave,
 	mutex_unlock(&bus->bus_lock);
 }
 
-static enum sdw_clk_stop_mode sdw_get_clk_stop_mode(struct sdw_slave *slave)
-{
-	enum sdw_clk_stop_mode mode;
-
-	/*
-	 * Query for clock stop mode if Slave implements
-	 * ops->get_clk_stop_mode, else read from property.
-	 */
-	if (slave->ops && slave->ops->get_clk_stop_mode) {
-		mode = slave->ops->get_clk_stop_mode(slave);
-	} else {
-		if (slave->prop.clk_stop_mode1)
-			mode = SDW_CLK_STOP_MODE1;
-		else
-			mode = SDW_CLK_STOP_MODE0;
-	}
-
-	return mode;
-}
-
 static int sdw_slave_clk_stop_callback(struct sdw_slave *slave,
 				       enum sdw_clk_stop_mode mode,
 				       enum sdw_clk_stop_type type)
@@ -933,7 +913,6 @@ static int sdw_bus_wait_for_clk_prep_deprep(struct sdw_bus *bus, u16 dev_num)
  */
 int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 {
-	enum sdw_clk_stop_mode slave_mode;
 	bool simple_clk_stop = true;
 	struct sdw_slave *slave;
 	bool is_slave = false;
@@ -955,10 +934,8 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 		/* Identify if Slave(s) are available on Bus */
 		is_slave = true;
 
-		slave_mode = sdw_get_clk_stop_mode(slave);
-		slave->curr_clk_stop_mode = slave_mode;
-
-		ret = sdw_slave_clk_stop_callback(slave, slave_mode,
+		ret = sdw_slave_clk_stop_callback(slave,
+						  SDW_CLK_STOP_MODE0,
 						  SDW_CLK_PRE_PREPARE);
 		if (ret < 0) {
 			dev_err(&slave->dev,
@@ -966,22 +943,29 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 			return ret;
 		}
 
-		ret = sdw_slave_clk_stop_prepare(slave,
-						 slave_mode, true);
-		if (ret < 0) {
-			dev_err(&slave->dev,
-				"pre-prepare failed:%d", ret);
-			return ret;
-		}
-
-		if (slave_mode == SDW_CLK_STOP_MODE1)
+		/* Only prepare a Slave device if needed */
+		if (!slave->prop.simple_clk_stop_capable) {
 			simple_clk_stop = false;
+
+			ret = sdw_slave_clk_stop_prepare(slave,
+							 SDW_CLK_STOP_MODE0,
+							 true);
+			if (ret < 0) {
+				dev_err(&slave->dev,
+					"pre-prepare failed:%d", ret);
+				return ret;
+			}
+		}
 	}
 
 	/* Skip remaining clock stop preparation if no Slave is attached */
 	if (!is_slave)
 		return ret;
 
+	/*
+	 * Don't wait for all Slaves to be ready if they follow the simple
+	 * state machine
+	 */
 	if (!simple_clk_stop) {
 		ret = sdw_bus_wait_for_clk_prep_deprep(bus,
 						       SDW_BROADCAST_DEV_NUM);
@@ -998,17 +982,13 @@ int sdw_bus_prep_clk_stop(struct sdw_bus *bus)
 		    slave->status != SDW_SLAVE_ALERT)
 			continue;
 
-		slave_mode = slave->curr_clk_stop_mode;
-
-		if (slave_mode == SDW_CLK_STOP_MODE1) {
-			ret = sdw_slave_clk_stop_callback(slave,
-							  slave_mode,
-							  SDW_CLK_POST_PREPARE);
+		ret = sdw_slave_clk_stop_callback(slave,
+						  SDW_CLK_STOP_MODE0,
+						  SDW_CLK_POST_PREPARE);
 
-			if (ret < 0) {
-				dev_err(&slave->dev,
-					"post-prepare failed:%d", ret);
-			}
+		if (ret < 0) {
+			dev_err(&slave->dev,
+				"post-prepare failed:%d", ret);
 		}
 	}
 
@@ -1059,7 +1039,6 @@ EXPORT_SYMBOL(sdw_bus_clk_stop);
  */
 int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 {
-	enum sdw_clk_stop_mode mode;
 	bool simple_clk_stop = true;
 	struct sdw_slave *slave;
 	bool is_slave = false;
@@ -1081,31 +1060,33 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 		/* Identify if Slave(s) are available on Bus */
 		is_slave = true;
 
-		mode = slave->curr_clk_stop_mode;
-
-		if (mode == SDW_CLK_STOP_MODE1) {
-			simple_clk_stop = false;
-			continue;
-		}
-
-		ret = sdw_slave_clk_stop_callback(slave, mode,
+		ret = sdw_slave_clk_stop_callback(slave, SDW_CLK_STOP_MODE0,
 						  SDW_CLK_PRE_DEPREPARE);
 		if (ret < 0)
 			dev_warn(&slave->dev,
 				 "clk stop deprep failed:%d", ret);
 
-		ret = sdw_slave_clk_stop_prepare(slave, mode,
-						 false);
+		/* Only de-prepare a Slave device if needed */
+		if (!slave->prop.simple_clk_stop_capable) {
+			simple_clk_stop = false;
 
-		if (ret < 0)
-			dev_warn(&slave->dev,
-				 "clk stop deprep failed:%d", ret);
+			ret = sdw_slave_clk_stop_prepare(slave, SDW_CLK_STOP_MODE0,
+							 false);
+
+			if (ret < 0)
+				dev_warn(&slave->dev,
+					 "clk stop deprep failed:%d", ret);
+		}
 	}
 
 	/* Skip remaining clock stop de-preparation if no Slave is attached */
 	if (!is_slave)
 		return 0;
 
+	/*
+	 * Don't wait for all Slaves to be ready if they follow the simple
+	 * state machine
+	 */
 	if (!simple_clk_stop)
 		sdw_bus_wait_for_clk_prep_deprep(bus, SDW_BROADCAST_DEV_NUM);
 
@@ -1117,8 +1098,7 @@ int sdw_bus_exit_clk_stop(struct sdw_bus *bus)
 		    slave->status != SDW_SLAVE_ALERT)
 			continue;
 
-		mode = slave->curr_clk_stop_mode;
-		sdw_slave_clk_stop_callback(slave, mode,
+		sdw_slave_clk_stop_callback(slave, SDW_CLK_STOP_MODE0,
 					    SDW_CLK_POST_DEPREPARE);
 	}
 
diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index ced07f8fde87..5d93d9949653 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -624,7 +624,6 @@ struct sdw_slave_ops {
 	int (*port_prep)(struct sdw_slave *slave,
 			 struct sdw_prepare_ch *prepare_ch,
 			 enum sdw_port_prep_ops pre_ops);
-	int (*get_clk_stop_mode)(struct sdw_slave *slave);
 	int (*clk_stop)(struct sdw_slave *slave,
 			enum sdw_clk_stop_mode mode,
 			enum sdw_clk_stop_type type);
@@ -675,7 +674,6 @@ struct sdw_slave {
 	struct list_head node;
 	struct completion port_ready[SDW_MAX_PORTS];
 	unsigned int m_port_map[SDW_MAX_PORTS];
-	enum sdw_clk_stop_mode curr_clk_stop_mode;
 	u16 dev_num;
 	u16 dev_num_sticky;
 	bool probed;
-- 
2.30.2

