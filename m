Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE98C113468
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfLDSCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbfLDSCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:43 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC2D20866;
        Wed,  4 Dec 2019 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482563;
        bh=poSnDsvPsg/90yXZWqvab0LWmzg7URnQduqv7u2/3mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHpShgFO6PlQzDWPW3/Qu3fY04GStTpyVCgxpELkX92DRP/F4+ND+9BEX+XBg+huu
         SScZrqHisL15CsRxsX1/jyyFP5dTYwIB7n9pb1JEuQzx3uv6lbkqzAVkFTnBgYN1Ts
         vId+l/L3fSKA0SDdQvVo0gXrV8L2OqyVnfaYNCtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/209] scsi: lpfc: Enable Management features for IF_TYPE=6
Date:   Wed,  4 Dec 2019 18:54:16 +0100
Message-Id: <20191204175324.443182466@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 719162bd5bb968203397b9b1d0dd30a9797bbd09 ]

Addition of support for if_type=6 missed several checks for interface type,
resulting in the failure of several key management features such as
firmware dump and loopback testing.

Correct the checks on the if_type so that both SLI4 IF_TYPE's 2 and 6 are
supported.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 4 ++--
 drivers/scsi/lpfc/lpfc_bsg.c     | 6 +++---
 drivers/scsi/lpfc/lpfc_els.c     | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3da242201cb45..82ce5d1930189 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1178,7 +1178,7 @@ lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 		return -EACCES;
 
 	if ((phba->sli_rev < LPFC_SLI_REV4) ||
-	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	     LPFC_SLI_INTF_IF_TYPE_2))
 		return -EPERM;
 
@@ -4056,7 +4056,7 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	uint32_t prev_val, if_type;
 
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
-	if (if_type == LPFC_SLI_INTF_IF_TYPE_2 &&
+	if (if_type >= LPFC_SLI_INTF_IF_TYPE_2 &&
 	    phba->hba_flag & HBA_FORCED_LINK_SPEED)
 		return -EPERM;
 
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d89816222b230..6dde21dc82a3c 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2221,7 +2221,7 @@ lpfc_bsg_diag_loopback_mode(struct bsg_job *job)
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		rc = lpfc_sli3_bsg_diag_loopback_mode(phba, job);
-	else if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+	else if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 		 LPFC_SLI_INTF_IF_TYPE_2)
 		rc = lpfc_sli4_bsg_diag_loopback_mode(phba, job);
 	else
@@ -2261,7 +2261,7 @@ lpfc_sli4_bsg_diag_mode_end(struct bsg_job *job)
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		return -ENODEV;
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -ENODEV;
 
@@ -2353,7 +2353,7 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 		rc = -ENODEV;
 		goto job_error;
 	}
-	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		rc = -ENODEV;
 		goto job_error;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a31f87eb1e621..c851fd14ff3e9 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5550,7 +5550,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	struct ls_rjt stat;
 
 	if (phba->sli_rev < LPFC_SLI_REV4 ||
-	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 						LPFC_SLI_INTF_IF_TYPE_2) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		rjt_expl = LSEXP_REQ_UNSUPPORTED;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d850077c5e226..3f88f3d796227 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4769,7 +4769,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				if (phba->sli_rev == LPFC_SLI_REV4 &&
 				    (!(vport->load_flag & FC_UNLOADING)) &&
 				    (bf_get(lpfc_sli_intf_if_type,
-				     &phba->sli4_hba.sli_intf) ==
+				     &phba->sli4_hba.sli_intf) >=
 				      LPFC_SLI_INTF_IF_TYPE_2) &&
 				    (kref_read(&ndlp->kref) > 0)) {
 					mbox->context1 = lpfc_nlp_get(ndlp);
-- 
2.20.1



