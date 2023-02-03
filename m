Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A4689664
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjBCKZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbjBCKZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A974AB
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA17761EBA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1399C433EF;
        Fri,  3 Feb 2023 10:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419914;
        bh=XGwZ1w8UdnQwFtEVv8bESBqtunOQaYZC1Zd9Zto2jhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Av1ASaog6RSlDjBgUnBp5jAkBGOvkAIez1BvQ8NlXcIfNwz5Zx34K85Wh4hpAgNyZ
         31GPx59J79NapfiYUlnRJM82e9Dr+8mpCHS22PtkDXuGj0Ew/zxi2Wrm/KKSWxdoaN
         P8WjJSQxU8dNqSNT8itraYgF2FsmsVHAsyxIUZI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/134] amd-xgbe: Delay AN timeout during KR training
Date:   Fri,  3 Feb 2023 11:12:04 +0100
Message-Id: <20230203101024.710660808@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 926446ae24c03311a480fb96eb78f0ce7ea6d091 ]

AN restart triggered during KR training not only aborts the KR training
process but also move the HW to unstable state. Driver has to wait upto
500ms or until the KR training is completed before restarting AN cycle.

Fixes: 7c12aa08779c ("amd-xgbe: Move the PHY support into amd-xgbe")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 24 +++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe.h      |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 97167fc9bebe..7840eb4cdb8d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -496,6 +496,7 @@ static enum xgbe_an xgbe_an73_tx_training(struct xgbe_prv_data *pdata,
 	reg |= XGBE_KR_TRAINING_ENABLE;
 	reg |= XGBE_KR_TRAINING_START;
 	XMDIO_WRITE(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_PMD_CTRL, reg);
+	pdata->kr_start_time = jiffies;
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "KR training initiated\n");
@@ -632,6 +633,8 @@ static enum xgbe_an xgbe_an73_incompat_link(struct xgbe_prv_data *pdata)
 
 	xgbe_switch_mode(pdata);
 
+	pdata->an_result = XGBE_AN_READY;
+
 	xgbe_an_restart(pdata);
 
 	return XGBE_AN_INCOMPAT_LINK;
@@ -1275,9 +1278,30 @@ static bool xgbe_phy_aneg_done(struct xgbe_prv_data *pdata)
 static void xgbe_check_link_timeout(struct xgbe_prv_data *pdata)
 {
 	unsigned long link_timeout;
+	unsigned long kr_time;
+	int wait;
 
 	link_timeout = pdata->link_check + (XGBE_LINK_TIMEOUT * HZ);
 	if (time_after(jiffies, link_timeout)) {
+		if ((xgbe_cur_mode(pdata) == XGBE_MODE_KR) &&
+		    pdata->phy.autoneg == AUTONEG_ENABLE) {
+			/* AN restart should not happen while KR training is in progress.
+			 * The while loop ensures no AN restart during KR training,
+			 * waits up to 500ms and AN restart is triggered only if KR
+			 * training is failed.
+			 */
+			wait = XGBE_KR_TRAINING_WAIT_ITER;
+			while (wait--) {
+				kr_time = pdata->kr_start_time +
+					  msecs_to_jiffies(XGBE_AN_MS_TIMEOUT);
+				if (time_after(jiffies, kr_time))
+					break;
+				/* AN restart is not required, if AN result is COMPLETE */
+				if (pdata->an_result == XGBE_AN_COMPLETE)
+					return;
+				usleep_range(10000, 11000);
+			}
+		}
 		netif_dbg(pdata, link, pdata->netdev, "AN link timeout\n");
 		xgbe_phy_config_aneg(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 0c93a552b921..729307a96c50 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -290,6 +290,7 @@
 /* Auto-negotiation */
 #define XGBE_AN_MS_TIMEOUT		500
 #define XGBE_LINK_TIMEOUT		5
+#define XGBE_KR_TRAINING_WAIT_ITER	50
 
 #define XGBE_SGMII_AN_LINK_STATUS	BIT(1)
 #define XGBE_SGMII_AN_LINK_SPEED	(BIT(2) | BIT(3))
@@ -1266,6 +1267,7 @@ struct xgbe_prv_data {
 	unsigned int parallel_detect;
 	unsigned int fec_ability;
 	unsigned long an_start;
+	unsigned long kr_start_time;
 	enum xgbe_an_mode an_mode;
 
 	/* I2C support */
-- 
2.39.0



