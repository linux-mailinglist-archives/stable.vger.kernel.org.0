Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B073D3A8B8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbfFIRDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388064AbfFIRDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48177204EC;
        Sun,  9 Jun 2019 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099815;
        bh=TZN9iRhipWXcbbEe+RiuGRmbFeYdckX4c8MXkXvOds0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxA0SuoCse7zlRdIU+zRBmi4J1JjLDVkQK8GA1FE4Z/yNQxHtoVw2QxtIk/sfAOT1
         NojfT0PQdXUQLuGYU0HqLCVW+0WkC3UGGezjBEkttwAZIfQE/NAuCv8+j1E8I57qqV
         /Ik9FFIUvUtw2t9MBvyC3EPXgtT+NS46lH45O2kY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 175/241] scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices
Date:   Sun,  9 Jun 2019 18:41:57 +0200
Message-Id: <20190609164152.865584477@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c95a3b4b0fb8d351e2329a96f87c4fc96a149505 ]

During debug, it was seen that the driver is issuing commands specific to
SLI3 on SLI4 devices. Although the adapter correctly rejected the command,
this should not be done.

Revise the code to stop sending these commands on a SLI4 adapter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4131addfb8729..a67950908db17 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -902,7 +902,11 @@ lpfc_linkdown(struct lpfc_hba *phba)
 			lpfc_linkdown_port(vports[i]);
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
-	/* Clean up any firmware default rpi's */
+
+	/* Clean up any SLI3 firmware default rpi's */
+	if (phba->sli_rev > LPFC_SLI_REV3)
+		goto skip_unreg_did;
+
 	mb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mb) {
 		lpfc_unreg_did(phba, 0xffff, LPFC_UNREG_ALL_DFLT_RPIS, mb);
@@ -914,6 +918,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		}
 	}
 
+ skip_unreg_did:
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->pport->fc_flag & FC_PT2PT) {
 		phba->pport->fc_myDID = 0;
@@ -4647,6 +4652,10 @@ lpfc_unreg_default_rpis(struct lpfc_vport *vport)
 	LPFC_MBOXQ_t     *mbox;
 	int rc;
 
+	/* Unreg DID is an SLI3 operation. */
+	if (phba->sli_rev > LPFC_SLI_REV3)
+		return;
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
 		lpfc_unreg_did(phba, vport->vpi, LPFC_UNREG_ALL_DFLT_RPIS,
-- 
2.20.1



