Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AEB3CDA7A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbhGSOgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343499AbhGSOe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC256120E;
        Mon, 19 Jul 2021 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707705;
        bh=W4ByK9wkQG1cSVbGIN/eHosYp9Dpk8vAUElkANoImus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+oG6vUOKG8nCUooy/H3R33dvoX40oFr3yjsSabMhFCQyF6OcXXC0Ous3voPWFEL2
         bj7LCAtLDnMy0Yv18oCWxHNouweUCbSU8SuO1uUuths6ATk+FH33ITRJUwKoeosa3S
         xvZt5BlclWvFnFyOUJciI8Lbe7dQoPQ0rIBbj6Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 023/315] SUNRPC: Should wake up the privileged task firstly.
Date:   Mon, 19 Jul 2021 16:48:32 +0200
Message-Id: <20210719144943.646833040@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 5483b904bf336948826594610af4c9bbb0d9e3aa upstream.

When find a task from wait queue to wake up, a non-privileged task may
be found out, rather than the privileged. This maybe lead a deadlock
same as commit dfe1fe75e00e ("NFSv4: Fix deadlock between nfs4_evict_inode()
and nfs4_opendata_get_inode()"):

Privileged delegreturn task is queued to privileged list because all
the slots are assigned. If there has no enough slot to wake up the
non-privileged batch tasks(session less than 8 slot), then the privileged
delegreturn task maybe lost waked up because the found out task can't
get slot since the session is on draining.

So we should treate the privileged task as the emergency task, and
execute it as for as we can.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 5fcdfacc01f3 ("NFSv4: Return delegations synchronously in evict_inode")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sched.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -487,6 +487,15 @@ static struct rpc_task *__rpc_find_next_
 	struct rpc_task *task;
 
 	/*
+	 * Service the privileged queue.
+	 */
+	q = &queue->tasks[RPC_NR_PRIORITY - 1];
+	if (queue->maxpriority > RPC_PRIORITY_PRIVILEGED && !list_empty(q)) {
+		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
+		goto out;
+	}
+
+	/*
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];


