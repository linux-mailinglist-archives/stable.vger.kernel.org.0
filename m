Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4DE540947
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349208AbiFGSHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350874AbiFGSB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:01:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A648E14CDFB;
        Tue,  7 Jun 2022 10:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48748B820C3;
        Tue,  7 Jun 2022 17:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C051C385A5;
        Tue,  7 Jun 2022 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623816;
        bh=BjFaylm2xoDLRTc7SGKPyPcDshefYIMRBwxyeQM9sWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6zDaGaMCmFj/yIJx5ul7BIa/nvtAbFd32wwvBKr7qlmGp6XxZbfPJGaNj9adafoN
         9d8pDul+1Do32FVfCwH0qYb8j5YCQ1czKUDp5+u+78dU80+TErSkoDU5eUkBwmtVfm
         IFZodESRi6YUskbsWReZs5Plu88IDFzS9TqnRTZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/667] scsi: lpfc: Alter FPIN stat accounting logic
Date:   Tue,  7 Jun 2022 18:56:08 +0200
Message-Id: <20220607164937.911486411@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e6f51041450282a8668af3a8fc5c7744e81a447c ]

When configuring CMF management based on signals instead of FPINs, FPIN
alarm and warning statistics are not tracked.

Change the behavior so that FPIN alarms and warnings are always tracked
regardless of the configured mode.

Similar changes are made in the CMF signal stat accounting logic.  Upon
receipt of a signal, only track signaled alarms and warnings. FPIN stats
should not be incremented upon receipt of a signal.

Link: https://lore.kernel.org/r/20220506035519.50908-11-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c  | 49 +++++++++++------------------------
 drivers/scsi/lpfc/lpfc_init.c | 22 ++--------------
 2 files changed, 17 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 886006ad12a2..ce28c4a30460 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3777,9 +3777,6 @@ lpfc_least_capable_settings(struct lpfc_hba *phba,
 {
 	u32 rsp_sig_cap = 0, drv_sig_cap = 0;
 	u32 rsp_sig_freq_cyc = 0, rsp_sig_freq_scale = 0;
-	struct lpfc_cgn_info *cp;
-	u32 crc;
-	u16 sig_freq;
 
 	/* Get rsp signal and frequency capabilities.  */
 	rsp_sig_cap = be32_to_cpu(pcgd->xmt_signal_capability);
@@ -3835,25 +3832,7 @@ lpfc_least_capable_settings(struct lpfc_hba *phba,
 		}
 	}
 
-	if (!phba->cgn_i)
-		return;
-
-	/* Update signal frequency in congestion info buffer */
-	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
-
-	/* Frequency (in ms) Signal Warning/Signal Congestion Notifications
-	 * are received by the HBA
-	 */
-	sig_freq = phba->cgn_sig_freq;
-
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY)
-		cp->cgn_warn_freq = cpu_to_le16(sig_freq);
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-		cp->cgn_alarm_freq = cpu_to_le16(sig_freq);
-		cp->cgn_warn_freq = cpu_to_le16(sig_freq);
-	}
-	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
-	cp->cgn_info_crc = cpu_to_le32(crc);
+	/* We are NOT recording signal frequency in congestion info buffer */
 	return;
 
 out_no_support:
@@ -9584,11 +9563,14 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 			/* Take action here for an Alarm event */
 			if (phba->cmf_active_mode != LPFC_CFG_OFF) {
 				if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_ALARM) {
-					/* Track of alarm cnt for cgn_info */
-					atomic_inc(&phba->cgn_fabric_alarm_cnt);
 					/* Track of alarm cnt for SYNC_WQE */
 					atomic_inc(&phba->cgn_sync_alarm_cnt);
 				}
+				/* Track alarm cnt for cgn_info regardless
+				 * of whether CMF is configured for Signals
+				 * or FPINs.
+				 */
+				atomic_inc(&phba->cgn_fabric_alarm_cnt);
 				goto cleanup;
 			}
 			break;
@@ -9596,11 +9578,14 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 			/* Take action here for a Warning event */
 			if (phba->cmf_active_mode != LPFC_CFG_OFF) {
 				if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_WARN) {
-					/* Track of warning cnt for cgn_info */
-					atomic_inc(&phba->cgn_fabric_warn_cnt);
 					/* Track of warning cnt for SYNC_WQE */
 					atomic_inc(&phba->cgn_sync_warn_cnt);
 				}
+				/* Track warning cnt and freq for cgn_info
+				 * regardless of whether CMF is configured for
+				 * Signals or FPINs.
+				 */
+				atomic_inc(&phba->cgn_fabric_warn_cnt);
 cleanup:
 				/* Save frequency in ms */
 				phba->cgn_fpin_frequency =
@@ -9609,14 +9594,10 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 				if (phba->cgn_i) {
 					cp = (struct lpfc_cgn_info *)
 						phba->cgn_i->virt;
-					if (phba->cgn_reg_fpin &
-						LPFC_CGN_FPIN_ALARM)
-						cp->cgn_alarm_freq =
-							cpu_to_le16(value);
-					if (phba->cgn_reg_fpin &
-						LPFC_CGN_FPIN_WARN)
-						cp->cgn_warn_freq =
-							cpu_to_le16(value);
+					cp->cgn_alarm_freq =
+						cpu_to_le16(value);
+					cp->cgn_warn_freq =
+						cpu_to_le16(value);
 					crc = lpfc_cgn_calc_crc32
 						(cp,
 						LPFC_CGN_INFO_SZ,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ce103c1f8062..a2694fb32b5d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5795,21 +5795,8 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 
 	/* Use the frequency found in the last rcv'ed FPIN */
 	value = phba->cgn_fpin_frequency;
-	if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_WARN)
-		cp->cgn_warn_freq = cpu_to_le16(value);
-	if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_ALARM)
-		cp->cgn_alarm_freq = cpu_to_le16(value);
-
-	/* Frequency (in ms) Signal Warning/Signal Congestion Notifications
-	 * are received by the HBA
-	 */
-	value = phba->cgn_sig_freq;
-
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
-	    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM)
-		cp->cgn_warn_freq = cpu_to_le16(value);
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM)
-		cp->cgn_alarm_freq = cpu_to_le16(value);
+	cp->cgn_warn_freq = cpu_to_le16(value);
+	cp->cgn_alarm_freq = cpu_to_le16(value);
 
 	lvalue = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				     LPFC_CGN_CRC32_SEED);
@@ -6493,9 +6480,6 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 		/* Alarm overrides warning, so check that first */
 		if (cgn_signal->alarm_cnt) {
 			if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-				/* Keep track of alarm cnt for cgn_info */
-				atomic_add(cgn_signal->alarm_cnt,
-					   &phba->cgn_fabric_alarm_cnt);
 				/* Keep track of alarm cnt for CMF_SYNC_WQE */
 				atomic_add(cgn_signal->alarm_cnt,
 					   &phba->cgn_sync_alarm_cnt);
@@ -6504,8 +6488,6 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 			/* signal action needs to be taken */
 			if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
 			    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-				/* Keep track of warning cnt for cgn_info */
-				atomic_add(cnt, &phba->cgn_fabric_warn_cnt);
 				/* Keep track of warning cnt for CMF_SYNC_WQE */
 				atomic_add(cnt, &phba->cgn_sync_warn_cnt);
 			}
-- 
2.35.1



