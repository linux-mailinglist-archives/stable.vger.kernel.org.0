Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539C53E4259
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 11:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhHIJSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 05:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234186AbhHIJSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 05:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 605B36056C;
        Mon,  9 Aug 2021 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628500710;
        bh=VkD+KUJl8damFi3XEkJZPQYsKSogPSZq0u8X79ASSOk=;
        h=Subject:To:Cc:From:Date:From;
        b=F3Y8kjn0LMfB3kKFcAYsn0MADjStx5a8j856rXYcvqmYaXi9Y6thHrMeMPHl/Z3tR
         EWH7DF4uvKphy9+CE2Jzpp/Zdmw8MtD/En8ihqmlgXw0bTi5/d+n8fDNRf7ANjX/IT
         5Lf8MLU0PIzkVi0D6Ex9s+rBRUpxjve30wATndv0=
Subject: FAILED: patch "[PATCH] tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag" failed to apply to 4.19-stable tree
To:     sumit.garg@linaro.org, jens.wiklander@linaro.org,
        tyhicks@linux.microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 11:18:17 +0200
Message-ID: <1628500697195159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 376e4199e327a5cf29b8ec8fb0f64f3d8b429819 Mon Sep 17 00:00:00 2001
From: Sumit Garg <sumit.garg@linaro.org>
Date: Mon, 14 Jun 2021 17:33:15 -0500
Subject: [PATCH] tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag

Currently TEE_SHM_DMA_BUF flag has been inappropriately used to not
register shared memory allocated for private usage by underlying TEE
driver: OP-TEE in this case. So rather add a new flag as TEE_SHM_PRIV
that can be utilized by underlying TEE drivers for private allocation
and usage of shared memory.

With this corrected, allow tee_shm_alloc_kernel_buf() to allocate a
shared memory region without the backing of dma-buf.

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 387e94768182..945f03da0223 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -184,7 +184,7 @@ static struct tee_shm *get_msg_arg(struct tee_context *ctx, size_t num_params,
 	struct optee_msg_arg *ma;
 
 	shm = tee_shm_alloc(ctx, OPTEE_MSG_GET_ARG_SIZE(num_params),
-			    TEE_SHM_MAPPED);
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (IS_ERR(shm))
 		return shm;
 
diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 651d49b53d3b..5ce13b099d7d 100644
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
index 1849180b0278..efbaff7ad7e5 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -314,7 +314,7 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -502,7 +502,8 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
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
index 8990f7628387..3ebfea0781f1 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -27,6 +27,7 @@
 #define TEE_SHM_USER_MAPPED	BIT(4)  /* Memory mapped in user space */
 #define TEE_SHM_POOL		BIT(5)  /* Memory allocated from pool */
 #define TEE_SHM_KERNEL_MAPPED	BIT(6)  /* Memory mapped in kernel space */
+#define TEE_SHM_PRIV		BIT(7)  /* Memory private to TEE driver */
 
 struct device;
 struct tee_device;

