Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE971D8471
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgERSCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732531AbgERSCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:02:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FD020826;
        Mon, 18 May 2020 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824949;
        bh=MnVZ8YB95EmxBqxmwt11FwSNiLoPIlEMw9ZmUH95iPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxutOka6SeVHp3vguSYoZ7+oH6OPfb6wDI8GUBal7E9DV8zXfMSdEDhWlh8q7jftn
         KEslEUhlMhB0o2jNIXz/Uvvyu0Q290i5qtawD1bsJuMZ2WLfffcazZYhUpSMMVvyEA
         wwkdT89V9X1rsSJj02BrC9rb1EzOu32dnprUHTGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 067/194] io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()
Date:   Mon, 18 May 2020 19:35:57 +0200
Message-Id: <20200518173537.317015147@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit 3fd44c86711f71156b586c22b0495c58f69358bb ]

While working on to make io_uring sqpoll mode support syscalls that need
struct files_struct, I got cpu soft lockup in io_ring_ctx_wait_and_kill(),

    while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
        cpu_relax();

above loop never has an chance to exit, it's because preempt isn't enabled
in the kernel, and the context calling io_ring_ctx_wait_and_kill() and
io_sq_thread() run in the same cpu, if io_sq_thread calls a cond_resched()
yield cpu and another context enters above loop, then io_sq_thread() will
always in runqueue and never exit.

Use cond_resched() can fix this issue.

 Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9690c845a3e4b..01f71b9efb88f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6451,7 +6451,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * it could cause shutdown to hang.
 	 */
 	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
-		cpu_relax();
+		cond_resched();
 
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
-- 
2.20.1



