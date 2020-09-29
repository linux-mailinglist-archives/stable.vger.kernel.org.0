Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9319027C9AB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgI2MMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A8823B70;
        Tue, 29 Sep 2020 11:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379268;
        bh=94AT0YPweooXiO7gK1/oiuOCZdrXc0s4UM0WFbWcmvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0UniyVQqxQOh8EEQ3kdbuho5gdl5oPYGHNV24EqkRNmE1WHJMiwSe1Mr99yZhqQ1
         YI2AGYinkoZU9XEXChxzBH0J2OvLN9l5+IEqdeB7jFOAfO4ts+/hZ24zZ0j8cXL+uJ
         NX71ZvZN/kM4bC6Ece6gCdhQq9AxD2dE5/HQ3mY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/388] SUNRPC: Capture completion of all RPC tasks
Date:   Tue, 29 Sep 2020 12:56:29 +0200
Message-Id: <20200929110013.304009219@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a264abad51d8ecb7954a2f6d9f1885b38daffc74 ]

RPC tasks on the backchannel never invoke xprt_complete_rqst(), so
there is no way to report their tk_status at completion. Also, any
RPC task that exits via rpc_exit_task() before it is replied to will
also disappear without a trace.

Introduce a trace point that is symmetrical with rpc_task_begin that
captures the termination status of each RPC task.

Sample trace output for callback requests initiated on the server:
   kworker/u8:12-448   [003]   127.025240: rpc_task_end:         task:50@3 flags=ASYNC|DYNAMIC|SOFT|SOFTCONN|SENT runstate=RUNNING|ACTIVE status=0 action=rpc_exit_task
   kworker/u8:12-448   [002]   127.567310: rpc_task_end:         task:51@3 flags=ASYNC|DYNAMIC|SOFT|SOFTCONN|SENT runstate=RUNNING|ACTIVE status=0 action=rpc_exit_task
   kworker/u8:12-448   [001]   130.506817: rpc_task_end:         task:52@3 flags=ASYNC|DYNAMIC|SOFT|SOFTCONN|SENT runstate=RUNNING|ACTIVE status=0 action=rpc_exit_task

Odd, though, that I never see trace_rpc_task_complete, either in the
forward or backchannel. Should it be removed?

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sunrpc.h | 1 +
 net/sunrpc/sched.c            | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index ffa3c51dbb1a0..28df77a948e56 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -165,6 +165,7 @@ DECLARE_EVENT_CLASS(rpc_task_running,
 DEFINE_RPC_RUNNING_EVENT(begin);
 DEFINE_RPC_RUNNING_EVENT(run_action);
 DEFINE_RPC_RUNNING_EVENT(complete);
+DEFINE_RPC_RUNNING_EVENT(end);
 
 DECLARE_EVENT_CLASS(rpc_task_queued,
 
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 987c4b1f0b174..9c79548c68474 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -824,6 +824,7 @@ rpc_reset_task_statistics(struct rpc_task *task)
  */
 void rpc_exit_task(struct rpc_task *task)
 {
+	trace_rpc_task_end(task, task->tk_action);
 	task->tk_action = NULL;
 	if (task->tk_ops->rpc_count_stats)
 		task->tk_ops->rpc_count_stats(task, task->tk_calldata);
-- 
2.25.1



