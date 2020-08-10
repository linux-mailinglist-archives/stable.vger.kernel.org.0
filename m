Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7D240A53
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgHJPX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgHJPXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:23:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD8020782;
        Mon, 10 Aug 2020 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073034;
        bh=YPDX0crp7GERTlrl95GtvjvBnhsR8R4/6rjI44AeOc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgF4qe7ZetUpdcCbeISChIHyzaWi2EcWPbBUtLCwY7qSXNHqE2RRFDomjOGCYbEcl
         hZ/LQlPce91Us8SR/T30Bvvtm2ogPo1pisE+5ORnzpy9ZIT6e7sy6n/vSXEDkvzrHZ
         C6P3dG3/mLJLKs86x0kQ1HzzTjc53uoLsrvwUphI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 36/79] io_uring: fix lockup in io_fail_links()
Date:   Mon, 10 Aug 2020 17:20:55 +0200
Message-Id: <20200810151814.064738321@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 4ae6dbd683860b9edc254ea8acf5e04b5ae242e5 ]

io_fail_links() doesn't consider REQ_F_COMP_LOCKED leading to nested
spin_lock(completion_lock) and lockup.

[  197.680409] rcu: INFO: rcu_preempt detected expedited stalls on
	CPUs/tasks: { 6-... } 18239 jiffies s: 1421 root: 0x40/.
[  197.680411] rcu: blocking rcu_node structures:
[  197.680412] Task dump for CPU 6:
[  197.680413] link-timeout    R  running task        0  1669
	1 0x8000008a
[  197.680414] Call Trace:
[  197.680420]  ? io_req_find_next+0xa0/0x200
[  197.680422]  ? io_put_req_find_next+0x2a/0x50
[  197.680423]  ? io_poll_task_func+0xcf/0x140
[  197.680425]  ? task_work_run+0x67/0xa0
[  197.680426]  ? do_exit+0x35d/0xb70
[  197.680429]  ? syscall_trace_enter+0x187/0x2c0
[  197.680430]  ? do_group_exit+0x43/0xa0
[  197.680448]  ? __x64_sys_exit_group+0x18/0x20
[  197.680450]  ? do_syscall_64+0x52/0xa0
[  197.680452]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4e09af1d5d223..fb9dc865c9eaa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4260,10 +4260,9 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	io_put_req_find_next(req, nxt);
 	io_cqring_ev_posted(ctx);
 }
 
-- 
2.25.1



