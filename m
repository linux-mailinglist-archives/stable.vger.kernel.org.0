Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026484BE78D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbiBUJZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:25:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349084AbiBUJXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:23:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FACF38DB5;
        Mon, 21 Feb 2022 01:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17B56CE0EBE;
        Mon, 21 Feb 2022 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F034FC340E9;
        Mon, 21 Feb 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434617;
        bh=jOdIH+oYtol4iHAPE9G0IuteRlaDY0p4UkmD31KMjAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjF9doaXSsTQ17ozqwFclBofpUGbphbSiPlMvyRbVDORYJk6UjRG3hqHqN4MPjWSR
         ulqVcvV5WA1IG5GMIcpIAYMgyIjWQVzwLxohD1MoakL0hMvapjk4Old8Plqgmo9J2V
         CJtQuexhM7beqyJdDYUk/uSYpz7Q7uQU90QCQnZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.15 070/196] optee: use driver internal tee_context for some rpc
Date:   Mon, 21 Feb 2022 09:48:22 +0100
Message-Id: <20220221084933.279968083@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
[JW: backport to 5.15-stable + update commit message]
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/core.c          |    8 ++++++++
 drivers/tee/optee/optee_private.h |    2 ++
 drivers/tee/optee/rpc.c           |    8 +++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -588,6 +588,7 @@ static int optee_remove(struct platform_
 	/* Unregister OP-TEE specific client devices on TEE bus */
 	optee_unregister_devices();
 
+	teedev_close_context(optee->ctx);
 	/*
 	 * Ask OP-TEE to free all cached shared memory objects to decrease
 	 * reference counters and also avoid wild pointers in secure world
@@ -633,6 +634,7 @@ static int optee_probe(struct platform_d
 	struct optee *optee = NULL;
 	void *memremaped_shm = NULL;
 	struct tee_device *teedev;
+	struct tee_context *ctx;
 	u32 sec_caps;
 	int rc;
 
@@ -719,6 +721,12 @@ static int optee_probe(struct platform_d
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
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -285,6 +285,7 @@ static struct tee_shm *cmd_alloc_suppl(s
 }
 
 static void handle_rpc_func_cmd_shm_alloc(struct tee_context *ctx,
+					  struct optee *optee,
 					  struct optee_msg_arg *arg,
 					  struct optee_call_ctx *call_ctx)
 {
@@ -314,7 +315,8 @@ static void handle_rpc_func_cmd_shm_allo
 		shm = cmd_alloc_suppl(ctx, sz);
 		break;
 	case OPTEE_RPC_SHM_TYPE_KERNEL:
-		shm = tee_shm_alloc(ctx, sz, TEE_SHM_MAPPED | TEE_SHM_PRIV);
+		shm = tee_shm_alloc(optee->ctx, sz,
+				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		break;
 	default:
 		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
@@ -471,7 +473,7 @@ static void handle_rpc_func_cmd(struct t
 		break;
 	case OPTEE_RPC_CMD_SHM_ALLOC:
 		free_pages_list(call_ctx);
-		handle_rpc_func_cmd_shm_alloc(ctx, arg, call_ctx);
+		handle_rpc_func_cmd_shm_alloc(ctx, optee, arg, call_ctx);
 		break;
 	case OPTEE_RPC_CMD_SHM_FREE:
 		handle_rpc_func_cmd_shm_free(ctx, arg);
@@ -502,7 +504,7 @@ void optee_handle_rpc(struct tee_context
 
 	switch (OPTEE_SMC_RETURN_GET_RPC_FUNC(param->a0)) {
 	case OPTEE_SMC_RPC_FUNC_ALLOC:
-		shm = tee_shm_alloc(ctx, param->a1,
+		shm = tee_shm_alloc(optee->ctx, param->a1,
 				    TEE_SHM_MAPPED | TEE_SHM_PRIV);
 		if (!IS_ERR(shm) && !tee_shm_get_pa(shm, 0, &pa)) {
 			reg_pair_from_64(&param->a1, &param->a2, pa);


