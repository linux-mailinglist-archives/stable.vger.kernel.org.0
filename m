Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31F514568E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbgAVN1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgAVN1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:46 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 891182467B;
        Wed, 22 Jan 2020 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699665;
        bh=0s1L4NZLSb/p28c3fPgPLD6XN3jAQhqpj9KMFVolbOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHB9tReNBFPnhQgP9YoY5q+3yyu2TsfAIEjexiF60RN6KCIf8X65fkTM0zU4YAALh
         Tm5KFBh7DpnRPL5IvbEgjrCNpf+JNThBBF96NczI5iGtbAFRDJXWTeIDebU0lw6KKp
         pPeKLngI5dgZOClc5H1dzf6b2cUA9PpYGfTx4hiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 212/222] scsi: lpfc: Fix hdwq sgl locks and irq handling
Date:   Wed, 22 Jan 2020 10:29:58 +0100
Message-Id: <20200122092848.874374835@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit a4c21acca2be6729ecbe72eda9b08092725b0a77 upstream.

Many of the sgl-per-hdwq paths are locking with spin_lock_irq() and
spin_unlock_irq() and may unwittingly raising irq when it shouldn't. Hard
deadlocks were seen around lpfc_scsi_prep_cmnd().

Fix by converting the locks to irqsave/irqrestore.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Link: https://lore.kernel.org/r/20190922035906.10977-16-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_sli.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20414,8 +20414,9 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *p
 	struct sli4_hybrid_sgl *allocated_sgl = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->sgl_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(buf_list))) {
 		/* break off 1 chunk from the sgl_list */
@@ -20427,7 +20428,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *p
 		}
 	} else {
 		/* allocate more */
-		spin_unlock_irq(&hdwq->hdwq_lock);
+		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
 				   cpu_to_node(smp_processor_id()));
 		if (!tmp) {
@@ -20449,7 +20450,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *p
 			return NULL;
 		}
 
-		spin_lock_irq(&hdwq->hdwq_lock);
+		spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 		list_add_tail(&tmp->list_node, &lpfc_buf->dma_sgl_xtra_list);
 	}
 
@@ -20457,7 +20458,7 @@ lpfc_get_sgl_per_hdwq(struct lpfc_hba *p
 					struct sli4_hybrid_sgl,
 					list_node);
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 
 	return allocated_sgl;
 }
@@ -20481,8 +20482,9 @@ lpfc_put_sgl_per_hdwq(struct lpfc_hba *p
 	struct sli4_hybrid_sgl *tmp = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->sgl_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(&lpfc_buf->dma_sgl_xtra_list))) {
 		list_for_each_entry_safe(list_entry, tmp,
@@ -20495,7 +20497,7 @@ lpfc_put_sgl_per_hdwq(struct lpfc_hba *p
 		rc = -EINVAL;
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 	return rc;
 }
 
@@ -20516,8 +20518,9 @@ lpfc_free_sgl_per_hdwq(struct lpfc_hba *
 	struct list_head *buf_list = &hdwq->sgl_list;
 	struct sli4_hybrid_sgl *list_entry = NULL;
 	struct sli4_hybrid_sgl *tmp = NULL;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	/* Free sgl pool */
 	list_for_each_entry_safe(list_entry, tmp,
@@ -20529,7 +20532,7 @@ lpfc_free_sgl_per_hdwq(struct lpfc_hba *
 		kfree(list_entry);
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }
 
 /**
@@ -20553,8 +20556,9 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpf
 	struct fcp_cmd_rsp_buf *allocated_buf = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(buf_list))) {
 		/* break off 1 chunk from the list */
@@ -20567,7 +20571,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpf
 		}
 	} else {
 		/* allocate more */
-		spin_unlock_irq(&hdwq->hdwq_lock);
+		spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 		tmp = kmalloc_node(sizeof(*tmp), GFP_ATOMIC,
 				   cpu_to_node(smp_processor_id()));
 		if (!tmp) {
@@ -20594,7 +20598,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpf
 		tmp->fcp_rsp = (struct fcp_rsp *)((uint8_t *)tmp->fcp_cmnd +
 				sizeof(struct fcp_cmnd));
 
-		spin_lock_irq(&hdwq->hdwq_lock);
+		spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 		list_add_tail(&tmp->list_node, &lpfc_buf->dma_cmd_rsp_list);
 	}
 
@@ -20602,7 +20606,7 @@ lpfc_get_cmd_rsp_buf_per_hdwq(struct lpf
 					struct fcp_cmd_rsp_buf,
 					list_node);
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 
 	return allocated_buf;
 }
@@ -20627,8 +20631,9 @@ lpfc_put_cmd_rsp_buf_per_hdwq(struct lpf
 	struct fcp_cmd_rsp_buf *tmp = NULL;
 	struct lpfc_sli4_hdw_queue *hdwq = lpfc_buf->hdwq;
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	if (likely(!list_empty(&lpfc_buf->dma_cmd_rsp_list))) {
 		list_for_each_entry_safe(list_entry, tmp,
@@ -20641,7 +20646,7 @@ lpfc_put_cmd_rsp_buf_per_hdwq(struct lpf
 		rc = -EINVAL;
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 	return rc;
 }
 
@@ -20662,8 +20667,9 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lp
 	struct list_head *buf_list = &hdwq->cmd_rsp_buf_list;
 	struct fcp_cmd_rsp_buf *list_entry = NULL;
 	struct fcp_cmd_rsp_buf *tmp = NULL;
+	unsigned long iflags;
 
-	spin_lock_irq(&hdwq->hdwq_lock);
+	spin_lock_irqsave(&hdwq->hdwq_lock, iflags);
 
 	/* Free cmd_rsp buf pool */
 	list_for_each_entry_safe(list_entry, tmp,
@@ -20676,5 +20682,5 @@ lpfc_free_cmd_rsp_buf_per_hdwq(struct lp
 		kfree(list_entry);
 	}
 
-	spin_unlock_irq(&hdwq->hdwq_lock);
+	spin_unlock_irqrestore(&hdwq->hdwq_lock, iflags);
 }


