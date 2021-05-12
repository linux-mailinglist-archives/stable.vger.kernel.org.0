Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6519337CDDF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245633AbhELQ7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243408AbhELQlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB80161E3D;
        Wed, 12 May 2021 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835437;
        bh=Eaa5tXe1Ze7BD2RElB3GCpEaBQvqZa1KTVh96ShBquk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v31R8XPDanox58fLe4OFCsZzQL1ve8VmSU/1YVkAtNtFoe0sunrbGI8NuniCA30fD
         s1HEY2ukOmeVNnOq9PbV+D5rEZ6kXSK8zMkVq1OHEsz8fyhCcis4BaJVaS3a2K4/8Y
         ovy2q+2CIRaWoFhjiuacw6KgX6dFeAuMzclE3tIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 345/677] scsi: lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
Date:   Wed, 12 May 2021 16:46:31 +0200
Message-Id: <20210512144848.763869683@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 8dd1c125f7f838abad009b64bff5f0a11afe3cb6 ]

It is possible to call lpfc_issue_els_plogi() passing a did for which no
matching ndlp is found. A call is then made to lpfc_prep_els_iocb() with a
null pointer to a lpfc_nodelist structure resulting in a null pointer
dereference.

Fix by returning an error status if no valid ndlp is found. Fix up comments
regarding ndlp reference counting.

Link: https://lore.kernel.org/r/20210301171821.3427-10-jsmart2021@gmail.com
Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taking")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 50 +++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fd18ac2acc13..3dd22da3153f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -2044,13 +2044,12 @@ out_freeiocb:
  * This routine issues a Port Login (PLOGI) command to a remote N_Port
  * (with the @did) for a @vport. Before issuing a PLOGI to a remote N_Port,
  * the ndlp with the remote N_Port DID must exist on the @vport's ndlp list.
- * This routine constructs the proper feilds of the PLOGI IOCB and invokes
+ * This routine constructs the proper fields of the PLOGI IOCB and invokes
  * the lpfc_sli_issue_iocb() routine to send out PLOGI ELS command.
  *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the PLOGI ELS command.
+ * Note that the ndlp reference count will be incremented by 1 for holding
+ * the ndlp and the reference to ndlp will be stored into the context1 field
+ * of the IOCB for the completion callback function to the PLOGI ELS command.
  *
  * Return code
  *   0 - Successfully issued a plogi for @vport
@@ -2068,29 +2067,28 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	int ret;
 
 	ndlp = lpfc_findnode_did(vport, did);
+	if (!ndlp)
+		return 1;
 
-	if (ndlp) {
-		/* Defer the processing of the issue PLOGI until after the
-		 * outstanding UNREG_RPI mbox command completes, unless we
-		 * are going offline. This logic does not apply for Fabric DIDs
-		 */
-		if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
-		    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
-		    !(vport->fc_flag & FC_OFFLINE_MODE)) {
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-					 "4110 Issue PLOGI x%x deferred "
-					 "on NPort x%x rpi x%x Data: x%px\n",
-					 ndlp->nlp_defer_did, ndlp->nlp_DID,
-					 ndlp->nlp_rpi, ndlp);
-
-			/* We can only defer 1st PLOGI */
-			if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
-				ndlp->nlp_defer_did = did;
-			return 0;
-		}
+	/* Defer the processing of the issue PLOGI until after the
+	 * outstanding UNREG_RPI mbox command completes, unless we
+	 * are going offline. This logic does not apply for Fabric DIDs
+	 */
+	if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
+	    ((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+	    !(vport->fc_flag & FC_OFFLINE_MODE)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+				 "4110 Issue PLOGI x%x deferred "
+				 "on NPort x%x rpi x%x Data: x%px\n",
+				 ndlp->nlp_defer_did, ndlp->nlp_DID,
+				 ndlp->nlp_rpi, ndlp);
+
+		/* We can only defer 1st PLOGI */
+		if (ndlp->nlp_defer_did == NLP_EVT_NOTHING_PENDING)
+			ndlp->nlp_defer_did = did;
+		return 0;
 	}
 
-	/* If ndlp is not NULL, we will bump the reference count on it */
 	cmdsize = (sizeof(uint32_t) + sizeof(struct serv_parm));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp, did,
 				     ELS_CMD_PLOGI);
-- 
2.30.2



