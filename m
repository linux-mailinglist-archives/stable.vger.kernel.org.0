Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7306D1C8FE0
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgEGOfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgEGO2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F3B6218AC;
        Thu,  7 May 2020 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861704;
        bh=o6PaR1/R/MRl/FjFPECd7AUCCz6IqqoI0ngS/aGTPEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRz9wuoOEq8P0Yd4U/uQMToNKjwATxaobLbZP46O4yqR0IYplVS50NxQI1BdvCU0u
         dFxH6t0C2pKD6beYl13OWLhJ4WdquyTw1on/bjYSEr0Y1SELochzanzUUHyBZ8y3EF
         CtkIyhU0Ce5RobohesEBQFtS/ICAZnLyKBBf7vQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 45/50] io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()
Date:   Thu,  7 May 2020 10:27:21 -0400
Message-Id: <20200507142726.25751-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a46de2cfc28e8..b5ade01379029 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6449,7 +6449,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	 * it could cause shutdown to hang.
 	 */
 	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
-		cpu_relax();
+		cond_resched();
 
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
-- 
2.20.1

