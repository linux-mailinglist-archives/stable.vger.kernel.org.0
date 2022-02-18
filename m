Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF714BB728
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiBRKqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:46:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiBRKqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:46:01 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8129690D
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:45:44 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id bn33so3654474ljb.6
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NmrZAaTzmzY3f8j8ur3y+/Pq9p4qw3PiRXeLKHLYG7o=;
        b=XRSnK/j3ywwJk/R4Hs10Q1+vin6YrzTg8jWQ3Xtyp2Qg3WYOmqzBXBHUR7k+E0unb6
         9syHrAoKKB+KU9Vd3jquqxwCu6oDyKInVrq8gDZHoffYH3UAPg4Y6HYlVL2FozMFq5Ox
         PtDQQkbrAUOZCvAvjcdvcuKEgzOcuBlSvtC6w/HNlHh9umLg+9CBsww4ZwXT6FiqXV98
         UZlDbDhGpbLlTDAYcQU0qy2VhtrRnHMizQZYoPwC9r8yMtksUa6BjPwNO1ypLz5z84if
         Ab3VJxDmU7I5sZ14ubuKJUSd209bCvEMES1Y0YCzMypxQWjWNFxHn7JJCwfzBfTWuuOF
         w0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NmrZAaTzmzY3f8j8ur3y+/Pq9p4qw3PiRXeLKHLYG7o=;
        b=Lnp4DC0sWNmK7oIbdCcL5Chtm8BgmVjSHaWzWKwBIa2IP9Ly24+vTW0Muu8flX6x0w
         Ignk+EerilOxWW5eulmEel6z4fRoWG+FAM80a12ROIOFwMQa5ytWAyDk2U1ZuCohFrSY
         QYlwEN7OyIPJF1CKX25IxALKuZACJYlSDZ+pHIqKnhe854Z+ZsbNPNgH+mhGCMqqrwZ0
         aHOaCWaCF5mtddWd7DXdb7pkKqR7uH10P4qqAgOkh7B+5Zfcnai+bPmFRcsaGfP3SwCm
         ALZOPAAPMx/aL7rPOuQokKt3Hpn5+r3DIZbc5JWjnz1iTsG7gDcE7JC7ebkISHD8IW7+
         b55A==
X-Gm-Message-State: AOAM532X+92q/mg7BS2g9MUqBciFsHWJ89KEjTs9AeMwP6svkQj0DFIK
        UwMp9E876sUQxCL3470+taCzWDg2CzPrNw==
X-Google-Smtp-Source: ABdhPJzjZ+QCfMCUFQP7ZIML9wJXFBs5jo727g4PqnF+1IfVr23/dF6hVXgteI3WuqqQWkq7Lbu0Ng==
X-Received: by 2002:a05:651c:2119:b0:246:32a:4248 with SMTP id a25-20020a05651c211900b00246032a4248mr5362319ljq.111.1645181142526;
        Fri, 18 Feb 2022 02:45:42 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id l24sm277775ljb.90.2022.02.18.02.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 02:45:42 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: [PATCH backportt 5.16] optee: use driver internal tee_context for some rpc
