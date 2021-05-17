Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76200382FBE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhEQOU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239016AbhEQOR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:17:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B60EC61402;
        Mon, 17 May 2021 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260614;
        bh=kdJWbIocDoNQYfZqzv8L07x8UXrDuFbjWr2+dD5j2wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSxoQgsl1mI6opORR3ZGO5176q3xNNedkTqVB4Cr2LWks3TE4UaPlWdIAshwHuXQU
         PT2JFi6foLgW+9sAVSAnFL8jr6cSSV9SIQcbkefj/visp5kex4uv0gIxUxK6hhZ0Sf
         v0RLu0Yk272hEEhJI0r+v6Vti7ZBIrkymxMqjN+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 161/363] SUNRPC: Remove trace_xprt_transmit_queued
Date:   Mon, 17 May 2021 16:00:27 +0200
Message-Id: <20210517140308.047694788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6cf23783f750634e10daeede48b0f5f5d64ebf3a ]

This tracepoint can crash when dereferencing snd_task because
when some transports connect, they put a cookie in that field
instead of a pointer to an rpc_task.

BUG: KASAN: use-after-free in trace_event_raw_event_xprt_writelock_event+0x141/0x18e [sunrpc]
Read of size 2 at addr ffff8881a83bd3a0 by task git/331872

CPU: 11 PID: 331872 Comm: git Tainted: G S                5.12.0-rc2-00007-g3ab6e585a7f9 #1453
Hardware name: Supermicro SYS-6028R-T/X10DRi, BIOS 1.1a 10/16/2015
Call Trace:
 dump_stack+0x9c/0xcf
 print_address_description.constprop.0+0x18/0x239
 kasan_report+0x174/0x1b0
 trace_event_raw_event_xprt_writelock_event+0x141/0x18e [sunrpc]
 xprt_prepare_transmit+0x8e/0xc1 [sunrpc]
 call_transmit+0x4d/0xc6 [sunrpc]

Fixes: 9ce07ae5eb1d ("SUNRPC: Replace dprintk() call site in xprt_prepare_transmit")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 1 -
 net/sunrpc/xprt.c             | 2 --
 2 files changed, 3 deletions(-)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 036eb1f5c133..2f01314de73a 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1141,7 +1141,6 @@ DECLARE_EVENT_CLASS(xprt_writelock_event,
 
 DEFINE_WRITELOCK_EVENT(reserve_xprt);
 DEFINE_WRITELOCK_EVENT(release_xprt);
-DEFINE_WRITELOCK_EVENT(transmit_queued);
 
 DECLARE_EVENT_CLASS(xprt_cong_event,
 	TP_PROTO(
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d616b93751d8..11ebe8a127b8 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1469,8 +1469,6 @@ bool xprt_prepare_transmit(struct rpc_task *task)
 	struct rpc_xprt	*xprt = req->rq_xprt;
 
 	if (!xprt_lock_write(xprt, task)) {
-		trace_xprt_transmit_queued(xprt, task);
-
 		/* Race breaker: someone may have transmitted us */
 		if (!test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
 			rpc_wake_up_queued_task_set_status(&xprt->sending,
-- 
2.30.2



