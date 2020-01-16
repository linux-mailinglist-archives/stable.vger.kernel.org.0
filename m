Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17C13F908
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgAPTW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbgAPQx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70A442081E;
        Thu, 16 Jan 2020 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193607;
        bh=3dY9UzQ5FnrJjjb34dZYUEMkKYZza9PI9MXrctpD6Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZSp6M301GnniJmB2EJCSeRiZieKla1KH8QXFQg0BR7KeGUqzARKfQt/SC8QqJQVi
         kc0qs08+paKlVj3SRntSVkDaJqsLIM03XBCHKtxKKn+rNsWhZNkBTnKOS74filSbWD
         I/Mdjcxp3yTSLAw8tYVTcCB8wfrw4uB5mYNVz3RE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>, tee-dev@lists.linaro.org
Subject: [PATCH AUTOSEL 5.4 145/205] tee: optee: Fix dynamic shm pool allocations
Date:   Thu, 16 Jan 2020 11:42:00 -0500
Message-Id: <20200116164300.6705-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

[ Upstream commit a249dd200d03791cab23e47571f3e13d9c72af6c ]

In case of dynamic shared memory pool, kernel memory allocated using
dmabuf_mgr pool needs to be registered with OP-TEE prior to its usage
during optee_open_session() or optee_invoke_func().

So fix dmabuf_mgr pool allocations via an additional call to
optee_shm_register().

Also, allow kernel pages to be registered as shared memory with OP-TEE.

Fixes: 9733b072a12a ("optee: allow to work without static shared memory")
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c     |  7 +++++++
 drivers/tee/optee/shm_pool.c | 12 +++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 13b0269a0abc..cf2367ba08d6 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -554,6 +554,13 @@ static int check_mem_type(unsigned long start, size_t num_pages)
 	struct mm_struct *mm = current->mm;
 	int rc;
 
+	/*
+	 * Allow kernel address to register with OP-TEE as kernel
+	 * pages are configured as normal memory only.
+	 */
+	if (virt_addr_valid(start))
+		return 0;
+
 	down_read(&mm->mmap_sem);
 	rc = __check_mem_type(find_vma(mm, start),
 			      start + num_pages * PAGE_SIZE);
diff --git a/drivers/tee/optee/shm_pool.c b/drivers/tee/optee/shm_pool.c
index de1d9b8fad90..0332a5301d61 100644
--- a/drivers/tee/optee/shm_pool.c
+++ b/drivers/tee/optee/shm_pool.c
@@ -17,6 +17,7 @@ static int pool_op_alloc(struct tee_shm_pool_mgr *poolm,
 {
 	unsigned int order = get_order(size);
 	struct page *page;
+	int rc = 0;
 
 	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!page)
@@ -26,12 +27,21 @@ static int pool_op_alloc(struct tee_shm_pool_mgr *poolm,
 	shm->paddr = page_to_phys(page);
 	shm->size = PAGE_SIZE << order;
 
-	return 0;
+	if (shm->flags & TEE_SHM_DMA_BUF) {
+		shm->flags |= TEE_SHM_REGISTER;
+		rc = optee_shm_register(shm->ctx, shm, &page, 1 << order,
+					(unsigned long)shm->kaddr);
+	}
+
+	return rc;
 }
 
 static void pool_op_free(struct tee_shm_pool_mgr *poolm,
 			 struct tee_shm *shm)
 {
+	if (shm->flags & TEE_SHM_DMA_BUF)
+		optee_shm_unregister(shm->ctx, shm);
+
 	free_pages((unsigned long)shm->kaddr, get_order(shm->size));
 	shm->kaddr = NULL;
 }
-- 
2.20.1

