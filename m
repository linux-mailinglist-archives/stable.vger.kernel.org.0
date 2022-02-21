Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFC14BE0A1
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350784AbiBUJjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351133AbiBUJgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067E22D1C3;
        Mon, 21 Feb 2022 01:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D658960DDF;
        Mon, 21 Feb 2022 09:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEFCC340E9;
        Mon, 21 Feb 2022 09:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434916;
        bh=7EPgk5fdkJPj4p2UiZeTX4V6iHWNa0qGPMOimL8QNYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ud0lffS6tQeX4QeNlGwtsII/Mwh62/K4eygDYTaRcWWVydx7wpMIGsKn5QXIusyEW
         cgRjSVlQb9l7Ua12JK+yudvjqdTi1Y3xpZ7AWVEzXIZBaLsWZFjYkmVcOOe15nkjX1
         MUKy5cUA7QJtprg+ESHbKZlOK43spXruXcce6liw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 176/196] scsi: lpfc: Fix pt2pt NVMe PRLI reject LOGO loop
Date:   Mon, 21 Feb 2022 09:50:08 +0100
Message-Id: <20220221084936.844319285@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 7f4c5a26f735dea4bbc0eb8eb9da99cda95a8563 upstream.

When connected point to point, the driver does not know the FC4's supported
by the other end. In Fabrics, it can query the nameserver.  Thus the driver
must send PRLIs for the FC4s it supports and enable support based on the
acc(ept) or rej(ect) of the respective FC4 PRLI.  Currently the driver
supports SCSI and NVMe PRLIs.

Unfortunately, although the behavior is per standard, many devices have
come to expect only SCSI PRLIs. In this particular example, the NVMe PRLI
is properly RJT'd but the target decided that it must LOGO after seeing the
unexpected NVMe PRLI. The LOGO causes the sequence to restart and login is
now in an infinite failure loop.

Fix the problem by having the driver, on a pt2pt link, remember NVMe PRLI
accept or reject status across logout as long as the link stays "up".  When
retrying login, if the prior NVMe PRLI was rejected, it will not be sent on
the next login.

Link: https://lore.kernel.org/r/20220212163120.15385-1-jsmart2021@gmail.com
Cc: <stable@vger.kernel.org> # v5.4+
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc.h           |    1 +
 drivers/scsi/lpfc/lpfc_attr.c      |    3 +++
 drivers/scsi/lpfc/lpfc_els.c       |   20 +++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c |    5 +++--
 4 files changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -593,6 +593,7 @@ struct lpfc_vport {
 #define FC_VPORT_LOGO_RCVD      0x200    /* LOGO received on vport */
 #define FC_RSCN_DISCOVERY       0x400	 /* Auth all devices after RSCN */
 #define FC_LOGO_RCVD_DID_CHNG   0x800    /* FDISC on phys port detect DID chng*/
+#define FC_PT2PT_NO_NVME        0x1000   /* Don't send NVME PRLI */
 #define FC_SCSI_SCAN_TMO        0x4000	 /* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	 /* NPort discovery active */
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
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1072,7 +1072,8 @@ stop_rr_fcf_flogi:
 
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
+		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP |
+				    FC_PT2PT_NO_NVME);
 		spin_unlock_irq(shost->host_lock);
 
 		/* If private loop, then allow max outstanding els to be
@@ -4587,6 +4588,23 @@ lpfc_els_retry(struct lpfc_hba *phba, st
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
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1961,8 +1961,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct
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


