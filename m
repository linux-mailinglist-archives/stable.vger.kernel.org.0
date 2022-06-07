Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2143954184B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379217AbiFGVLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380186AbiFGVLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAE81498FA;
        Tue,  7 Jun 2022 11:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23EE3612F2;
        Tue,  7 Jun 2022 18:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34592C385A2;
        Tue,  7 Jun 2022 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628005;
        bh=czw9kRjZG40hr+kia3G/03BugvUAA5H+FXWgSqt3PEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfSQbZgG7daHKQL3Z17vMINZ9qFrnUxAhtm8vFj8HUBQ1cSgxvX4Aks3pAlRm9mqp
         FWyVnXEyvuemmnd4zgUKwROlsw/rejIqX0MwUKbaivjNhxl1lD1Um7GUxtCL+4B46g
         HR+OXdGHkTQQXP6TKIqK/BbebDgCO4l49GuwbVwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 172/879] bnxt_en: Configure ptp filters during bnxt open
Date:   Tue,  7 Jun 2022 18:54:50 +0200
Message-Id: <20220607165007.705141014@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 11862689e8f117e4702f55000790d7bce6859e84 ]

For correctness, we need to configure the packet filters for timestamping
during bnxt_open.  This way they are always configured after firmware
reset or chip reset.  We should not assume that the filters will always
be retained across resets.

This patch modifies the ioctl handler and always configures the PTP
filters in the bnxt_open() path.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 56 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  2 +
 3 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1d69fe0737a1..d5149478a351 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10363,6 +10363,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (BNXT_PF(bp))
 		bnxt_vf_reps_open(bp);
 	bnxt_ptp_init_rtc(bp, true);
+	bnxt_ptp_cfg_tstamp_filters(bp);
 	return 0;
 
 open_err_irq:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 00f2f80c0073..f9c94e5fe718 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -295,6 +295,27 @@ static int bnxt_ptp_cfg_event(struct bnxt *bp, u8 event)
 	return hwrm_req_send(bp, req);
 }
 
+void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct hwrm_port_mac_cfg_input *req;
+
+	if (!ptp || !ptp->tstamp_filters)
+		return;
+
+	if (hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG))
+		goto out;
+	req->flags = cpu_to_le32(ptp->tstamp_filters);
+	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
+	req->rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
+
+	if (!hwrm_req_send(bp, req))
+		return;
+	ptp->tstamp_filters = 0;
+out:
+	netdev_warn(bp->dev, "Failed to configure HW packet timestamp filters\n");
+}
+
 void bnxt_ptp_reapply_pps(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -435,27 +456,36 @@ static int bnxt_ptp_enable(struct ptp_clock_info *ptp_info,
 static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	struct hwrm_port_mac_cfg_input *req;
 	u32 flags = 0;
-	int rc;
+	int rc = 0;
 
-	rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
-	if (rc)
-		return rc;
+	switch (ptp->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		flags = PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		flags = PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_ENABLE;
+		break;
+	}
 
-	if (ptp->rx_filter)
-		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_ENABLE;
-	else
-		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
 	if (ptp->tx_tstamp_en)
 		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_ENABLE;
 	else
 		flags |= PORT_MAC_CFG_REQ_FLAGS_PTP_TX_TS_CAPTURE_DISABLE;
-	req->flags = cpu_to_le32(flags);
-	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
-	req->rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
 
-	return hwrm_req_send(bp, req);
+	ptp->tstamp_filters = flags;
+
+	if (netif_running(bp->dev)) {
+		rc = bnxt_close_nic(bp, false, false);
+		if (!rc)
+			rc = bnxt_open_nic(bp, false, false);
+		if (!rc && !ptp->tstamp_filters)
+			rc = -EIO;
+	}
+
+	return rc;
 }
 
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 530b9922608c..4ce0a14c1e23 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -113,6 +113,7 @@ struct bnxt_ptp_cfg {
 					 BNXT_PTP_MSG_PDELAY_RESP)
 	u8			tx_tstamp_en:1;
 	int			rx_filter;
+	u32			tstamp_filters;
 
 	u32			refclk_regs[2];
 	u32			refclk_mapped_regs[2];
@@ -133,6 +134,7 @@ do {						\
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off);
 void bnxt_ptp_update_current_time(struct bnxt *bp);
 void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2);
+void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp);
 void bnxt_ptp_reapply_pps(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
-- 
2.35.1



