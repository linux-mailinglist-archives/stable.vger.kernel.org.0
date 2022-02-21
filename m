Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A964BED4E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 23:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiBUWkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 17:40:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiBUWkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 17:40:22 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51999240BE
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:39:58 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id bn33so16692541ljb.6
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EvxSzPgUawvqyT3B9i8z5b23xFX8vnyeQCzV2De0VoA=;
        b=bQ50SB9vc/pTHEVINdyHV26MtZZs7bD5rRM7biP7u1L3WyNa0klkzsAPSk9Yp/H66q
         st7SWohSdRCpz74GzZ273N/b02DvrungbvTLrMXp8KGnLZnlKHP3AJk4UVtaoATPXSUN
         VYaVgd8orz9ojyC5FF/gTWx0r92z1F+5WHF5ldfMyNPF/oHLT75Ap46GrSOaGTjR0atr
         ZdPF5x8LQg6gKsNp4M4V5OXeRGLe42avZFJxQhin4wuhDKDGSsFztQa9i6cfRkZSN//e
         QyBvNU+AR9F2j5N1LlfN3zNc3KnX8827VV25PVMfvgfb5zDHPZl2As70JuDS0fQbU3qn
         RUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EvxSzPgUawvqyT3B9i8z5b23xFX8vnyeQCzV2De0VoA=;
        b=T1lRMfiDYSwCeHpFLCa7hITSsl+P87k/qSRfQXISLtnLxdU1k29AbJJUEjXfxEiUuM
         BLIaxVS0nXVJf+H36j/lOF9v/e2ghyt0mruAw/BP4ZLlwEclctSX3eGAlPvKv50essHc
         5bln7FifFF4fQfx9VKF/JuWWGpvMZQrzpLghTkUHwgsGFE+cqOqNsohwdOOUpDBV9buj
         ZdXwwZu+4iDFxcIhemC46fx5wnm+oDV7F8dTx5SurFo/DHmr+YYJcJxU4O34H1dseZYP
         RU5x8bGwj6myrDJMk+G4y+wdh25ss9OqrV7d4xYoa6M8+ypAgNPnZmNQGenMGnLkWm1d
         X2AA==
X-Gm-Message-State: AOAM530tcupG/hOxZLePwlaFqA8bxU2sLZ8LV9KYTNoj+UPk965IHRqX
        CoBUT3bsT4MFUv2qUi5/ZwkLbPUAM94cZg==
X-Google-Smtp-Source: ABdhPJysFtuwDL4rksC+ZYESJwi0vO5CDk4obGED0KSPTknn1cD7QMK+TKG6mI5795uLRDx4OJZi5A==
X-Received: by 2002:a2e:b0fa:0:b0:246:291a:5232 with SMTP id h26-20020a2eb0fa000000b00246291a5232mr11818669ljl.317.1645483196288;
        Mon, 21 Feb 2022 14:39:56 -0800 (PST)
Received: from localhost.localdomain (ua-84-216-128-36.bbcust.telenor.se. [84.216.128.36])
        by smtp.gmail.com with ESMTPSA id k14sm1492400ljh.82.2022.02.21.14.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 14:39:55 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: [PATCH backport 5.10 v2] optee: use driver internal tee_context for some rpc
Date:   Mon, 21 Feb 2022 23:39:45 +0100
Message-Id: <20220221223945.1482216-1-jens.wiklander@linaro.org>
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
Hi,

This is an update to the previous patch posted with the same name.

Please note that this patch depends on 1e2c3ef0496e ("tee: export
teedev_open() and teedev_close_context()") which needs be cherry-picked
before this patch is applied.

Thanks,
Jens

 drivers/tee/optee/core.c          | 8 ++++++++
 drivers/tee/optee/optee_private.h | 2 ++
 drivers/tee/optee/rpc.c           | 8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index f255a96ae5a4..6ea80add7378 100644
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
+		rc = PTR_ERR(ctx);
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

