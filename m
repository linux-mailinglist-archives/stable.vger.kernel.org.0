Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BFBA9193
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbfIDSTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389710AbfIDSKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2A0E22CEA;
        Wed,  4 Sep 2019 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620617;
        bh=uQeyhzZSHktC3gO7yy/bA75Bn4klDUPmv1H47WmCn5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/ut3gXDbkWEambOEqVr/pP1lj50cp4ja2agGb/+5ZRgg7zPogPNon66fk2kfcY4z
         4N79eMY74cijaWCFfHDV6iIfRpJALZsv03wg7Qn7RlhR7HHcX/NhgEYkbYJPxD3MHQ
         2EV6715U4Wz+IIdn69XanFy+brh9Phq1kSt9rXl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oded Gabbay <oded.gabbay@gmail.com>,
        Ben Segal <bpsegal20@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 031/143] habanalabs: fix endianness handling for internal QMAN submission
Date:   Wed,  4 Sep 2019 19:52:54 +0200
Message-Id: <20190904175315.273249754@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9040c99414ba5b85090595a61abc686a5dbb388 ]

The PQs of internal H/W queues (QMANs) can be located in different memory
areas for different ASICs. Therefore, when writing PQEs, we need to use
the correct function according to the location of the PQ. e.g. if the PQ
is located in the device's memory (SRAM or DRAM), we need to use
memcpy_toio() so it would work in architectures that have separate
address ranges for IO memory.

This patch makes the code that writes the PQE to be ASIC-specific so we
can handle this properly per ASIC.

Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Tested-by: Ben Segal <bpsegal20@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/goya/goya.c  |  7 ++++---
 drivers/misc/habanalabs/goya/goyaP.h |  2 +-
 drivers/misc/habanalabs/habanalabs.h |  9 +++++++--
 drivers/misc/habanalabs/hw_queue.c   | 14 +++++---------
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 0644fd7742057..9216cc3599178 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -2716,9 +2716,10 @@ void goya_ring_doorbell(struct hl_device *hdev, u32 hw_queue_id, u32 pi)
 				GOYA_ASYNC_EVENT_ID_PI_UPDATE);
 }
 
