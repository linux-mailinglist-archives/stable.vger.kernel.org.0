Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D5F3CD8E7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbhGSO0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243880AbhGSOYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954226128C;
        Mon, 19 Jul 2021 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707061;
        bh=FmAVlWNamuC3GE2YBzJqk0R5gjzAnQP1bm5KdpmSjkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP1zy07YTY+cvbz04QAAKVUXdEIpJYfJmLCqiVcqAxSPWoNMrr5tRpvzE0XGfq6ds
         HccEy7NJteLDv9KCrwgKEp/GsrAFZpwf57/NX3JV/x2G/cfNr8J0xqw47ymAo45XVx
         wQR6Xxthvg1WNbk3QliFhINQ3U2DfzaH75ZXtTKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.9 016/245] SUNRPC: Fix the batch tasks count wraparound.
Date:   Mon, 19 Jul 2021 16:49:18 +0200
Message-Id: <20210719144940.913158919@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
@@ -490,7 +490,8 @@ static struct rpc_task *__rpc_find_next_
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];
-	if (!list_empty(q) && --queue->nr) {
+	if (!list_empty(q) && queue->nr) {
+		queue->nr--;
 		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
 		goto out;
 	}


