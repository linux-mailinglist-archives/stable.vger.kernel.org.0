Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFADE4BB9EF
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbiBRNQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:16:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiBRNQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:16:12 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A6A229DD3
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:15:55 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id i11so5411371lfu.3
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8unPL9JOM6TFvM9LXbeiHGfg7Cngi/u2F9oRL7GxVHg=;
        b=U0RpP7SPC1IrCeS6uBbAI6nrmWdDoo+IRtO/tVB7SSMKfrxSHtBoX0foKBotVIJ7ZS
         Owlx67phDGPmzxXid+sTTQND+jESqzIxoAr9JRYvnv7cdBU+i6cYkw6cZm9vHKOf9HO8
         vqj2P+uA/TRfYmW/0iaWJUy4mujpyY4t0qCqhNDkzQdCZgmtCh5EEM7j6bSxrJGdzYIf
         qklh6fHyXhSi3QBtAXNGDboYwsnGwuk8tdlloxLbeLJVmjE/YpR8J/QEI3qRAhYSuyiD
         AdiSjpftiFhBemBeslBAkBeVxcnDnoTkDE09NktWlDQv/PZQ0bSwpmQ32nhYzavbRw5m
         eb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8unPL9JOM6TFvM9LXbeiHGfg7Cngi/u2F9oRL7GxVHg=;
        b=nffUxgFeGx3qflypH0EfGmABYx7Yv8qivGAQqIm4sFYDY0oAw3iPPyG1+HRR6OA+F/
         zHD0VUc+KM+C6MgN3YEcShdYyqrqT2pN0qcvLFgnPMZlZ7ZYpBA/yq6DSZPTqy7sDnMG
         Gg3AJWblqVi/kHmEjf9KjihScNPrYzAtV4TR1ytYoHw9gh3Lzzj/Tl6lEYNWaOiSpiky
         +8TJHkVETDl1THkvcJEYlC/4YRLf/XOtubd69TWCeJ/bxxGOcpmhW5N0PJ/u+J2hrcKl
         xGDm9/JmPEzMw0qYGsLsI+AYRt6ZS+CI7ro/A4PHs6PINWIyVN0VuM/ahdp8XiZYPqlO
         M8mw==
X-Gm-Message-State: AOAM531ZdEYkvC/D3Z7LJhInoQk2Cz3DNwReBXFE0Dc8a8lLNja0CEfv
        GysRd+joloXq0X38sYFZwFfPcqFeTbGVNA==
X-Google-Smtp-Source: ABdhPJxVfFy9Cvaowtf2Ds6NzOL8Tnws/nn46fJQClAETqGZnc7gPJ9bxe+WfhYS4bZDdj8PyI3Fcg==
X-Received: by 2002:ac2:4c2a:0:b0:443:4354:7c1 with SMTP id u10-20020ac24c2a000000b00443435407c1mr5528473lfq.26.1645190153595;
        Fri, 18 Feb 2022 05:15:53 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id z18sm250746lfr.256.2022.02.18.05.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 05:15:53 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: [PATCH backport 5.10] optee: use driver internal tee_context for some rpc
Date:   Fri, 18 Feb 2022 14:15:49 +0100
Message-Id: <20220218131549.712802-1-jens.wiklander@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream

Adds a driver private tee_context to struct optee.

The new driver internal tee_context is used when allocating driver
private shared memory. This decouples the shared memory object from its
original tee_context. This is needed when the life time of such a memory
allocation outlives the client tee_context.

This patch fixes the problem described below:

The addition of a shutdown hook by commit f25889f93184 ("optee: fix tee out
of memory failure seen during kexec reboot") introduced a kernel shutdown
regression that can be triggered after running the OP-TEE xtest suites.

Once the shutdown hook is called it is not possible to communicate any more
with the supplicant process because the system is not scheduling task any
longer. Thus if the optee driver shutdown path receives a supplicant RPC
request from the OP-TEE we will deadlock the kernel's shutdown.

Fixes: f25889f93184 ("optee: fix tee out of memory failure seen during kexec reboot")
Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
Reported-by: Lars Persson <larper@axis.com>
Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
Cc: stable@vger.kernel.org
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
[JW: backport to 5.10-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/optee/core.c          | 8 ++++++++
 drivers/tee/optee/optee_private.h | 2 ++
 drivers/tee/optee/rpc.c           | 8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index f255a96ae5a4..b99ee487f56d 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -588,6 +588,7 @@ static int optee_remove(struct platform_device *pdev)
 	/* Unregister OP-TEE specific client devices on TEE bus */
 	optee_unregister_devices();
 
+	teedev_close_context(optee->ctx);
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
@@ -633,6 +634,7 @@ static int optee_probe(struct platform_device *pdev)
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -719,6 +721,12 @@ static int optee_probe(struct platform_device *pdev)
 	optee_supp_init(&optee->supp);
 	optee->memremaped_shm = memremaped_shm;
 	optee->pool = pool;
+	ctx = teedev_open(optee->teedev);
+	if (IS_ERR(ctx)) {
+		rc = rc = PTR_ERR(ctx);
+		goto err;
+	}
+	optee->ctx = ctx;
 
 	/*
 	 * Ensure that there are no pre-existing shm objects before enabling
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index f6bb4a763ba9..ea09533e30cd 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -70,6 +70,7 @@ struct optee_supp {
  * struct optee - main service struct
  * @supp_teedev:	supplicant device
  * @teedev:		client device
+ * @ctx:		driver internal TEE context
  * @invoke_fn:		function to issue smc or hvc
  * @call_queue:		queue of threads waiting to call @invoke_fn
  * @wait_queue:		queue of threads from secure world waiting for a
@@ -87,6 +88,7 @@ struct optee {
 	struct tee_device *supp_teedev;
 	struct tee_device *teedev;
 	optee_invoke_fn *invoke_fn;
+	struct tee_context *ctx;
 	struct optee_call_queue call_queue;
 	struct optee_wait_queue wait_queue;
 	struct optee_supp supp;
diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index 9dbdd783d6f2..f1e0332b0f6e 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -284,6 +284,7 @@ static struct tee_shm *cmd_alloc_suppl(struct tee_context *ctx, size_t sz)
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -313,7 +314,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_MSG_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -470,7 +472,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -501,7 +503,7 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
-- 
2.31.1

