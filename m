Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E37E2E6508
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389367AbgL1Nfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:35:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389360AbgL1Nfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:35:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7DC0205CB;
        Mon, 28 Dec 2020 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162515;
        bh=oWdZEh3yVi7ZbfrCYKGw3o1vNbUgx3LgvH41n+SR7tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6SFXRDl/uUkwd4FNizR1C0RiN7Mh4ADlr7gcqto4fHH83NTojjoeepD1EUs1rW8F
         uFfjKhPy18PoJnDFabadTA08JjtjeWLocc7VWZBrl9OA07SwPuLHlWKojomSmJbm7J
         +IA+5VJIooYKsHg/bAROfPBpT9vjzgysyHOQwOds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 326/346] scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()
Date:   Mon, 28 Dec 2020 13:50:45 +0100
Message-Id: <20201228124935.546086922@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <james.smart@broadcom.com>

commit 62e3a931db60daf94fdb3159d685a5bc6ad4d0cf upstream.

The following calltrace was seen:

BUG: sleeping function called from invalid context at mm/slab.h:494
...
Call Trace:
 dump_stack+0x9a/0xf0
 ___might_sleep.cold.63+0x13d/0x178
 slab_pre_alloc_hook+0x6a/0x90
 kmem_cache_alloc_trace+0x3a/0x2d0
 lpfc_sli4_nvmet_alloc+0x4c/0x280 [lpfc]
 lpfc_post_rq_buffer+0x2e7/0xa60 [lpfc]
 lpfc_sli4_hba_setup+0x6b4c/0xa4b0 [lpfc]
 lpfc_pci_probe_one_s4.isra.15+0x14f8/0x2280 [lpfc]
 lpfc_pci_probe_one+0x260/0x2880 [lpfc]
 local_pci_probe+0xd4/0x180
 work_for_cpu_fn+0x51/0xa0
 process_one_work+0x8f0/0x17b0
 worker_thread+0x536/0xb50
 kthread+0x30c/0x3d0
 ret_from_fork+0x3a/0x50

A prior patch introduced a spin_lock_irqsave(hbalock) in the
lpfc_post_rq_buffer() routine. Call trace is seen as the hbalock is held
with interrupts disabled during a GFP_KERNEL allocation in
lpfc_sli4_nvmet_alloc().

Fix by reordering locking so that hbalock not held when calling
sli4_nvmet_alloc() (aka rqb_buf_list()).

Link: https://lore.kernel.org/r/20201020202719.54726-2-james.smart@broadcom.com
Fixes: 411de511c694 ("scsi: lpfc: Fix RQ empty firmware trap")
Cc: <stable@vger.kernel.org> # v4.17+
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_mem.c |    4 +---
 drivers/scsi/lpfc/lpfc_sli.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -560,8 +560,6 @@ lpfc_els_hbq_free(struct lpfc_hba *phba,
  * Description: Allocates a DMA-mapped receive buffer from the lpfc_hrb_pool PCI
  * pool along a non-DMA-mapped container for it.
  *
- * Notes: Not interrupt-safe.  Must be called with no locks held.
- *
  * Returns:
  *   pointer to HBQ on success
  *   NULL on failure
@@ -631,7 +629,7 @@ lpfc_sli4_nvmet_alloc(struct lpfc_hba *p
 {
 	struct rqb_dmabuf *dma_buf;
 
-	dma_buf = kzalloc(sizeof(struct rqb_dmabuf), GFP_KERNEL);
+	dma_buf = kzalloc(sizeof(*dma_buf), GFP_KERNEL);
 	if (!dma_buf)
 		return NULL;
 
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6755,12 +6755,16 @@ lpfc_post_rq_buffer(struct lpfc_hba *phb
 	struct rqb_dmabuf *rqb_buffer;
 	LIST_HEAD(rqb_buf_list);
 
-	spin_lock_irqsave(&phba->hbalock, flags);
 	rqbp = hrq->rqbp;
 	for (i = 0; i < count; i++) {
+		spin_lock_irqsave(&phba->hbalock, flags);
 		/* IF RQ is already full, don't bother */
-		if (rqbp->buffer_count + i >= rqbp->entry_count - 1)
+		if (rqbp->buffer_count + i >= rqbp->entry_count - 1) {
+			spin_unlock_irqrestore(&phba->hbalock, flags);
 			break;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+
 		rqb_buffer = rqbp->rqb_alloc_buffer(phba);
 		if (!rqb_buffer)
 			break;
@@ -6769,6 +6773,8 @@ lpfc_post_rq_buffer(struct lpfc_hba *phb
 		rqb_buffer->idx = idx;
 		list_add_tail(&rqb_buffer->hbuf.list, &rqb_buf_list);
 	}
+
+	spin_lock_irqsave(&phba->hbalock, flags);
 	while (!list_empty(&rqb_buf_list)) {
 		list_remove_head(&rqb_buf_list, rqb_buffer, struct rqb_dmabuf,
 				 hbuf.list);


