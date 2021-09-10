Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF77A406075
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhIJAR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhIJARZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D1A8611AD;
        Fri, 10 Sep 2021 00:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232975;
        bh=FD4ZGUYqAuTB2rsXK4lM19ioZ6WUKgfizpwaHDfNEbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9fIZ57Mo12uSb9VzB7tMRoge2oeiKeWRqIhl97sokO2U446eckepgKkSo8FS2rkE
         tFroswDlBb+Qi4W/EGeSojv1KOj952e1K6RrE8kmr/WQ2ipsbou6m8GvazCznZ1r3S
         vsrHMo+egsbDBKZ1tP4N0oacu+GSP8ebkfF+Z1f6Ai7Pgz6NFUzUlLmnp+WV7YjZXS
         VZa7iXJd5TN85haKfXLTxXQqHNJwctwlryF58JzNqf1LpeEmG3sg3Lb9FNye1o0qsK
         TqFx4c5GmnZwXWz47WSqTp0xgB6ExY9PHxW6vqqEeBVIf0q0SapjtdDdJmGF1JyIxg
         h57rBv1yn27+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 12/99] scsi: lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR request
Date:   Thu,  9 Sep 2021 20:14:31 -0400
Message-Id: <20210910001558.173296-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit cd6047e92c6a5b0a44479cf98f76aac56ddfe108 ]

The ELS job request structure, that is allocated while issuing ELS RDF/SCR
request path, is not being released in an error path causing a memory leak
message on driver unload.

Free the ELS job structure in the error paths.

Link: https://lore.kernel.org/r/20210707184351.67872-10-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b1ca6f8e5970..3381912bf982 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3375,6 +3375,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		rc = lpfc_reg_fab_ctrl_node(vport, ndlp);
 		if (rc) {
+			lpfc_els_free_iocb(phba, elsiocb);
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
 					 "0937 %s: Failed to reg fc node, rc %d\n",
 					 __func__, rc);
@@ -3667,6 +3668,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
 	    !(ndlp->nlp_flag & NLP_RPI_REGISTERED)) {
+		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
 				 "0939 %s: FC_NODE x%x RPI x%x flag x%x "
 				 "ste x%x type x%x Not registered\n",
-- 
2.30.2