Date:   Fri, 18 Feb 2022 11:45:29 +0100
Message-Id: <20220218104529.436040-1-jens.wiklander@linaro.org>
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
[JW: backport to 5.16-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/optee/core.c          |  1 +
 drivers/tee/optee/ffa_abi.c       | 70 ++++++++++++++++++-------------
 drivers/tee/optee/optee_private.h |  4 +-
 drivers/tee/optee/smc_abi.c       | 13 ++++--
 4 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 2a66a5203d2f..7bf9e888b621 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -157,6 +157,7 @@ void optee_remove_common(struct optee *optee)
 	/* Unregister OP-TEE specific client devices on TEE bus */
 	optee_unregister_devices();
 
+	teedev_close_context(optee->ctx);
 	/*
 	 * The two devices have to be unregistered before we can free the
 	 * other resources.
diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index d8c8683863aa..3c151d4e7f3a 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -424,6 +424,7 @@ static struct tee_shm_pool_mgr *optee_ffa_shm_pool_alloc_pages(void)
  */
 
 static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					      struct optee *optee,
 					      struct optee_msg_arg *arg)
 {
 	struct tee_shm *shm;
@@ -439,7 +440,7 @@ static void handle_ffa_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = optee_rpc_cmd_alloc_suppl(ctx, arg->params[0].u.value.b);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, arg->params[0].u.value.b,
+		shm = tee_shm_alloc(optee->ctx, arg->params[0].u.value.b,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
@@ -493,14 +494,13 @@ static void handle_ffa_rpc_func_cmd_shm_free(struct tee_context *ctx,
 }
 
 static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
+				    struct optee *optee,
 				    struct optee_msg_arg *arg)
 {
-	struct optee *optee = tee_get_drvdata(ctx->teedev);
-
 	arg->ret_origin = TEEC_ORIGIN_COMMS;
 	switch (arg->cmd) {
 	case OPTEE_RPC_CMD_SHM_ALLOC:
-		handle_ffa_rpc_func_cmd_shm_alloc(ctx, arg);
+		handle_ffa_rpc_func_cmd_shm_alloc(ctx, optee, arg);
 		break;
 	case OPTEE_RPC_CMD_SHM_FREE:
 		handle_ffa_rpc_func_cmd_shm_free(ctx, optee, arg);
@@ -510,12 +510,12 @@ static void handle_ffa_rpc_func_cmd(struct tee_context *ctx,
 	}
 }
 
-static void optee_handle_ffa_rpc(struct tee_context *ctx, u32 cmd,
-				 struct optee_msg_arg *arg)
+static void optee_handle_ffa_rpc(struct tee_context *ctx, struct optee *optee,
+				 u32 cmd, struct optee_msg_arg *arg)
 {
 	switch (cmd) {
 	case OPTEE_FFA_YIELDING_CALL_RETURN_RPC_CMD:
-		handle_ffa_rpc_func_cmd(ctx, arg);
+		handle_ffa_rpc_func_cmd(ctx, optee, arg);
 		break;
 	case OPTEE_FFA_YIELDING_CALL_RETURN_INTERRUPT:
 		/* Interrupt delivered by now */
@@ -582,7 +582,7 @@ static int optee_ffa_yielding_call(struct tee_context *ctx,
 		 * above.
 		 */
 		cond_resched();
-		optee_handle_ffa_rpc(ctx, data->data1, rpc_arg);
+		optee_handle_ffa_rpc(ctx, optee, data->data1, rpc_arg);
 		cmd = OPTEE_FFA_YIELDING_CALL_RESUME;
 		data->data0 = cmd;
 		data->data1 = 0;
@@ -793,7 +793,9 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 {
 	const struct ffa_dev_ops *ffa_ops;
 	unsigned int rpc_arg_count;
+	struct tee_shm_pool *pool;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	struct optee *optee;
 	int rc;
 
@@ -813,12 +815,12 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	if (!optee)
 		return -ENOMEM;
 
-	optee->pool = optee_ffa_config_dyn_shm();
-	if (IS_ERR(optee->pool)) {
-		rc = PTR_ERR(optee->pool);
-		optee->pool = NULL;
-		goto err;
+	pool = optee_ffa_config_dyn_shm();
+	if (IS_ERR(pool)) {
+		rc = PTR_ERR(pool);
+		goto err_free_optee;
 	}
+	optee->pool = pool;
 
 	optee->ops = &optee_ffa_ops;
 	optee->ffa.ffa_dev = ffa_dev;
@@ -829,7 +831,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 				  optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
-		goto err;
+		goto err_free_pool;
 	}
 	optee->teedev = teedev;
 
@@ -837,46 +839,54 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 				  optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
-		goto err;
+		goto err_unreg_teedev;
 	}
 	optee->supp_teedev = teedev;
 
 	rc = tee_device_register(optee->teedev);
 	if (rc)
-		goto err;
+		goto err_unreg_supp_teedev;
 
 	rc = tee_device_register(optee->supp_teedev);
 	if (rc)
-		goto err;
+		goto err_unreg_supp_teedev;
 
 	rc = rhashtable_init(&optee->ffa.global_ids, &shm_rhash_params);
 	if (rc)
-		goto err;
+		goto err_unreg_supp_teedev;
 	mutex_init(&optee->ffa.mutex);
 	mutex_init(&optee->call_queue.mutex);
 	INIT_LIST_HEAD(&optee->call_queue.waiters);
 	optee_wait_queue_init(&optee->wait_queue);
 	optee_supp_init(&optee->supp);
 	ffa_dev_set_drvdata(ffa_dev, optee);
+	ctx = teedev_open(optee->teedev);
+	if (IS_ERR(ctx))
+		goto err_rhashtable_free;
+	optee->ctx = ctx;
+
 
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
-	if (rc) {
-		optee_ffa_remove(ffa_dev);
-		return rc;
-	}
+	if (rc)
+		goto err_unregister_devices;
 
 	pr_info("initialized driver\n");
 	return 0;
-err:
-	/*
-	 * tee_device_unregister() is safe to call even if the
-	 * devices hasn't been registered with
-	 * tee_device_register() yet.
-	 */
+
+err_unregister_devices:
+	optee_unregister_devices();
+	teedev_close_context(ctx);
+err_rhashtable_free:
+	rhashtable_free_and_destroy(&optee->ffa.global_ids, rh_free_fn, NULL);
+	optee_supp_uninit(&optee->supp);
+	mutex_destroy(&optee->call_queue.mutex);
+err_unreg_supp_teedev:
 	tee_device_unregister(optee->supp_teedev);
+err_unreg_teedev:
 	tee_device_unregister(optee->teedev);
-	if (optee->pool)
-		tee_shm_pool_free(optee->pool);
+err_free_pool:
+	tee_shm_pool_free(pool);
+err_free_optee:
 	kfree(optee);
 	return rc;
 }
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index 6660e05298db..912b04697656 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -123,9 +123,10 @@ struct optee_ops {
 /**
  * struct optee - main service struct
  * @supp_teedev:	supplicant device
+ * @teedev:		client device
  * @ops:		internal callbacks for different ways to reach secure
  *			world
- * @teedev:		client device
+ * @ctx:		driver internal TEE context
  * @smc:		specific to SMC ABI
  * @ffa:		specific to FF-A ABI
  * @call_queue:		queue of threads waiting to call @invoke_fn
@@ -142,6 +143,7 @@ struct optee {
 	struct tee_device *supp_teedev;
 	struct tee_device *teedev;
 	const struct optee_ops *ops;
+	struct tee_context *ctx;
 	union {
 		struct optee_smc smc;
 		struct optee_ffa ffa;
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index cf2e3293567d..a00394149acb 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -618,6 +618,7 @@ static void handle_rpc_func_cmd_shm_free(struct tee_context *ctx,
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -647,7 +648,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = optee_rpc_cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -743,7 +745,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
 	switch (arg->cmd) {
 	case OPTEE_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -772,7 +774,7 @@ static void optee_handle_rpc(struct tee_context *ctx,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
@@ -1217,6 +1219,7 @@ static int optee_probe(struct platform_device *pdev)
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -1294,6 +1297,10 @@ static int optee_probe(struct platform_device *pdev)
 	optee_supp_init(&optee->supp);
 	optee->smc.memremaped_shm = memremaped_shm;
 	optee->pool = pool;
+	ctx = teedev_open(optee->teedev);
+	if (IS_ERR(ctx))
+		goto err;
+	optee->ctx = ctx;
 
 	/*
 	 * Ensure that there are no pre-existing shm objects before enabling
-- 
2.31.1

