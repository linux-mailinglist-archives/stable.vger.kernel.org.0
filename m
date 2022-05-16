Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88884529078
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346569AbiEPULe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351095AbiEPUCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56EFC1B;
        Mon, 16 May 2022 12:58:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F8FB81611;
        Mon, 16 May 2022 19:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6912C385AA;
        Mon, 16 May 2022 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731126;
        bh=bUFY7eu7i1/ALpjYwEI+NkAjHmGD+PiCo82EKhb1sV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oidjhx+Zz5Mwe7V+u5NSvdrvynfULv7iuEfxFseFpKYKIEh3srIlom06JO6CgxtEK
         EJR0bmpJI8laRNqya6ehjdzVQ1jv4dF4vqTnyWo7Vp7FxzH6YHm/jFdLl1+OLiqvEM
         gnoDD1fq56Jb8ceywrp1glcRvjmsBWBLRWlPl/lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.17 108/114] SUNRPC: Ensure that the gssproxy client can start in a connected state
Date:   Mon, 16 May 2022 21:37:22 +0200
Message-Id: <20220516193628.573627117@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit fd13359f54ee854f00134abc6be32da94ec53dbf upstream.

Ensure that the gssproxy client connects to the server from the gssproxy
daemon process context so that the AF_LOCAL socket connection is done
using the correct path and namespaces.

Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/clnt.h          |    1 +
 net/sunrpc/auth_gss/gss_rpc_upcall.c |    1 +
 net/sunrpc/clnt.c                    |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -160,6 +160,7 @@ struct rpc_add_xprt_test {
 #define RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT	(1UL << 9)
 #define RPC_CLNT_CREATE_SOFTERR		(1UL << 10)
 #define RPC_CLNT_CREATE_REUSEPORT	(1UL << 11)
+#define RPC_CLNT_CREATE_CONNECTED	(1UL << 12)
 
 struct rpc_clnt *rpc_create(struct rpc_create_args *args);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -98,6 +98,7 @@ static int gssp_rpc_create(struct net *n
 		 * done without the correct namespace:
 		 */
 		.flags		= RPC_CLNT_CREATE_NOPING |
+				  RPC_CLNT_CREATE_CONNECTED |
 				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT
 	};
 	struct rpc_clnt *clnt;
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -76,6 +76,7 @@ static int	rpc_encode_header(struct rpc_
 static int	rpc_decode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
 static int	rpc_ping(struct rpc_clnt *clnt);
+static int	rpc_ping_noreply(struct rpc_clnt *clnt);
 static void	rpc_check_timeout(struct rpc_task *task);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
@@ -483,6 +484,12 @@ static struct rpc_clnt *rpc_create_xprt(
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
@@ -2699,6 +2706,10 @@ static const struct rpc_procinfo rpcproc
 	.p_decode = rpcproc_decode_null,
 };
 
+static const struct rpc_procinfo rpcproc_null_noreply = {
+	.p_encode = rpcproc_encode_null,
+};
+
 static void
 rpc_null_call_prepare(struct rpc_task *task, void *data)
 {
@@ -2748,6 +2759,28 @@ static int rpc_ping(struct rpc_clnt *cln
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	status = task->tk_status;
+	rpc_put_task(task);
+	return status;
+}
+
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
 	rpc_put_task(task);
 	return status;
 }


