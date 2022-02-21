Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5304BED67
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 23:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiBUWti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 17:49:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBUWti (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 17:49:38 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D112458E
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:49:12 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u20so21253227lff.2
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 14:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p8UylMHQWSEUi+/tq9Csh273nAiNT/tyXO5mTXWhUT8=;
        b=aZrFDQZ10AMlQpR06q8HR7b+O8R/8/gfKakmtFh5cnFepsLXa/KxVxxDRHeojR5hi3
         22K7CuYzDnYVMqU5iHUdOaSucmcucC7oOa0v9o1LGA79/moROLu8YJ1CtOaceFHcwciL
         qGYowDUbFNV9pehilQ2Om7t3NqPTwiJEARo8r7+Hpd39IToojriLxNqNi9XS4tz7oK27
         GZle581BD1jW1comtUZaELJnxAcR2lGXr1JYNgGNtlNusenK1wbfZ1IP5Z+gvoseTHKR
         QRy58F5q+OMpJutJQjT2zLiVQwORJFqZkPzczw0NAhlHQhJNbobYZu0/P4a80AGw6nYi
         onuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p8UylMHQWSEUi+/tq9Csh273nAiNT/tyXO5mTXWhUT8=;
        b=luW5sudHvqWPvFo2HSxXzlR8iTuYSHtFbeA3X9Yl4exaV5NSImtdSGLvx7MWe+xgWe
         TB81hkyLtt6TybaNSYvH2J3YYjHEw2/Y+f2MaLQdQADg5FsCcR/yRp6FNWVHrMVRlWvt
         78YCmUagRUI9Yjc9/zuHZDzBU2pMdWNzQz9cdy4nT8g53jP1Q8gbb3305ZxoNCkbdGzN
         BdzCtuCqOSJzXTqzZ3S46yVqUCtEvM8PIINDbpd3PdvcecMXUAg+E500Eli/0gi7aQMd
         8V7k4owymZKJ876mDh6xcf72R8+4BBgRSWJ7vS1Z1wm5yVwGbfKrgt+xP+DKlOdo2ENK
         wmcw==
X-Gm-Message-State: AOAM530WlS50Uvap9JWXFmnQY13BkK97SepiuzA7PN0PyVe9lwLru3Jo
        l99a9hJlcE5Hu5RQeWj4a2mU+mV5JMrDxg==
X-Google-Smtp-Source: ABdhPJx/pOORKvQm1S17V4YikxqaZ4BK7FZstIa3Ag+37U5AWsD6FCNrOeBtaHqWOn7QQ0jp0uh0AA==
X-Received: by 2002:a05:6512:689:b0:443:14c1:ae81 with SMTP id t9-20020a056512068900b0044314c1ae81mr14793769lfe.183.1645483750694;
        Mon, 21 Feb 2022 14:49:10 -0800 (PST)
Received: from localhost.localdomain (ua-84-216-128-36.bbcust.telenor.se. [84.216.128.36])
        by smtp.gmail.com with ESMTPSA id w23sm732582lfu.96.2022.02.21.14.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 14:49:10 -0800 (PST)
From:   Jens Wiklander <jens.wiklander@linaro.org>
To:     stable@vger.kernel.org
Cc:     Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Lars Persson <larper@axis.com>
Subject: [PATCH backport 5.4 v2] optee: use driver internal tee_context for some rpc
Date:   Mon, 21 Feb 2022 23:48:59 +0100
Message-Id: <20220221224859.1535057-1-jens.wiklander@linaro.org>
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

This fixes a problem where the tee_context allocated on behalf of a
process outlives the process because some longer lived driver internal
shared memory has been allocated using that tee_context.

Fixes: 217e0250cccb ("tee: use reference counting for tee_context")
Reported-by: Lars Persson <larper@axis.com>
Cc: stable@vger.kernel.org # 1e2c3ef0496e tee: export teedev_open() and teedev_close_context()
Cc: stable@vger.kernel.org
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
[JW: backport to 5.4-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
---
Hi,

This is an update to the previous patch posted with the same name.

Please note that this patch depends on 1e2c3ef0496e ("tee: export
teedev_open() and teedev_close_context()") which needs be cherry-picked
before this patch is applied.

This differs from the previous backports (5.16, 5.15, 5.10) in the way that
f25889f93184 ("optee: fix tee out of memory failure seen during kexec
reboot") isn't in this branch. So we can't claim to fix that problem, but
this patch still makes sense since the lifetime problem can manifest itself
in other ways too.

Thanks,
Jens

 drivers/tee/optee/core.c          | 8 ++++++++
 drivers/tee/optee/optee_private.h | 2 ++
 drivers/tee/optee/rpc.c           | 8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 5eaef45799e6..344f48c90918 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -552,6 +552,7 @@ static struct optee *optee_probe(struct device_node *np)
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -631,6 +632,12 @@ static struct optee *optee_probe(struct device_node *np)
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
@@ -667,6 +674,7 @@ static struct optee *optee_probe(struct device_node *np)
 
 static void optee_remove(struct optee *optee)
 {
+	teedev_close_context(optee->ctx);
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index 54c3fa01d002..0250cfde6312 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -69,6 +69,7 @@ struct optee_supp {
  * struct optee - main service struct
  * @supp_teedev:	supplicant device
  * @teedev:		client device
+ * @ctx:		driver internal TEE context
  * @invoke_fn:		function to issue smc or hvc
  * @call_queue:		queue of threads waiting to call @invoke_fn
  * @wait_queue:		queue of threads from secure world waiting for a
@@ -83,6 +84,7 @@ struct optee {
 	struct tee_device *supp_teedev;
 	struct tee_device *teedev;
 	optee_invoke_fn *invoke_fn;
+	struct tee_context *ctx;
 	struct optee_call_queue call_queue;
 	struct optee_wait_queue wait_queue;
 	struct optee_supp supp;
diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index aecf62016e7b..be45ee620299 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -191,6 +191,7 @@ static struct tee_shm *cmd_alloc_suppl(struct tee_context *ctx, size_t sz)
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -220,7 +221,8 @@ static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_MSG_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -377,7 +379,7 @@ static void handle_rpc_func_cmd(struct tee_context *ctx, struct optee *optee,
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -405,7 +407,7 @@ void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);
-- 
2.31.1

