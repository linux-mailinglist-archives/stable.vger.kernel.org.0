Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4EC4B366F
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 17:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiBLQba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 11:31:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiBLQb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 11:31:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC9197;
        Sat, 12 Feb 2022 08:31:25 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id i30so21603739pfk.8;
        Sat, 12 Feb 2022 08:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cgdmAN3a6VJH5GpYyWYOh/m184wyLcFQeLeJ7uRNeRU=;
        b=VQEwsfd6B9fayCAMRo2RnLrWANS3NJR5d0f70x/7u4VBcqBEFvCcJekuY/IMIRF5q5
         0h8/sxkJp8oAfQV4PbNm2jpdof3TZm9Trq+bqMfaF0R6CpFarH9uUYb4BDDEnnElVnwE
         Dxuc8uPQg4ERZ+o809ucxZzFLNH0uqdeKKyrQY2/PkpxVue3vvJe7/N4Clh/ukZ3iJgL
         gFgG7UZ3N+98a3DyG+V93owsBEIanuJtMfoSkyBgi4x6gBCTCzVghNNfDvRkBWLQk+7H
         lY8iuyuv9+uIMg2HmAhRRk9q0bkhG0ZQgLH0CHkuedt7hemM8+vEsd04FhdDBFykYtOu
         nZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cgdmAN3a6VJH5GpYyWYOh/m184wyLcFQeLeJ7uRNeRU=;
        b=SvyOO3PnOdk2ovkjzz0Mdt7DM+Z9jt1QxDg56YIAyJYvv9Da/DPcPSBEIpcA7I3+gO
         V0payma/x/roKykTWvvL9AsOnUZEsHoeyxpSFbg5lnHMEnrEuka4dos7odL3tzFHT67z
         8+Bgt7y1503XOCRkg2uqDs4CVdcvtFVYU4ZFmKUj6w+xMVuTer3NZl8fsXeRJiG68I8n
         m69LByNbq+Lxw85d0glIOEHyYNCFdnXOKu8RIGPHIzkZI2k8V7sxsYhyDDCPQ7mcqqb8
         lMQ5kyiIKGXSm9uFcfUAy3VWfzkCsm6JFsb1WbiQKLoo6VrU39paqgAO2JiM8mNyxj2l
         BXfw==
X-Gm-Message-State: AOAM533fWhUOKsFZtP6rOL9EKeeXu0kHKhrmj4dSnDulCfn8Z6oakrxb
        qm14PJKf1qCSs9o+FtU0/RdBk7KjWjY=
X-Google-Smtp-Source: ABdhPJwiKQxSN4jA70P7H5F54eQQqIY2fbF7ThrkQIzifKifsYhFFfCDWPS4BR0BaQ9T4dFkFgwY5Q==
X-Received: by 2002:a63:f30e:: with SMTP id l14mr5378723pgh.410.1644683485147;
        Sat, 12 Feb 2022 08:31:25 -0800 (PST)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id m21sm31652146pfk.26.2022.02.12.08.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 08:31:24 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] lpfc: fix pt2pt nvme PRLI reject LOGO loop
Date:   Sat, 12 Feb 2022 08:31:20 -0800
Message-Id: <20220212163120.15385-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When connected point to point, the driver does not know the FC4's
supported by the other end. In Fabrics, it can query the nameserver.
Thus the driver must send PRLI's for the FC4s it supports and enable
support based on the acc(ept) or rej(ect) of the respective FC4 PRLI.
Currently the driver supports SCSI and NVMe PRLI's.

Unfortunately, although the behavior is per standard, many devices
have come to expect only SCSI PRLI's. In this particular example, the
NVMe PRLI is properly RJT'd but the target decided that it must LOGO after
seeing the unexpected NVMe PRLI. The LOGO causes the sequence to restart
and login is now in an infinite failure loop.

Fix the problem by having the driver, on a pt2pt link, remember NVMe PRLI
accept or reject status across logout as long as the link stays "up".
When retrying login, if the prior NVMe PRLI was rejected, it will not be
sent on the next login.

Cut against 5.18/scsi-queue

Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           |  1 +
 drivers/scsi/lpfc/lpfc_attr.c      |  3 +++
 drivers/scsi/lpfc/lpfc_els.c       | 20 +++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  5 +++--
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index a1e0a106c132..98cabe09c040 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -592,6 +592,7 @@ struct lpfc_vport {
 #define FC_VPORT_LOGO_RCVD      0x200    /* LOGO received on vport */
 #define FC_RSCN_DISCOVERY       0x400	 /* Auth all devices after RSCN */
 #define FC_LOGO_RCVD_DID_CHNG   0x800    /* FDISC on phys port detect DID chng*/
+#define FC_PT2PT_NO_NVME        0x1000   /* Don't send NVME PRLI */
 #define FC_SCSI_SCAN_TMO        0x4000	 /* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	 /* NPort discovery active */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index bac78fbce8d6..fa8415259cb8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1315,6 +1315,9 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	pmboxq->u.mb.mbxCommand = MBX_DOWN_LINK;
 	pmboxq->u.mb.mbxOwner = OWN_HOST;
 
+	if ((vport->fc_flag & FC_PT2PT) && (vport->fc_flag & FC_PT2PT_NO_NVME))
+		vport->fc_flag &= ~FC_PT2PT_NO_NVME;
+
 	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, LPFC_MBOX_TMO * 2);
 
 	if ((mbxstatus == MBX_SUCCESS) &&
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index db5ccae1b63d..f936833c9909 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1072,7 +1072,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
+		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP |
+				    FC_PT2PT_NO_NVME);
 		spin_unlock_irq(shost->host_lock);
 
 		/* If private loop, then allow max outstanding els to be
@@ -4607,6 +4608,23 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Added for Vendor specifc support
 		 * Just keep retrying for these Rsn / Exp codes
 		 */
+		if ((vport->fc_flag & FC_PT2PT) &&
+		    cmd == ELS_CMD_NVMEPRLI) {
+			switch (stat.un.b.lsRjtRsnCode) {
+			case LSRJT_UNABLE_TPC:
+			case LSRJT_INVALID_CMD:
+			case LSRJT_LOGICAL_ERR:
+			case LSRJT_CMD_UNSUPPORTED:
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+						 "0168 NVME PRLI LS_RJT "
+						 "reason %x port doesn't "
+						 "support NVME, disabling NVME\n",
+						 stat.un.b.lsRjtRsnCode);
+				retry = 0;
+				vport->fc_flag |= FC_PT2PT_NO_NVME;
+				goto out_retry;
+			}
+		}
 		switch (stat.un.b.lsRjtRsnCode) {
 		case LSRJT_UNABLE_TPC:
 			/* The driver has a VALID PLOGI but the rport has
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 7d717a4ac14d..fdf5e777bf11 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1961,8 +1961,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 			 * is configured try it.
 			 */
 			ndlp->nlp_fc4_type |= NLP_FC4_FCP;
-			if ((vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-			    (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+			if ((!(vport->fc_flag & FC_PT2PT_NO_NVME)) &&
+			    (vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH ||
+			    vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
 				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 				/* We need to update the localport also */
 				lpfc_nvme_update_localport(vport);
-- 
2.26.2

