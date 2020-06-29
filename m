Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD0520DA30
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbgF2Tym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387671AbgF2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646DC251C6;
        Mon, 29 Jun 2020 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444497;
        bh=5b51oaYGmv5UdBU3iUqjQk4VeeXYAZTpru5VbdHQqGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdK1hu/sjEyX4S9bgdbXcZCbV2hYXNrYgdsKUhuiwQhg9zi6wcUMCAuyzdmpQ/c2I
         27kA0/o4SsnMKj5V8Q41ngzMnYBE2P+2l0adtQmgbu6C49H9HdZxUoYS0Ex+Bp1awr
         UK71rr2iQeysqdmZlAFLOarmn+1ze3PQEVfHtPx0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>, stable@kernel.vger.org,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 174/178] xprtrdma: Fix handling of RDMA_ERROR replies
Date:   Mon, 29 Jun 2020 11:25:19 -0400
Message-Id: <20200629152523.2494198-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 7b2182ec381f8ea15c7eb1266d6b5d7da620ad93 upstream.

The RPC client currently doesn't handle ERR_CHUNK replies correctly.
rpcrdma_complete_rqst() incorrectly passes a negative number to
xprt_complete_rqst() as the number of bytes copied. Instead, set
task->tk_status to the error value, and return zero bytes copied.

In these cases, return -EIO rather than -EREMOTEIO. The RPC client's
finite state machine doesn't know what to do with -EREMOTEIO.

Additional clean ups:
- Don't double-count RDMA_ERROR replies
- Remove a stale comment

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@kernel.vger.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index ef5102b605895..c56e6cfc4a623 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1246,8 +1246,7 @@ rpcrdma_decode_error(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 			be32_to_cpup(p), be32_to_cpu(rep->rr_xid));
 	}
 
-	r_xprt->rx_stats.bad_reply_count++;
-	return -EREMOTEIO;
+	return -EIO;
 }
 
 /* Perform XID lookup, reconstruction of the RPC reply, and
@@ -1284,13 +1283,11 @@ void rpcrdma_complete_rqst(struct rpcrdma_rep *rep)
 	spin_unlock(&xprt->queue_lock);
 	return;
 
-/* If the incoming reply terminated a pending RPC, the next
- * RPC call will post a replacement receive buffer as it is
- * being marshaled.
- */
 out_badheader:
 	trace_xprtrdma_reply_hdr(rep);
 	r_xprt->rx_stats.bad_reply_count++;
+	rqst->rq_task->tk_status = status;
+	status = 0;
 	goto out;
 }
 
-- 
2.25.1

