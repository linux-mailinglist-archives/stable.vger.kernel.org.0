Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E79327C84A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgI2MAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730582AbgI2Lkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF4E62076A;
        Tue, 29 Sep 2020 11:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379640;
        bh=uMzatrwYt8y8qpM4E128ZkyGVe/RJOCjs/3WqC4f2/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzJmkbPKGte/gRsPSmUZB2haUXWozYZ0kcjJ1LSZ5WWOO2ziTMB59vqMTFku8sqt2
         vbl+tApJ53xVwGwhZra0fLEvtaY76RdbUdxG2rixP8HxRVybsYew/nvwIye4gFYtIN
         9szevj6ew6qYvRnVYPDbAvlllDz4wc/PD2yArWv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/388] SUNRPC: Dont start a timer on an already queued rpc task
Date:   Tue, 29 Sep 2020 12:59:14 +0200
Message-Id: <20200929110021.274284127@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1fab7dc477241c12f977955aa6baea7938b6f08d ]

Move the test for whether a task is already queued to prevent
corruption of the timer list in __rpc_sleep_on_priority_timeout().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 9c79548c68474..53d8b82eda006 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -204,10 +204,6 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 		struct rpc_task *task,
 		unsigned char queue_priority)
 {
-	WARN_ON_ONCE(RPC_IS_QUEUED(task));
-	if (RPC_IS_QUEUED(task))
-		return;
-
 	INIT_LIST_HEAD(&task->u.tk_wait.timer_list);
 	if (RPC_IS_PRIORITY(queue))
 		__rpc_add_wait_queue_priority(queue, task, queue_priority);
@@ -382,7 +378,7 @@ static void rpc_make_runnable(struct workqueue_struct *wq,
  * NB: An RPC task will only receive interrupt-driven events as long
  * as it's on a wait queue.
  */
-static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
+static void __rpc_do_sleep_on_priority(struct rpc_wait_queue *q,
 		struct rpc_task *task,
 		unsigned char queue_priority)
 {
@@ -395,12 +391,23 @@ static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
 
 }
 
+static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
+		struct rpc_task *task,
+		unsigned char queue_priority)
+{
+	if (WARN_ON_ONCE(RPC_IS_QUEUED(task)))
+		return;
+	__rpc_do_sleep_on_priority(q, task, queue_priority);
+}
+
 static void __rpc_sleep_on_priority_timeout(struct rpc_wait_queue *q,
 		struct rpc_task *task, unsigned long timeout,
 		unsigned char queue_priority)
 {
+	if (WARN_ON_ONCE(RPC_IS_QUEUED(task)))
+		return;
 	if (time_is_after_jiffies(timeout)) {
-		__rpc_sleep_on_priority(q, task, queue_priority);
+		__rpc_do_sleep_on_priority(q, task, queue_priority);
 		__rpc_add_timer(q, task, timeout);
 	} else
 		task->tk_status = -ETIMEDOUT;
-- 
2.25.1



