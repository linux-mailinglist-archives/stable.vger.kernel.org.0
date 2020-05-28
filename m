Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2E1E6078
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389543AbgE1MK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:10:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388648AbgE1L4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DE9A20757;
        Thu, 28 May 2020 11:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666972;
        bh=GnMgnxYhRI8NeT2MgBln2uWfNJFU6Be3XUbVAerzCfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiPTk5bsTrNbkY9JUGG4J1NJx/CxfJILdkhw/GuzyL3FHIInDaQlaU8yg+fJ/l5j2
         c4uNAHr3k1WuAJjdGsCNX2qPtF/Ww+mEspYa9p1avmnYhxExywzA0GX5ef2tIBcjgX
         5LQG6Q6cJCdzhc+ep2sjdd3qfCZb1hv4tfiUcMSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 10/47] io_uring: initialize ctx->sqo_wait earlier
Date:   Thu, 28 May 2020 07:55:23 -0400
Message-Id: <20200528115600.1405808-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 583863ed918136412ddf14de2e12534f17cfdc6f ]

Ensure that ctx->sqo_wait is initialized as soon as the ctx is allocated,
instead of deferring it to the offload setup. This fixes a syzbot
reported lockdep complaint, which is really due to trying to wake_up
on an uninitialized wait queue:

RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441319
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 000000000000047b
RBP: 0000000000010475 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402260
R13: 00000000004022f0 R14: 0000000000000000 R15: 0000000000000000
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 7090 Comm: syz-executor222 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:913 [inline]
 register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
 __lock_acquire+0x104/0x4c50 kernel/locking/lockdep.c:4234
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
 io_cqring_ev_posted+0xa5/0x1e0 fs/io_uring.c:1160
 io_poll_remove_all fs/io_uring.c:4357 [inline]
 io_ring_ctx_wait_and_kill+0x2bc/0x5a0 fs/io_uring.c:7305
 io_uring_create fs/io_uring.c:7843 [inline]
 io_uring_setup+0x115e/0x22b0 fs/io_uring.c:7870
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x441319
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffb1fb9aa8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9

Reported-by: syzbot+8c91f5d054e998721c57@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 832e042531bc..8bdf2629f7fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -822,6 +822,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	init_waitqueue_head(&ctx->sqo_wait);
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->completions[0]);
@@ -6004,7 +6005,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 {
 	int ret;
 
-	init_waitqueue_head(&ctx->sqo_wait);
 	mmgrab(current->mm);
 	ctx->sqo_mm = current->mm;
 
-- 
2.25.1

