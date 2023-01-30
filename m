Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF5680FBE
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjA3N4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbjA3N4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE3739B8C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39F076101F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F56CC433D2;
        Mon, 30 Jan 2023 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086993;
        bh=nEGRtUBBR9pjzINghAhjNOV3KFiHldKp3r41gPsvoQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYeAJ45VhWlpBf71xWI4YRNbojFvQ9rFB4uvIbiG8LSxm9bHJgJHJJ7gLRRiGaABG
         zzoS02WbBl7Q0xmthOW0QCtYn+KA1j1zLf3hXmwq55WQElxO6JfoRPDZ8tIZv58bpZ
         QRlABAnbe1M5mYwuDwJPJ8Jj8y0PXBWr2M6mpHEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ajith Nayak <Ajith.Nayak@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/313] amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
Date:   Mon, 30 Jan 2023 14:48:19 +0100
Message-Id: <20230130134339.658535806@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit 579923d84b04abb6cd4cd1fd9974096a2dd1832b ]

There is difference in the TX Flow Control registers (TFCR) between the
revisions of the hardware. The older revisions of hardware used to have
single register per queue. Whereas, the newer revision of hardware (from
ver 30H onwards) have one register per priority.

Update the driver to use the TFCR based on the reported version of the
hardware.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Co-developed-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Ajith Nayak <Ajith.Nayak@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 3936543a74d8..4030d619e84f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -524,19 +524,28 @@ static void xgbe_disable_vxlan(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, drv, pdata->netdev, "VXLAN acceleration disabled\n");
 }
 
+static unsigned int xgbe_get_fc_queue_count(struct xgbe_prv_data *pdata)
+{
+	unsigned int max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
+
+	/* From MAC ver 30H the TFCR is per priority, instead of per queue */
+	if (XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER) >= 0x30)
+		return max_q_count;
+	else
+		return min_t(unsigned int, pdata->tx_q_count, max_q_count);
+}
+
 static int xgbe_disable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Clear MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++)
 		XGMAC_MTL_IOWRITE_BITS(pdata, i, MTL_Q_RQOMR, EHFC, 0);
 
 	/* Clear MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
@@ -553,9 +562,8 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
 	struct ieee_pfc *pfc = pdata->pfc;
 	struct ieee_ets *ets = pdata->ets;
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Set MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++) {
@@ -579,8 +587,7 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 	}
 
 	/* Set MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
-- 
2.39.0



