Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308F13C4BB1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhGLG6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239651AbhGLG6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FFE6124C;
        Mon, 12 Jul 2021 06:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072917;
        bh=H7K8QcNfcYG76IHBiBB1NtHUrfWLWgRNm3vfLuoBcwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9AgjXSuQM3o2J3U3ausWSQxzrI9N+Z9ZmrvGKnmrvKrDm3bs/NLiHQ7J7lXDZ8f8
         vhUl6ZvMlJlP2f8VATqS823IJYM5K99xVXIQf+sz7o0AAjXe0xvjqfY0AQs74gCR0v
         q4SO5RkIhGOU2IqUFLUL7d02OYWMy2Y1i5s+AzkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.12 064/700] SUNRPC: Fix the batch tasks count wraparound.
Date:   Mon, 12 Jul 2021 08:02:27 +0200
Message-Id: <20210712060933.774601582@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit fcb170a9d825d7db4a3fb870b0300f5a40a8d096 upstream.

The 'queue->nr' will wraparound from 0 to 255 when only current
priority queue has tasks. This maybe lead a deadlock same as commit
dfe1fe75e00e ("NFSv4: Fix deadlock between nfs4_evict_inode()
and nfs4_opendata_get_inode()"):

Privileged delegreturn task is queued to privileged list because all
the slots are assigned. When non-privileged task complete and release
the slot, a non-privileged maybe picked out. It maybe allocate slot
failed when the session on draining.

If the 'queue->nr' has wraparound to 255, and no enough slot to
service it, then the privileged delegreturn will lost to wake up.

So we should avoid the wraparound on 'queue->nr'.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 5fcdfacc01f3 ("NFSv4: Return delegations synchronously in evict_inode")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -595,7 +595,8 @@ static struct rpc_task *__rpc_find_next_
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];
-	if (!list_empty(q) && --queue->nr) {
+	if (!list_empty(q) && queue->nr) {
+		queue->nr--;
 		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
 		goto out;
 	}


