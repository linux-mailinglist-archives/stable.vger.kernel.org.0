Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C97210664C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfKVFtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfKVFtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A470E2070A;
        Fri, 22 Nov 2019 05:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401789;
        bh=UTYmn8DqYjSelctZxEjZnjss11HE9pWu+vXQ0xjDNBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eong+io4zzgAriU0CmDZ37+T3F1MZ6X52F9MPqoUd2TM+OJOg0yHYAGVwbVwMIzif
         FSbm68jwzMbuXPKMPWf3FjXwLYt2+jHg2zXeSHtG2iErq7tnBMGbljAHBmydLmlsy4
         gK1LjyHhybmcuU9tIrTDLfnV6a6Cm5QsirDqwNLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 037/219] scsi: lpfc: Enable Management features for IF_TYPE=6
Date:   Fri, 22 Nov 2019 00:46:09 -0500
Message-Id: <20191122054911.1750-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 55cd96e2469c6..3f69a5e4e470a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1332,7 +1332,7 @@ lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 		return -EACCES;
 
 	if ((phba->sli_rev < LPFC_SLI_REV4) ||
-	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 	     LPFC_SLI_INTF_IF_TYPE_2))
 		return -EPERM;
 
@@ -4264,7 +4264,7 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	uint32_t prev_val, if_type;
 
 	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
-	if (if_type == LPFC_SLI_INTF_IF_TYPE_2 &&
+	if (if_type >= LPFC_SLI_INTF_IF_TYPE_2 &&
 	    phba->hba_flag & HBA_FORCED_LINK_SPEED)
 		return -EPERM;
 
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 90745feca8080..99aea52e584b0 100644
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
index 3651c0fc88197..d0cd368790a64 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5536,7 +5536,7 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	struct ls_rjt stat;
 
 	if (phba->sli_rev < LPFC_SLI_REV4 ||
-	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) <
 						LPFC_SLI_INTF_IF_TYPE_2) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		rjt_expl = LSEXP_REQ_UNSUPPORTED;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ccdd82b1123f7..1a6da347f00ad 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4751,7 +4751,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
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

