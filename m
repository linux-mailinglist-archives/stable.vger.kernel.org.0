Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032F53E8195
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbhHJSAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236860AbhHJR6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7699B60F25;
        Tue, 10 Aug 2021 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617555;
        bh=tT37LqiAbz+bz2m145jSNu6T4+M7OT1SgP9oRWNneRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJZRIcFDmZ7KE0C53HJEVVOKX/c3srKrQG35FQxaJRbVpPxUejajLAEEeqLTp0iH2
         k/xQ1hBNBJLN7pkRWn+2f5CmegqRbcd+IPzyWohbnGAN8KMCcc5LjaXSr3hmQi21LN
         ZVi6IWIpW1ndE1KjIQBZW+ndrrBRpIPYjIoHrXRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.13 111/175] tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag
Date:   Tue, 10 Aug 2021 19:30:19 +0200
Message-Id: <20210810173004.611568473@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/call.c     |    2 +-
 drivers/tee/optee/core.c     |    3 ++-
 drivers/tee/optee/rpc.c      |    5 +++--
 drivers/tee/optee/shm_pool.c |    8 ++++++--
 drivers/tee/tee_shm.c        |    4 ++--
 include/linux/tee_drv.h      |    1 +
 6 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -184,7 +184,7 @@ static struct tee_shm *get_msg_arg(struc
 	struct optee_msg_arg *ma;
 
 	shm = tee_shm_alloc(ctx, OPTEE_MSG_GET_ARG_SIZE(num_params),
-			    TEE_SHM_MAPPED);
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (IS_ERR(shm))
 		return shm;
 
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -277,7 +277,8 @@ static void optee_release(struct tee_con
 	if (!ctxdata)
 		return;
 
-	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg), TEE_SHM_MAPPED);
+	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg),
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (!IS_ERR(shm)) {
 		arg = tee_shm_get_va(shm, 0);
 		/*
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -314,7 +314,7 @@ static void handle_rpc_func_cmd_shm_allo
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -502,7 +502,8 @@ void optee_handle_rpc(struct tee_context
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, param->a1,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
 			reg_pair_from_64(&param->a4, &param->a5,
--- a/drivers/tee/optee/shm_pool.c
+++ b/drivers/tee/optee/shm_pool.c
@@ -27,7 +27,11 @@ static int pool_op_alloc(struct tee_shm_
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
 
@@ -52,7 +56,7 @@ static int pool_op_alloc(struct tee_shm_
 static void pool_op_free(struct tee_shm_pool_mgr *poolm,
 			 struct tee_shm *shm)
 {
-	if (shm->flags & TEE_SHM_DMA_BUF)
+	if (!(shm->flags & TEE_SHM_PRIV))
 		optee_shm_unregister(shm->ctx, shm);
 
 	free_pages((unsigned long)shm->kaddr, get_order(shm->size));
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -117,7 +117,7 @@ struct tee_shm *tee_shm_alloc(struct tee
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
 
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -27,6 +27,7 @@
 #define TEE_SHM_USER_MAPPED	BIT(4)  /* Memory mapped in user space */
 #define TEE_SHM_POOL		BIT(5)  /* Memory allocated from pool */
 #define TEE_SHM_KERNEL_MAPPED	BIT(6)  /* Memory mapped in kernel space */
+#define TEE_SHM_PRIV		BIT(7)  /* Memory private to TEE driver */
 
 struct device;
 struct tee_device;


