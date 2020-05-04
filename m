Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A71C44D7
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbgEDSFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgEDSFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3172C2073E;
        Mon,  4 May 2020 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615511;
        bh=m4EcSt3zXHUMsSW3fDHvl3oNDX5fcLVwzpe1swlR0eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cs89Olrnd9P+HLg9sKiTjxSMUJ3y06omoxQp3WCdUPSeJvlAtDqZyOQD6+hQcKO+i
         Kcq0GvlIblkEOmm1v+bWa/YZalMmezVGx7qXB+KuFKEK22EC6pCfAbrUkiThErmR0y
         h0hubT7VI1Mt83egYCV4X9oli1xUlm8g+hCPG/KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.6 11/73] NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION
Date:   Mon,  4 May 2020 19:57:14 +0200
Message-Id: <20200504165504.007128955@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
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
@@ -7893,6 +7893,7 @@ static void
 nfs4_bind_one_conn_to_session_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs41_bind_conn_to_session_args *args = task->tk_msg.rpc_argp;
+	struct nfs41_bind_conn_to_session_res *res = task->tk_msg.rpc_resp;
 	struct nfs_client *clp = args->client;
 
 	switch (task->tk_status) {
@@ -7901,6 +7902,12 @@ nfs4_bind_one_conn_to_session_done(struc
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
@@ -7923,6 +7930,7 @@ int nfs4_proc_bind_one_conn_to_session(s
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
@@ -236,4 +236,9 @@ static inline int rpc_reply_expected(str
 		(task->tk_msg.rpc_proc->p_decode != NULL);
 }
 
+static inline void rpc_task_close_connection(struct rpc_task *task)
+{
+	if (task->tk_xprt)
+		xprt_force_disconnect(task->tk_xprt);
+}
 #endif /* _LINUX_SUNRPC_CLNT_H */


