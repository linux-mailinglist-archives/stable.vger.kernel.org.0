Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247EB3E83B6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 21:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhHJTaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 15:30:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51660 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhHJTaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 15:30:02 -0400
Received: from sequoia.work.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7D9A920B36ED;
        Tue, 10 Aug 2021 12:29:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D9A920B36ED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628623779;
        bh=t+X0smPs3AFtyvWxHEFzTthW0BRGgtYhB3mOBUgZWxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIR1FUnmMjSN9xnfVOE81MVqOWHmgQOsalSTcglpsJU5tY0CqLqoNiE8ohpI539W3
         kuF1lR6ubbB7wqjWp6GGu09iNap7TSVlBgr6uzA6zRxg63SQ4RbVpUMpplk5a13dmT
         3jvobQf5Vie6jXgz+tO/yH5nPmSz4n/KqH0rBPXQ=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     gregkh@linuxfoundation.org
Cc:     sumit.garg@linaro.org, jens.wiklander@linaro.org,
        stable@vger.kernel.org
Subject: [PATCH] tee: Correct inappropriate usage of TEE_SHM_DMA_BUF flag
Date:   Tue, 10 Aug 2021 14:29:26 -0500
Message-Id: <20210810192926.1748190-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1628500696149218@kroah.com>
References: <1628500696149218@kroah.com>
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

Cc: stable@vger.kernel.org # 5.4.x
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Co-developed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---

Hi Greg - Please include this backported patch in the 5.14-stable queue
since the upstream commit couldn't be automatically backported. We've
been using this backported version of the patch on top of 5.4.134 and it
has received real world usage in production environments.

 drivers/tee/optee/call.c     | 2 +-
 drivers/tee/optee/core.c     | 3 ++-
 drivers/tee/optee/rpc.c      | 5 +++--
 drivers/tee/optee/shm_pool.c | 8 ++++++--
 drivers/tee/tee_shm.c        | 4 ++--
 include/linux/tee_drv.h      | 1 +
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 4b5069f88d78..3a54455d9ddf 100644
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
index 432dd38921dd..4bb4c8f28cbd 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -254,7 +254,8 @@ static void optee_release(struct tee_context *ctx)
 	if (!ctxdata)
 		return;
 
-	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg), TEE_SHM_MAPPED);
+	shm = tee_shm_alloc(ctx, sizeof(struct optee_msg_arg),
+			    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 	if (!IS_ERR(shm)) {
 		arg = tee_shm_get_va(shm, 0);
 		/*
diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index b4ade54d1f28..aecf62016e7b 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -220,7 +220,7 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_MSG_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED);
+		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -405,7 +405,8 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
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
index 1b4b4a1ba91d..d6491e973fa4 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -117,7 +117,7 @@ static struct tee_shm *__tee_shm_alloc(struct tee_context *ctx,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if ((flags & ~(TEE_SHM_MAPPED | TEE_SHM_DMA_BUF))) {
+	if ((flags & ~(TEE_SHM_MAPPED | TEE_SHM_DMA_BUF | TEE_SHM_PRIV))) {
 		dev_err(teedev->dev.parent, "invalid shm flags 0x%x", flags);
 		return ERR_PTR(-EINVAL);
 	}
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(tee_shm_priv_alloc);
  */
 struct tee_shm *tee_shm_alloc_kernel_buf(struct tee_context *ctx, size_t size)
 {
-	return tee_shm_alloc(ctx, size, TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	return tee_shm_alloc(ctx, size, TEE_SHM_MAPPED);
 }
 EXPORT_SYMBOL_GPL(tee_shm_alloc_kernel_buf);
 
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index 91677f2fa2e8..cd15c1b7fae0 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -26,6 +26,7 @@
 #define TEE_SHM_REGISTER	BIT(3)  /* Memory registered in secure world */
 #define TEE_SHM_USER_MAPPED	BIT(4)  /* Memory mapped in user space */
 #define TEE_SHM_POOL		BIT(5)  /* Memory allocated from pool */
+#define TEE_SHM_PRIV		BIT(7)  /* Memory private to TEE driver */
 
 struct device;
 struct tee_device;
-- 
2.25.1

