Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A251064AA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfKVGS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbfKVF4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84A92071F;
        Fri, 22 Nov 2019 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402161;
        bh=dBCcP/53ztF0HqHH8Txv7gIliGk08AtsfO2k9ZmOry8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhrZhRb5MLNCRo2N7IVgDAMm+8kbaQ4ItpZO6iUEMYEknE922vy9yiqBHcUF2hs41
         c4i+rxg5veiuSEpRsr5niZVhA4iAjb7oLD2IQOeFDi5fSZqIbYC+f82bsUp4OiaFtP
         N3eDBk/Dh1CU539XkAkSFYuMF/r3YlSrJdRDvb6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 015/127] scsi: lpfc: Enable Management features for IF_TYPE=6
Date:   Fri, 22 Nov 2019 00:53:53 -0500
Message-Id: <20191122055544.3299-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 0032465d1b630..63c1a81005e52 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5528,7 +5528,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	struct ls_rjt stat;
 
 	if (phba->sli_rev < LPFC_SLI_REV4 ||
-	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 						LPFC_SLI_INTF_IF_TYPE_2) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		rjt_expl = LSEXP_REQ_UNSUPPORTED;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b970933a218d5..424e870676046 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4749,7 +4749,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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

