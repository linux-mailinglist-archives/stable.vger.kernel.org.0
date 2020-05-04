Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A96E1C440A
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgEDSDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgEDSDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C61206B8;
        Mon,  4 May 2020 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615418;
        bh=EDuFdQ8OJTSvFYRyENsSd//nuLUV5HFFKR4Cj6SGVTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtBrUzC7+Co9n+vffAkKzfHltO5VdFm1V1zgksw9dxc/Fmf9mik8kKDEj7NbwXTVo
         uhZcI9gO9bt2WEJQS6+cU4yowbOtVwbfAvcU3/3vqq2h5Rc/5p8EhhE8nEAlLuRm6H
         RoJXJ8Zw73thCPq9Jnqzn68hCG6C5Ar588yo1oGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 07/57] NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION
Date:   Mon,  4 May 2020 19:57:11 +0200
Message-Id: <20200504165457.192577326@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

commit dff58530c4ca8ce7ee5a74db431c6e35362cf682 upstream.

Currently, if the client sends BIND_CONN_TO_SESSION with
NFS4_CDFC4_FORE_OR_BOTH but only gets NFS4_CDFS4_FORE back it ignores
that it wasn't able to enable a backchannel.

To make sure, the client sends BIND_CONN_TO_SESSION as the first
operation on the connections (ie., no other session compounds haven't
been sent before), and if the client's request to bind the backchannel
is not satisfied, then reset the connection and retry.

Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c           |    8 ++++++++
 include/linux/nfs_xdr.h     |    2 ++
 include/linux/sunrpc/clnt.h |    5 +++++
 3 files changed, 15 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7852,6 +7852,7 @@ static void
 nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs41_bind_conn_to_session_args *args = task->tk_msg.rpc_argp;
+	struct nfs41_bind_conn_to_session_res *res = task->tk_msg.rpc_resp;
 	struct nfs_client *clp = args->client;
 
 	switch (task->tk_status) {
@@ -7860,6 +7861,12 @@ nfs4_bind_one_conn_to_session_done(struc
 		nfs4_schedule_session_recovery(clp->cl_session,
 				task->tk_status);
 	}
+	if (args->dir == NFS4_CDFC4_FORE_OR_BOTH &&
+			res->dir != NFS4_CDFS4_BOTH) {
+		rpc_task_close_connection(task);
+		if (args->retries++ < MAX_BIND_CONN_TO_SESSION_RETRIES)
+			rpc_restart_call(task);
+	}
 }
 
 static const struct rpc_call_ops nfs4_bind_one_conn_to_session_ops = {
@@ -7882,6 +7889,7 @@ int nfs4_proc_bind_one_conn_to_session(s
 	struct nfs41_bind_conn_to_session_args args = {
 		.client = clp,
 		.dir = NFS4_CDFC4_FORE_OR_BOTH,
+		.retries = 0,
 	};
 	struct nfs41_bind_conn_to_session_res res;
 	struct rpc_message msg = {
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1307,11 +1307,13 @@ struct nfs41_impl_id {
 	struct nfstime4			date;
 };
 
+#define MAX_BIND_CONN_TO_SESSION_RETRIES 3
 struct nfs41_bind_conn_to_session_args {
 	struct nfs_client		*client;
 	struct nfs4_sessionid		sessionid;
 	u32				dir;
 	bool				use_conn_in_rdma_mode;
+	int				retries;
 };
 
 struct nfs41_bind_conn_to_session_res {
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -237,5 +237,10 @@ static inline int rpc_reply_expected(str
 		(task->tk_msg.rpc_proc->p_decode != NULL);
 }
 
+static inline void rpc_task_close_connection(struct rpc_task *task)
+{
+	if (task->tk_xprt)
+		xprt_force_disconnect(task->tk_xprt);
+}
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SUNRPC_CLNT_H */


