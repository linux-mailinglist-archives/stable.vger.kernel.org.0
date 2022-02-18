Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A824BB8C7
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 13:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiBRMBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 07:01:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiBRMBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 07:01:46 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB57254A55
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 04:01:22 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b11so4937313lfb.12
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 04:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XLEPt4CfGzTUO6etPW/PpruciMOtBocEKPBhY/5hDyk=;
        b=KtYpfiGUjzCYQ95EywNDdYioxc2mhdkSl/oSXRoTNjwJplzbEbhBr9/a3CpAOqtw6D
         fsroYUR7D4WqPkAa0pJHGkEiK12jL3Cbir2FtpwJFnu9CGrpMvEpuWg3U8WrLxP09hrU
         I0OMjBLrEe34vXWcUguyzGrk8MKGFuEy3dajKi8XNeW+MNyED+wSDpfnYYXkFLkbyAY6
         6l47nuT+f0XCaKfg/dQtxZzz1inqx4Y8/1I3r2KwRYF9pOmQb2M1pTsrtHumS2TG8iW4
         xxs9RRU0Yva1LHCsKzLrqyhmexRFcxI6w5LI7gcW5xHUpsjpkyMC/zNaAoA9I9+6fhIf
         ONbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XLEPt4CfGzTUO6etPW/PpruciMOtBocEKPBhY/5hDyk=;
        b=dIqQvC2QrZ7SwoNlxMEZD4fMqPuzc1K38WX0iWJNmOaPEsM/IisgtlRCE6hcX2cVTz
         3uxPlI4ZGpsAIZIE6ubNdROoOlo9mR7pIMCY9knBjPLBTQhu4JxoFy3QA8sp4m/8Idp2
         l+NFbE1zkmXXt7PS8t3n5wpOiLzYxTyz9Lf4xg5VN8jJlvay7Ier74OhayJw4aSOjtrk
         XPpRFCSrByeSwCCmxScl3/Ro2ngtQlZQMrMCe2mJiwqgkmKVmm6JjlUs2MwJVxFtMquH
         U93kygBKVwqTBkRd7atIRCGCT63Ahf5JEC7FEPHvvKHs7s7zc/riBpQdFnaliI8iai0V
         luWw==
X-Gm-Message-State: AOAM531xfheD/ONLfS0iZGI1ytwzpZVBplURUeRZhwktlD0nZ4yZYFm1
        O2wLPPgPShOOb0tdsMxlW8udNc+ARX8S1Q==
X-Google-Smtp-Source: ABdhPJziZqDMtTRWpZ/wK8q3EkhUWd7iZ1T5vhXa2vv+pEdezxF3dv6xwxLdSJNBZu1sapX7V1J/SA==
X-Received: by 2002:ac2:4c51:0:b0:443:95c4:6bd7 with SMTP id o17-20020ac24c51000000b0044395c46bd7mr5249825lfk.123.1645185680470;
        Fri, 18 Feb 2022 04:01:20 -0800 (PST)
Received: from jade.urgonet (h-94-254-48-165.A175.priv.bahnhof.se. [94.254.48.165])
        by smtp.gmail.com with ESMTPSA id j13sm236358lfu.66.2022.02.18.04.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 04:01:19 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: [PATCH backport 5.15] optee: use driver internal tee_context for some rpc
Date:   Fri, 18 Feb 2022 13:01:15 +0100
Message-Id: <20220218120115.552866-1-jens.wiklander@linaro.org>
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
[JW: backport to 5.15-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
 drivers/tee/optee/core.c          | 8 ++++++++
 drivers/tee/optee/optee_private.h | 2 ++
 drivers/tee/optee/rpc.c           | 8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 5363ebebfc35..bbd97239de95 100644
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
index efbaff7ad7e5..456833d82007 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -285,6 +285,7 @@ static struct tee_shm *cmd_alloc_suppl(struct tee_context *ctx, size_t sz)
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -314,7 +315,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -471,7 +473,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
 		break;
 	case OPTEE_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -502,7 +504,7 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
-- 
2.31.1

