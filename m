Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8D4C7347
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbiB1ReV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiB1Rdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8FB91362;
        Mon, 28 Feb 2022 09:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F5EB815AB;
        Mon, 28 Feb 2022 17:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF38C340E7;
        Mon, 28 Feb 2022 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069415;
        bh=yeJfOGJrMUlxZx29TMGSAZrifFNOcX1OnMrinSFVYxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8xdBoqR7ogPx+aBMR4WiuMJC2FpB4zCyKxeVQeKe5kzTaivyGGdYNysqsSnWzd3c
         kW+C60yVS1n2cpe7OW5l8Q8ivZzyRJRujs0Nt7Izh+BNsLOiA5WwsmtiIMXYgj04dj
         YaAVAIQxRc1YLkZlZNksHmJ9l5hA6ZKAKrATLO3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.4 12/53] optee: use driver internal tee_context for some rpc
Date:   Mon, 28 Feb 2022 18:24:10 +0100
Message-Id: <20220228172249.224833311@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

commit aceeafefff736057e8f93f19bbfbef26abd94604 upstream.

Adds a driver private tee_context by moving the tee_context in struct
optee_notif to struct optee. This tee_context was previously used when
doing internal calls to secure world to deliver notification.

The new driver internal tee_context is now also when allocating driver
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
Cc: stable@vger.kernel.org
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
[JW: backport to 5.4-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tee/optee/core.c          |    8 ++++++++
 drivers/tee/optee/optee_private.h |    2 ++
 drivers/tee/optee/rpc.c           |    8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -552,6 +552,7 @@ static struct optee *optee_probe(struct
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -631,6 +632,12 @@ static struct optee *optee_probe(struct
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
@@ -667,6 +674,7 @@ err:
 
 static void optee_remove(struct optee *optee)
 {
+	teedev_close_context(optee->ctx);
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
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
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -191,6 +191,7 @@ static struct tee_shm *cmd_alloc_suppl(s
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -220,7 +221,8 @@ static void handle_rpc_func_cmd_shm_allo
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_MSG_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -377,7 +379,7 @@ static void handle_rpc_func_cmd(struct t
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_MSG_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -405,7 +407,7 @@ void optee_handle_rpc(struct tee_context
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);


