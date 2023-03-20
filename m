Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE966C1880
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbjCTPZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjCTPYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0720A468A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1EED6158B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DE5C433EF;
        Mon, 20 Mar 2023 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325474;
        bh=+lkgRQaE4nsE9iMGjMvVg25Rcgn49QxVrJToTJ1I3Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOyJGY1AgC2UYh3xSV+TohEQPrKYAJzuMP+2+M1/8PDxm6k+wG6sEWgQb++xmLHlS
         zRTCFR6ofvfWfQxB/8KrjOET2dNMfxmrt7xa9CVupC/dD5L7D8p7T+Y16AShIvMOPG
         kD25BcT7pbmpB4KyrHFoaPV+sMB8kV5eO2XNgNxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vadim Fedorenko <vadfed@meta.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/211] bnxt_en: reset PHC frequency in free-running mode
Date:   Mon, 20 Mar 2023 15:53:02 +0100
Message-Id: <20230320145515.199436863@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 131db499162274858bdbd7b5323a639da4aab86c ]

When using a PHC in shared between multiple hosts, the previous
frequency value may not be reset and could lead to host being unable to
compensate the offset with timecounter adjustments. To avoid such state
reset the hardware frequency of PHC to zero on init. Some refactoring is
needed to make code readable.

Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clock")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230310151356.678059-1-vadfed@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 56 ++++++++++---------
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 25d1642c10c3b..b44b2ec5e61a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6991,11 +6991,9 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 		if (flags & FUNC_QCFG_RESP_FLAGS_FW_DCBX_AGENT_ENABLED)
 			bp->fw_cap |= BNXT_FW_CAP_DCBX_AGENT;
 	}
-	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST)) {
+	if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
 		bp->flags |= BNXT_FLAG_MULTI_HOST;
-		if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
-			bp->fw_cap &= ~BNXT_FW_CAP_PTP_RTC;
-	}
+
 	if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
 		bp->fw_cap |= BNXT_FW_CAP_RING_MONITOR;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5163ef4a49ea3..56355e64815e2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1992,6 +1992,8 @@ struct bnxt {
 	u32			fw_dbg_cap;
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
+#define BNXT_PTP_USE_RTC(bp)	(!BNXT_MH(bp) && \
+				 ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
 	u32			hwrm_spec_code;
 	u16			hwrm_cmd_seq;
 	u16                     hwrm_cmd_kong_seq;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 4ec8bba18cdd2..a3a3978a4d1c2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -63,7 +63,7 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 						ptp_info);
 	u64 ns = timespec64_to_ns(ts);
 
-	if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+	if (BNXT_PTP_USE_RTC(ptp->bp))
 		return bnxt_ptp_cfg_settime(ptp->bp, ns);
 
 	spin_lock_bh(&ptp->ptp_lock);
@@ -196,7 +196,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
 
-	if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+	if (BNXT_PTP_USE_RTC(ptp->bp))
 		return bnxt_ptp_adjphc(ptp, delta);
 
 	spin_lock_bh(&ptp->ptp_lock);
@@ -205,34 +205,39 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
 	return 0;
 }
 
+static int bnxt_ptp_adjfine_rtc(struct bnxt *bp, long scaled_ppm)
+{
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
+	struct hwrm_port_mac_cfg_input *req;
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
+	if (rc)
+		return rc;
+
+	req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
+	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
+	rc = hwrm_req_send(bp, req);
+	if (rc)
+		netdev_err(bp->dev,
+			   "ptp adjfine failed. rc = %d\n", rc);
+	return rc;
+}
+
 static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 {
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
-	struct hwrm_port_mac_cfg_input *req;
 	struct bnxt *bp = ptp->bp;
-	int rc = 0;
 
-	if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
-		spin_lock_bh(&ptp->ptp_lock);
-		timecounter_read(&ptp->tc);
-		ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
-		spin_unlock_bh(&ptp->ptp_lock);
-	} else {
-		s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
-
-		rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
-		if (rc)
-			return rc;
+	if (BNXT_PTP_USE_RTC(bp))
+		return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
 
-		req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
-		req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
-		rc = hwrm_req_send(ptp->bp, req);
-		if (rc)
-			netdev_err(ptp->bp->dev,
-				   "ptp adjfine failed. rc = %d\n", rc);
-	}
-	return rc;
+	spin_lock_bh(&ptp->ptp_lock);
+	timecounter_read(&ptp->tc);
+	ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
+	spin_unlock_bh(&ptp->ptp_lock);
+	return 0;
 }
 
 void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2)
@@ -879,7 +884,7 @@ int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg)
 	u64 ns;
 	int rc;
 
-	if (!bp->ptp_cfg || !(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
+	if (!bp->ptp_cfg || !BNXT_PTP_USE_RTC(bp))
 		return -ENODEV;
 
 	if (!phc_cfg) {
@@ -932,13 +937,14 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-	if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+	if (BNXT_PTP_USE_RTC(bp)) {
 		bnxt_ptp_timecounter_init(bp, false);
 		rc = bnxt_ptp_init_rtc(bp, phc_cfg);
 		if (rc)
 			goto out;
 	} else {
 		bnxt_ptp_timecounter_init(bp, true);
+		bnxt_ptp_adjfine_rtc(bp, 0);
 	}
 
 	ptp->ptp_info = bnxt_ptp_caps;
-- 
2.39.2



