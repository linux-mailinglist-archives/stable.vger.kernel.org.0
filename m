Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EE9595066
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiHPEmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiHPEk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71237A50D7;
        Mon, 15 Aug 2022 13:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C25F61135;
        Mon, 15 Aug 2022 20:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA508C433C1;
        Mon, 15 Aug 2022 20:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595504;
        bh=R/At1t9T/s5vQ8EISqjT+r83HIzdpkzNvMU24MJzUtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgkqSJz3GORjINSj6JW8RyzqzZgpSsFTvIiSo4l6xtL7L9bWbp0sNX7Mf611UEY4j
         y7rsmNcC5zP8GGStYOF3xRpqs9fKmU0ep8olnGa05ys3Lm94DL6P2FlzMsjniS54Sf
         MpPbXf5kwPN3LHBUFO3urY+Qj8HsDz5IqXT13FBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0785/1157] scsi: lpfc: Revert RSCN_MEMENTO workaround for misbehaved configuration
Date:   Mon, 15 Aug 2022 20:02:21 +0200
Message-Id: <20220815180510.890411088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit ffc566411aded3c12c63e1310fb23830e9608c59 ]

The RSCN_MEMENTO logic was to workaround a target that does not register
both FCP and NVMe FC4 types at the same time.  This caused the
configuration to not produce a second RSCN for the NVMe FC4 type
registration in a timely manner.  The intention of the RSCN_MEMENTO flag
was to always signal to try NVMe PRLI.

However, there are other FCP-only target arrays in correctly behaved
configurations that reject the NVMe PRLI followed by a LOGO leading to
never rediscovering the target after an issue_lip (as LOGO causes a repeat
of PLOGI/PRLIs).

Revert the RSCN_MEMENTO patch as it is causing correctly behaved configs to
fail while it exists only to succeed on a misbehaved config.

Link: https://lore.kernel.org/r/20220701211425.2708-9-jsmart2021@gmail.com
Fixes: 1045592fc968 ("scsi: lpfc: Introduce FC_RSCN_MEMENTO flag for tracking post RSCN completion")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         | 1 -
 drivers/scsi/lpfc/lpfc_els.c     | 8 ++------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 3 +--
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index da9070cdad91..212f9b962187 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -604,7 +604,6 @@ struct lpfc_vport {
 #define FC_VFI_REGISTERED	0x800000 /* VFI is registered */
 #define FC_FDISC_COMPLETED	0x1000000/* FDISC completed */
 #define FC_DISC_DELAYED		0x2000000/* Delay NPort discovery */
-#define FC_RSCN_MEMENTO		0x4000000/* RSCN cmd processed */
 
 	uint32_t ct_flags;
 #define FC_CT_RFF_ID		0x1	 /* RFF_ID accepted by switch */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3fababb7c181..c904e9486b92 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1886,7 +1886,6 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 		else {
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag &= ~FC_RSCN_MODE;
-			vport->fc_flag |= FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 		}
 	}
@@ -2434,14 +2433,13 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	u32 local_nlp_type, elscmd;
 
 	/*
-	 * If discovery was kicked off from RSCN mode,
-	 * the FC4 types supported from a
+	 * If we are in RSCN mode, the FC4 types supported from a
 	 * previous GFT_ID command may not be accurate. So, if we
 	 * are a NVME Initiator, always look for the possibility of
 	 * the remote NPort beng a NVME Target.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    vport->fc_flag & (FC_RSCN_MODE | FC_RSCN_MEMENTO) &&
+	    vport->fc_flag & FC_RSCN_MODE &&
 	    vport->nvmei_support)
 		ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 	local_nlp_type = ndlp->nlp_fc4_type;
@@ -7915,7 +7913,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
 			vport->fc_flag |= FC_RSCN_MODE;
-			vport->fc_flag &= ~FC_RSCN_MEMENTO;
 			spin_unlock_irq(shost->host_lock);
 			if (rscn_cnt) {
 				cmd = vport->fc_rscn_id_list[rscn_cnt-1]->virt;
@@ -7965,7 +7962,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag |= FC_RSCN_MODE;
-	vport->fc_flag &= ~FC_RSCN_MEMENTO;
 	spin_unlock_irq(shost->host_lock);
 	vport->fc_rscn_id_list[vport->fc_rscn_id_cnt++] = pcmd;
 	/* Indicate we are done walking fc_rscn_id_list on this vport */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index fb36f26170e4..5cd838eac455 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1354,8 +1354,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 
 	spin_lock_irq(shost->host_lock);
 	vport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI | FC_ABORT_DISCOVERY |
-			    FC_RSCN_MEMENTO | FC_RSCN_MODE |
-			    FC_NLP_MORE | FC_RSCN_DISCOVERY);
+			    FC_RSCN_MODE | FC_NLP_MORE | FC_RSCN_DISCOVERY);
 	vport->fc_flag |= FC_NDISC_ACTIVE;
 	vport->fc_ns_retry = 0;
 	spin_unlock_irq(shost->host_lock);
-- 
2.35.1



