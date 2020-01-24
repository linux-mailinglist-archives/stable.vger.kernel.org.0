Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A58147B4A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgAXJmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbgAXJmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:20 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B6E20718;
        Fri, 24 Jan 2020 09:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858939;
        bh=5lf7s6kohJFmJfLvTlB5Ime139nuZkfC83eTc1wmyRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wabz5CnUpCM8IzCteLddkFBnUfLDHvZyCWdxroOCXwxslblRcGlWUwAr7VXb0o2W7
         zfErKn25fNr1rQdaNM0c5gd6UfoKjEdzA8mMAiVmnm7EDaRvnXvqp4crFcb6mlTMvI
         Z/u7pZAvS/NOqj0QRoG6NJ6mPP0nV9onw4tDqRr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/102] tee: optee: Fix dynamic shm pool allocations
Date:   Fri, 24 Jan 2020 10:31:26 +0100
Message-Id: <20200124092819.517415399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13b0269a0abc2..cf2367ba08d63 100644
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
index de1d9b8fad904..0332a5301d613 100644
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