-void goya_flush_pq_write(struct hl_device *hdev, u64 *pq, u64 exp_val)
+void goya_pqe_write(struct hl_device *hdev, __le64 *pqe, struct hl_bd *bd)
 {
-	/* Not needed in Goya */
+	/* The QMANs are on the SRAM so need to copy to IO space */
+	memcpy_toio((void __iomem *) pqe, bd, sizeof(struct hl_bd));
 }
 
 static void *goya_dma_alloc_coherent(struct hl_device *hdev, size_t size,
@@ -4784,7 +4785,7 @@ static const struct hl_asic_funcs goya_funcs = {
 	.resume = goya_resume,
 	.cb_mmap = goya_cb_mmap,
 	.ring_doorbell = goya_ring_doorbell,
-	.flush_pq_write = goya_flush_pq_write,
+	.pqe_write = goya_pqe_write,
 	.asic_dma_alloc_coherent = goya_dma_alloc_coherent,
 	.asic_dma_free_coherent = goya_dma_free_coherent,
 	.get_int_queue_base = goya_get_int_queue_base,
diff --git a/drivers/misc/habanalabs/goya/goyaP.h b/drivers/misc/habanalabs/goya/goyaP.h
index c83cab0d641e2..e2040fd331ca1 100644
--- a/drivers/misc/habanalabs/goya/goyaP.h
+++ b/drivers/misc/habanalabs/goya/goyaP.h
@@ -170,7 +170,7 @@ int goya_late_init(struct hl_device *hdev);
 void goya_late_fini(struct hl_device *hdev);
 
 void goya_ring_doorbell(struct hl_device *hdev, u32 hw_queue_id, u32 pi);
-void goya_flush_pq_write(struct hl_device *hdev, u64 *pq, u64 exp_val);
+void goya_pqe_write(struct hl_device *hdev, __le64 *pqe, struct hl_bd *bd);
 void goya_update_eq_ci(struct hl_device *hdev, u32 val);
 void goya_restore_phase_topology(struct hl_device *hdev);
 int goya_context_switch(struct hl_device *hdev, u32 asid);
diff --git a/drivers/misc/habanalabs/habanalabs.h b/drivers/misc/habanalabs/habanalabs.h
index adef7d9d7488a..d56ab65d5b2a4 100644
--- a/drivers/misc/habanalabs/habanalabs.h
+++ b/drivers/misc/habanalabs/habanalabs.h
@@ -449,7 +449,11 @@ enum hl_pll_frequency {
  * @resume: handles IP specific H/W or SW changes for resume.
  * @cb_mmap: maps a CB.
  * @ring_doorbell: increment PI on a given QMAN.
- * @flush_pq_write: flush PQ entry write if necessary, WARN if flushing failed.
+ * @pqe_write: Write the PQ entry to the PQ. This is ASIC-specific
+ *             function because the PQs are located in different memory areas
+ *             per ASIC (SRAM, DRAM, Host memory) and therefore, the method of
+ *             writing the PQE must match the destination memory area
+ *             properties.
  * @asic_dma_alloc_coherent: Allocate coherent DMA memory by calling
  *                           dma_alloc_coherent(). This is ASIC function because
  *                           its implementation is not trivial when the driver
@@ -518,7 +522,8 @@ struct hl_asic_funcs {
 	int (*cb_mmap)(struct hl_device *hdev, struct vm_area_struct *vma,
 			u64 kaddress, phys_addr_t paddress, u32 size);
 	void (*ring_doorbell)(struct hl_device *hdev, u32 hw_queue_id, u32 pi);
-	void (*flush_pq_write)(struct hl_device *hdev, u64 *pq, u64 exp_val);
+	void (*pqe_write)(struct hl_device *hdev, __le64 *pqe,
+			struct hl_bd *bd);
 	void* (*asic_dma_alloc_coherent)(struct hl_device *hdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flag);
 	void (*asic_dma_free_coherent)(struct hl_device *hdev, size_t size,
diff --git a/drivers/misc/habanalabs/hw_queue.c b/drivers/misc/habanalabs/hw_queue.c
index 2894d89759334..bb76794747279 100644
--- a/drivers/misc/habanalabs/hw_queue.c
+++ b/drivers/misc/habanalabs/hw_queue.c
@@ -290,23 +290,19 @@ static void int_hw_queue_schedule_job(struct hl_cs_job *job)
 	struct hl_device *hdev = job->cs->ctx->hdev;
 	struct hl_hw_queue *q = &hdev->kernel_queues[job->hw_queue_id];
 	struct hl_bd bd;
-	u64 *pi, *pbd = (u64 *) &bd;
+	__le64 *pi;
 
 	bd.ctl = 0;
-	bd.len = __cpu_to_le32(job->job_cb_size);
-	bd.ptr = __cpu_to_le64((u64) (uintptr_t) job->user_cb);
+	bd.len = cpu_to_le32(job->job_cb_size);
+	bd.ptr = cpu_to_le64((u64) (uintptr_t) job->user_cb);
 
-	pi = (u64 *) (uintptr_t) (q->kernel_address +
+	pi = (__le64 *) (uintptr_t) (q->kernel_address +
 		((q->pi & (q->int_queue_len - 1)) * sizeof(bd)));
 
-	pi[0] = pbd[0];
-	pi[1] = pbd[1];
-
 	q->pi++;
 	q->pi &= ((q->int_queue_len << 1) - 1);
 
-	/* Flush PQ entry write. Relevant only for specific ASICs */
-	hdev->asic_funcs->flush_pq_write(hdev, pi, pbd[0]);
+	hdev->asic_funcs->pqe_write(hdev, pi, &bd);
 
 	hdev->asic_funcs->ring_doorbell(hdev, q->hw_queue_id, q->pi);
 }
-- 
2.20.1



