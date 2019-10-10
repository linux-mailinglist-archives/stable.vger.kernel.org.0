Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB71D258F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbfJJJBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388451AbfJJImA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDDDD2190F;
        Thu, 10 Oct 2019 08:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696920;
        bh=6mUDVz+V8A+YajlAGgRR43msclML2hmI0m4Bue6sju8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NdUqPljWeP957wfD9qw+YKss2+gw9WpI2nbSENrYcvKLl6qeGfHNeLSHEYxDgd9b
         uXita0qjpqgwjeJ1tP1y+T7m1jOEO8KzLUXgknZfm4Qkx+/q91pOAvXUmYer8rXX2j
         3JnBtWO19L0vwRdEmsstwDgKe1Z5jYfcs8Yfouns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 101/148] SUNRPC: RPC level errors should always set task->tk_rpc_status
Date:   Thu, 10 Oct 2019 10:36:02 +0200
Message-Id: <20191010083617.350460632@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 714fbc73888f59321854e7f6c2f224213923bcad ]

Ensure that we set task->tk_rpc_status for all RPC level errors so that
the caller can distinguish between those and server reply status errors.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c  | 6 +++---
 net/sunrpc/sched.c | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7a75f34ad393b..e7fdc400506e8 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1837,7 +1837,7 @@ call_allocate(struct rpc_task *task)
 		return;
 	}
 
-	rpc_exit(task, -ERESTARTSYS);
+	rpc_call_rpcerror(task, -ERESTARTSYS);
 }
 
 static int
@@ -2561,7 +2561,7 @@ rpc_encode_header(struct rpc_task *task, struct xdr_stream *xdr)
 	return 0;
 out_fail:
 	trace_rpc_bad_callhdr(task);
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 }
 
@@ -2628,7 +2628,7 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 		return -EAGAIN;
 	}
 out_err:
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 
 out_unparsable:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 1f275aba786fc..53934fe73a9db 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -930,8 +930,10 @@ static void __rpc_execute(struct rpc_task *task)
 		/*
 		 * Signalled tasks should exit rather than sleep.
 		 */
-		if (RPC_SIGNALLED(task))
+		if (RPC_SIGNALLED(task)) {
+			task->tk_rpc_status = -ERESTARTSYS;
 			rpc_exit(task, -ERESTARTSYS);
+		}
 
 		/*
 		 * The queue->lock protects against races with
@@ -967,6 +969,7 @@ static void __rpc_execute(struct rpc_task *task)
 			 */
 			dprintk("RPC: %5u got signal\n", task->tk_pid);
 			set_bit(RPC_TASK_SIGNALLED, &task->tk_runstate);
+			task->tk_rpc_status = -ERESTARTSYS;
 			rpc_exit(task, -ERESTARTSYS);
 		}
 		dprintk("RPC: %5u sync task resuming\n", task->tk_pid);
-- 
2.20.1



