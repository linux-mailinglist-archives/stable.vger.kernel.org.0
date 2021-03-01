Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE895328E0D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbhCATW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241356AbhCATRt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:17:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A95265218;
        Mon,  1 Mar 2021 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619352;
        bh=yiuWj05qntSQoIZVpSlCXmbJSHclE/b0ngrkouGBBJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8GRHHNN7UK/kczL7XCq5wzntkKj5RVKmYemOTTXwFX+s+5wdhIiFzmoLH3MIbQah
         k4dhSkP+RCjrz1P4aC52Mx9WFkTAf3mkfVez4gwwYetzRz40WK/AWwJQ7pJ5CeH2Gt
         hLrMdaY76apeuW3o8AEaiITLZpF+SygitNuuDMQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/663] soundwire: bus: use sdw_update_no_pm when initializing a device
Date:   Mon,  1 Mar 2021 17:11:10 +0100
Message-Id: <20210301161202.755974449@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b04c975e654cfdea6d691cd403b5a81cce7e593d ]

When a Slave device is resumed, it may resume the bus and restart the
enumeration. During that process, we absolutely don't want to call
regular read/write routines which will wait for the resume to
complete, otherwise a deadlock occurs.

Fixes: 60ee9be25571 ('soundwire: bus: add PM/no-PM versions of read/write functions')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210122070634.12825-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 8eaf31e766773..0345f9af6e865 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -489,6 +489,18 @@ sdw_read_no_pm(struct sdw_slave *slave, u32 addr)
 		return buf;
 }
 
+static int sdw_update_no_pm(struct sdw_slave *slave, u32 addr, u8 mask, u8 val)
+{
+	int tmp;
+
+	tmp = sdw_read_no_pm(slave, addr);
+	if (tmp < 0)
+		return tmp;
+
+	tmp = (tmp & ~mask) | val;
+	return sdw_write_no_pm(slave, addr, tmp);
+}
+
 /**
  * sdw_nread() - Read "n" contiguous SDW Slave registers
  * @slave: SDW Slave
@@ -1256,7 +1268,7 @@ static int sdw_initialize_slave(struct sdw_slave *slave)
 	val = slave->prop.scp_int1_mask;
 
 	/* Enable SCP interrupts */
-	ret = sdw_update(slave, SDW_SCP_INTMASK1, val, val);
+	ret = sdw_update_no_pm(slave, SDW_SCP_INTMASK1, val, val);
 	if (ret < 0) {
 		dev_err(slave->bus->dev,
 			"SDW_SCP_INTMASK1 write failed:%d\n", ret);
@@ -1271,7 +1283,7 @@ static int sdw_initialize_slave(struct sdw_slave *slave)
 	val = prop->dp0_prop->imp_def_interrupts;
 	val |= SDW_DP0_INT_PORT_READY | SDW_DP0_INT_BRA_FAILURE;
 
-	ret = sdw_update(slave, SDW_DP0_INTMASK, val, val);
+	ret = sdw_update_no_pm(slave, SDW_DP0_INTMASK, val, val);
 	if (ret < 0)
 		dev_err(slave->bus->dev,
 			"SDW_DP0_INTMASK read failed:%d\n", ret);
-- 
2.27.0



