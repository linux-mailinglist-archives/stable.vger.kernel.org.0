Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA37527FA9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiEPI1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241851AbiEPI0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:26:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C693EE013
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB92B80EB2
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB65CC385AA;
        Mon, 16 May 2022 08:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652689604;
        bh=WSlgssqFpB+8TxaQs0VpdnP15cM8JTpm2lBAN7lX3F8=;
        h=Subject:To:Cc:From:Date:From;
        b=2mbPCDK317b6XW1kQTFHp3qfqnvzZkRowfKE4vrGMKvmjoyF5PC3YQEN44FWvp0MT
         zidDmHpJ14i1rXKt2AANRJK3GZ8R5qwuO3jBReCoQ/hQ+FHFQETmqqA2HVSutHFZm+
         vZZCzC7pA1iRagqM57J179Q3O2/sB3ut6w61iRMY=
Subject: FAILED: patch "[PATCH] SUNRPC: Ensure that the gssproxy client can start in a" failed to apply to 5.10-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:25:22 +0200
Message-ID: <1652689522193156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd13359f54ee854f00134abc6be32da94ec53dbf Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Sat, 7 May 2022 13:53:59 -0400
Subject: [PATCH] SUNRPC: Ensure that the gssproxy client can start in a
 connected state

Ensure that the gssproxy client connects to the server from the gssproxy
daemon process context so that the AF_LOCAL socket connection is done
using the correct path and namespaces.

Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 267b7aeaf1a6..90501404fa49 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -160,6 +160,7 @@ struct rpc_add_xprt_test {
 #define RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT	(1UL << 9)
 #define RPC_CLNT_CREATE_SOFTERR		(1UL << 10)
 #define RPC_CLNT_CREATE_REUSEPORT	(1UL << 11)
+#define RPC_CLNT_CREATE_CONNECTED	(1UL << 12)
 
 struct rpc_clnt *rpc_create(struct rpc_create_args *args);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 61c276bddaf2..f549e4c05def 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -98,6 +98,7 @@ static int gssp_rpc_create(struct net *net, struct rpc_clnt **_clnt)
 		 * done without the correct namespace:
 		 */
 		.flags		= RPC_CLNT_CREATE_NOPING |
+				  RPC_CLNT_CREATE_CONNECTED |
 				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT
 	};
 	struct rpc_clnt *clnt;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 98133aa54f19..e2c6eca0271b 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -76,6 +76,7 @@ static int	rpc_encode_header(struct rpc_task *task,
 static int	rpc_decode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
 static int	rpc_ping(struct rpc_clnt *clnt);
+static int	rpc_ping_noreply(struct rpc_clnt *clnt);
 static void	rpc_check_timeout(struct rpc_task *task);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
@@ -483,6 +484,12 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 			rpc_shutdown_client(clnt);
 			return ERR_PTR(err);
 		}
+	} else if (args->flags & RPC_CLNT_CREATE_CONNECTED) {
+		int err = rpc_ping_noreply(clnt);
+		if (err != 0) {
+			rpc_shutdown_client(clnt);
+			return ERR_PTR(err);
+		}
 	}
 
 	clnt->cl_softrtry = 1;
@@ -2709,6 +2716,10 @@ static const struct rpc_procinfo rpcproc_null = {
 	.p_decode = rpcproc_decode_null,
 };
 
+static const struct rpc_procinfo rpcproc_null_noreply = {
+	.p_encode = rpcproc_encode_null,
+};
+
 static void
 rpc_null_call_prepare(struct rpc_task *task, void *data)
 {
@@ -2762,6 +2773,28 @@ static int rpc_ping(struct rpc_clnt *clnt)
 	return status;
 }
 
+static int rpc_ping_noreply(struct rpc_clnt *clnt)
+{
+	struct rpc_message msg = {
+		.rpc_proc = &rpcproc_null_noreply,
+	};
+	struct rpc_task_setup task_setup_data = {
+		.rpc_client = clnt,
+		.rpc_message = &msg,
+		.callback_ops = &rpc_null_ops,
+		.flags = RPC_TASK_SOFT | RPC_TASK_SOFTCONN | RPC_TASK_NULLCREDS,
+	};
+	struct rpc_task	*task;
+	int status;
+
+	task = rpc_run_task(&task_setup_data);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+	status = task->tk_status;
+	rpc_put_task(task);
+	return status;
+}
+
 struct rpc_cb_add_xprt_calldata {
 	struct rpc_xprt_switch *xps;
 	struct rpc_xprt *xprt;

