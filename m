Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0204B7251
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbiBOPbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:31:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiBOPbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0265C3C38;
        Tue, 15 Feb 2022 07:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54579B81AF7;
        Tue, 15 Feb 2022 15:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A09C340F1;
        Tue, 15 Feb 2022 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938950;
        bh=+A0BhAIXlsnp7GZpkeSkeHuANSPvK7LmDOAax1IsR18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaWwyuwjvccpa8fLFDacqc1gSjZuuTTwA+7Eb/mae4qXBavsOQXx1M1FoEAf0nP8r
         1oaYj0kFaHUmPFUe2gsryATh13jnj248FJY2JHmim1m8sQUQIuCzS7A2wZ4dz3AgPR
         QpNvXhe7nF7dfFhBG6TZX81kElSebJqaeU0IKzWg/ncXeEQ/TNsU4QVq1SFqEkvFgW
         4ZlbBtWO+z6GGqmI5KXR9FXcfQeSsM4O3gBiQi8sNIX27akO7o38AU0GPhnO0NJUNp
         yNDxcUawtc7yCn1WMlMx1fuoA4mMHPQVVT5Yo9F8vFO8iEJjmWIA+qvfDvw0TKpXxY
         8fhkLv/Na3XOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/33] scsi: lpfc: Reduce log messages seen after firmware download
Date:   Tue, 15 Feb 2022 10:28:19 -0500
Message-Id: <20220215152831.580780-21-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 5852ed2a6a39c862c8a3fdf646e1f4e01b91d710 ]

Messages around firmware download were incorrectly tagged as being related
to discovery trace events. Thus, firmware download status ended up dumping
the trace log as well as the firmware update message. As there were a
couple of log messages in this state, the trace log was dumped multiple
times.

Resolve this by converting from trace events to SLI events.

Link: https://lore.kernel.org/r/20220207180442.72836-1-jsmart2021@gmail.com
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2bbd1be6cc5d4..3eebcae52784d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2055,7 +2055,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		}
 		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"3143 Port Down: Firmware Update "
 					"Detected\n");
 			en_rn_msg = false;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e5009f21d97e1..2978c61dc5863 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13366,6 +13366,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 	uint32_t uerr_sta_hi, uerr_sta_lo;
 	uint32_t if_type, portsmphr;
 	struct lpfc_register portstat_reg;
+	u32 logmask;
 
 	/*
 	 * For now, use the SLI4 device internal unrecoverable error
@@ -13416,7 +13417,12 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
 			phba->work_status[1] =
 				readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			logmask = LOG_TRACE_EVENT;
+			if (phba->work_status[0] ==
+				SLIPORT_ERR1_REG_ERR_CODE_2 &&
+			    phba->work_status[1] == SLIPORT_ERR2_REG_FW_RESTART)
+				logmask = LOG_SLI;
+			lpfc_printf_log(phba, KERN_ERR, logmask,
 					"2885 Port Status Event: "
 					"port status reg 0x%x, "
 					"port smphr reg 0x%x, "
-- 
2.34.1

