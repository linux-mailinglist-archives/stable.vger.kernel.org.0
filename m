Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C61B3E83A2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhHJT1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 15:27:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51234 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHJT1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 15:27:16 -0400
Received: from sequoia.work.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1EE3A20A3A46;
        Tue, 10 Aug 2021 12:26:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1EE3A20A3A46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628623614;
        bh=vg5HhRFPfTQpwuShUU7Z1qAFjLw2f6ff2ksTs6+MGGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IltLnbkxRnJbe0kNBoRL01G6oN0NsGRznlnWaaFn9I/CgTeUHMsn7DRvro8sWT3Ua
         feDyxBc76Je/UR+GaTaMncj2dDjWs8ckNNvkGuxArZHgwLVJ3RFezbEDGbrLphJyYQ
         GByLnXN62e9zCmWpJYhECAXGLWJCM6Wkr56tAGIw=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     gregkh@linuxfoundation.org
Cc:     sumit.garg@linaro.org, jens.wiklander@linaro.org,
        stable@vger.kernel.org
Subject: [PATCH] tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag
Date:   Tue, 10 Aug 2021 14:26:11 -0500
Message-Id: <20210810192611.1748082-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1628500695126214@kroah.com>
References: <1628500695126214@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sumit Garg <sumit.garg@linaro.org>

commit 376e4199e327a5cf29b8ec8fb0f64f3d8b429819 upstream.

Currently TEE_SHM_DMA_BUF flag has been inappropriately used to not
register shared memory allocated for private usage by underlying TEE
driver: OP-TEE in this case. So rather add a new flag as TEE_SHM_PRIV
that can be utilized by underlying TEE drivers for private allocation
and usage of shared memory.

With this corrected, allow tee_shm_alloc_kernel_buf() to allocate a
shared memory region without the backing of dma-buf.

Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---

Hi Greg - Please include this backported patch in the 5.10-stable queue
since the upstream commit couldn't be automatically backported. We've
been using this backported version of the patch on top of 5.10.54 and it
has received real world usage in production environments.

 drivers/tee/optee/call.c     | 2 +-
 drivers/tee/optee/core.c     | 3 ++-
 drivers/tee/optee/rpc.c      | 5 +++--
 drivers/tee/optee/shm_pool.c | 8 ++++++--
 drivers/tee/tee_shm.c        | 4 ++--
 include/linux/tee_drv.h      | 1 +
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 1231ce56e712..f8f1594bea43 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -181,7 +181,7 @@ static struct tee_shm *get_msg_arg(struct tee_context *ctx, size_t num_params,
 	struct optee_msg_arg *ma;
 
 	shm = tee_shm_alloc(ctx, OPTEE_MSG_GET_ARG_SIZE(num_params),
-			    TEE_SHM_MAPPED);
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (IS_ERR(shm))
 		return shm;
 
diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 7b17248f1527..823a81d8ff0e 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -278,7 +278,8 @@ static void optee_release(struct tee_context *ctx)
 	if (!ctxdata)
 		return;
 
-	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg), TEE_SHM_MAPPED);
+	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg),
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (!IS_ERR(shm)) {
 		arg = tee_shm_get_va(shm, 0);
 		/*
diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index 6cbb3643c6c4..9dbdd783d6f2 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -313,7 +313,7 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_MSG_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -501,7 +501,8 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, param->a1,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
 			reg_pair_from_64(&param->a4, &param->a5,
diff --git a/drivers/tee/optee/shm_pool.c b/drivers/tee/optee/shm_pool.c
index da06ce9b9313..c41a9a501a6e 100644
--- a/drivers/tee/optee/shm_pool.c
+++ b/drivers/tee/optee/shm_pool.c
@@ -27,7 +27,11 @@ static int pool_op_alloc(struct tee_shm_pool_mgr *poolm,
 	shm->paddr = page_to_phys(page);
 	shm->size = PAGE_SIZE << order;
 
-	if (shm->flags & TEE_SHM_DMA_BUF) {
+	/*
+	 * Shared memory private to the OP-TEE driver doesn't need
+	 * to be registered with OP-TEE.
+	 */
+	if (!(shm->flags & TEE_SHM_PRIV)) {
 		unsigned int nr_pages = 1 << order, i;
 		struct page **pages;
 
@@ -60,7 +64,7 @@ static int pool_op_alloc(struct tee_shm_pool_mgr *poolm,
 static void pool_op_free(struct tee_shm_pool_mgr *poolm,
 			 struct tee_shm *shm)
 {
-	if (shm->flags & TEE_SHM_DMA_BUF)
+	if (!(shm->flags & TEE_SHM_PRIV))
 		optee_shm_unregister(shm->ctx, shm);
 
 	free_pages((unsigned long)shm->kaddr, get_order(shm->size));
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index c65e44707cd6..8a9384a64f3e 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -117,7 +117,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
 		return ERR_PTR(-EINVAL);
 	}
 
-	if ((flags & ~(TEE_SHM_MAPPED | TEE_SHM_DMA_BUF))) {
+	if ((flags & ~(TEE_SHM_MAPPED | TEE_SHM_DMA_BUF | TEE_SHM_PRIV))) {
 		dev_err(teedev->dev.parent, "invalid shm flags 0x%x", flags);
 		return ERR_PTR(-EINVAL);
 	}
@@ -207,7 +207,7 @@ EXPORT_SYMBOL_GPL(tee_shm_alloc);
  */
 struct tee_shm *tee_shm_alloc_kernel_buf(struct tee_context *ctx, size_t size)
 {
-	return tee_shm_alloc(ctx, size, TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	return tee_shm_alloc(ctx, size, TEE_SHM_MAPPED);
 }
 EXPORT_SYMBOL_GPL(tee_shm_alloc_kernel_buf);
 
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index 9b24cc3d3024..459e9a76d7e6 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -27,6 +27,7 @@
 #define TEE_SHM_USER_MAPPED	BIT(4)  /* Memory mapped in user space */
 #define TEE_SHM_POOL		BIT(5)  /* Memory allocated from pool */
 #define TEE_SHM_KERNEL_MAPPED	BIT(6)  /* Memory mapped in kernel space */
+#define TEE_SHM_PRIV		BIT(7)  /* Memory private to TEE driver */
 
 struct device;
 struct tee_device;
-- 
2.25.1

