Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11D2A916E
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390966AbfIDSP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390949AbfIDSPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37CA8206BA;
        Wed,  4 Sep 2019 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620923;
        bh=5RKtaah7iUZgvEgs92FlTtLP9kGFjbvWRLMyrrcKGkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYz0KP5Fb/ono6H2YsMyQ3A4XfWOG5EHUjYX2dCwHVBtQRhWGlh8/GUjLb3/AqEQ0
         muQ5hfRLHwnLf/8tB/17pv1B2m7nolz3bPRY+BR/SQheIrl2lsXjh2oo/WWlPEDnZt
         SpAoq8KirSqHhvla4RDLypxNq7EZQuXCn6FckMOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 106/143] Revert "NFSv4/flexfiles: Abort I/O early if the layout segment was invalidated"
Date:   Wed,  4 Sep 2019 19:54:09 +0200
Message-Id: <20190904175318.548352530@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit d5711920ec6e578f51db95caa6f185f5090b865e upstream.

This reverts commit a79f194aa4879e9baad118c3f8bb2ca24dbef765.
The mechanism for aborting I/O is racy, since we are not guaranteed that
the request is asleep while we're changing both task->tk_status and
task->tk_action.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v5.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/flexfilelayout/flexfilelayout.c |   17 -----------------
 include/linux/sunrpc/sched.h           |    1 -
 net/sunrpc/xprt.c                      |    7 -------
 3 files changed, 25 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1128,8 +1128,6 @@ static int ff_layout_async_handle_error_
 		break;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
 		break;
-	case -EAGAIN:
-		return -NFS4ERR_RESET_TO_PNFS;
 	/* Invalidate Layout errors */
 	case -NFS4ERR_PNFS_NO_LAYOUT:
 	case -ESTALE:           /* mapped NFS4ERR_STALE */
@@ -1190,7 +1188,6 @@ static int ff_layout_async_handle_error_
 	case -EBADHANDLE:
 	case -ELOOP:
 	case -ENOSPC:
-	case -EAGAIN:
 		break;
 	case -EJUKEBOX:
 		nfs_inc_stats(lseg->pls_layout->plh_inode, NFSIOS_DELAY);
@@ -1425,16 +1422,6 @@ static void ff_layout_read_prepare_v4(st
 	ff_layout_read_prepare_common(task, hdr);
 }
 
-static void
-ff_layout_io_prepare_transmit(struct rpc_task *task,
-		void *data)
-{
-	struct nfs_pgio_header *hdr = data;
-
-	if (!pnfs_is_valid_lseg(hdr->lseg))
-		rpc_exit(task, -EAGAIN);
-}
-
 static void ff_layout_read_call_done(struct rpc_task *task, void *data)
 {
 	struct nfs_pgio_header *hdr = data;
@@ -1720,7 +1707,6 @@ static void ff_layout_commit_release(voi
 
 static const struct rpc_call_ops ff_layout_read_call_ops_v3 = {
 	.rpc_call_prepare = ff_layout_read_prepare_v3,
-	.rpc_call_prepare_transmit = ff_layout_io_prepare_transmit,
 	.rpc_call_done = ff_layout_read_call_done,
 	.rpc_count_stats = ff_layout_read_count_stats,
 	.rpc_release = ff_layout_read_release,
@@ -1728,7 +1714,6 @@ static const struct rpc_call_ops ff_layo
 
 static const struct rpc_call_ops ff_layout_read_call_ops_v4 = {
 	.rpc_call_prepare = ff_layout_read_prepare_v4,
-	.rpc_call_prepare_transmit = ff_layout_io_prepare_transmit,
 	.rpc_call_done = ff_layout_read_call_done,
 	.rpc_count_stats = ff_layout_read_count_stats,
 	.rpc_release = ff_layout_read_release,
@@ -1736,7 +1721,6 @@ static const struct rpc_call_ops ff_layo
 
 static const struct rpc_call_ops ff_layout_write_call_ops_v3 = {
 	.rpc_call_prepare = ff_layout_write_prepare_v3,
-	.rpc_call_prepare_transmit = ff_layout_io_prepare_transmit,
 	.rpc_call_done = ff_layout_write_call_done,
 	.rpc_count_stats = ff_layout_write_count_stats,
 	.rpc_release = ff_layout_write_release,
@@ -1744,7 +1728,6 @@ static const struct rpc_call_ops ff_layo
 
 static const struct rpc_call_ops ff_layout_write_call_ops_v4 = {
 	.rpc_call_prepare = ff_layout_write_prepare_v4,
-	.rpc_call_prepare_transmit = ff_layout_io_prepare_transmit,
 	.rpc_call_done = ff_layout_write_call_done,
 	.rpc_count_stats = ff_layout_write_count_stats,
 	.rpc_release = ff_layout_write_release,
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -98,7 +98,6 @@ typedef void			(*rpc_action)(struct rpc_
 
 struct rpc_call_ops {
 	void (*rpc_call_prepare)(struct rpc_task *, void *);
-	void (*rpc_call_prepare_transmit)(struct rpc_task *, void *);
 	void (*rpc_call_done)(struct rpc_task *, void *);
 	void (*rpc_count_stats)(struct rpc_task *, void *);
 	void (*rpc_release)(void *);
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1380,13 +1380,6 @@ xprt_request_transmit(struct rpc_rqst *r
 			status = -EBADMSG;
 			goto out_dequeue;
 		}
-		if (task->tk_ops->rpc_call_prepare_transmit) {
-			task->tk_ops->rpc_call_prepare_transmit(task,
-					task->tk_calldata);
-			status = task->tk_status;
-			if (status < 0)
-				goto out_dequeue;
-		}
 		if (RPC_SIGNALLED(task)) {
 			status = -ERESTARTSYS;
 			goto out_dequeue;


