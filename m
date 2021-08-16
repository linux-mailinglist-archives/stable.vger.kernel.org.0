Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729CF3ED5B0
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbhHPNNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239109AbhHPNLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1997632BF;
        Mon, 16 Aug 2021 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119416;
        bh=CJlie/aqIeti8Y7mctYoy7F4OMO0uK1jsyvPJHl4E4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcWj22UYUHpn0Pv67ewJPlAQBEVfynuPRck5BxOyKBX2Xg3tK1GHlVS1G176BNVeX
         MlX7dYDOv9gziChwWT5qFS2PuNO2oZ5w8rpFvYCo1F5I47yBzJK/rYt/IA2pi99KpT
         Qc/WlvjiMXLh2nxAv03252d1E9sRoiso+hkpS35c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 018/151] io_uring: drop ctx->uring_lock before flushing work item
Date:   Mon, 16 Aug 2021 15:00:48 +0200
Message-Id: <20210816125444.679820550@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c018db4a57f3e31a9cb24d528e9f094eda89a499 upstream.

Ammar reports that he's seeing a lockdep splat on running test/rsrc_tags
from the regression suite:

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc3-bluetea-test-00249-gc7d102232649 #5 Tainted: G           OE
------------------------------------------------------
kworker/2:4/2684 is trying to acquire lock:
ffff88814bb1c0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_rsrc_put_work+0x13d/0x1a0

but task is already holding lock:
ffffc90001c6be70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x1bc/0x530

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}:
       __flush_work+0x31b/0x490
       io_rsrc_ref_quiesce.part.0.constprop.0+0x35/0xb0
       __do_sys_io_uring_register+0x45b/0x1060
       do_syscall_64+0x35/0xb0
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&ctx->uring_lock){+.+.}-{3:3}:
       __lock_acquire+0x119a/0x1e10
       lock_acquire+0xc8/0x2f0
       __mutex_lock+0x86/0x740
       io_rsrc_put_work+0x13d/0x1a0
       process_one_work+0x236/0x530
       worker_thread+0x52/0x3b0
       kthread+0x135/0x160
       ret_from_fork+0x1f/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&(&ctx->rsrc_put_work)->work));
                               lock(&ctx->uring_lock);
                               lock((work_completion)(&(&ctx->rsrc_put_work)->work));
  lock(&ctx->uring_lock);

 *** DEADLOCK ***

2 locks held by kworker/2:4/2684:
 #0: ffff88810004d938 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1bc/0x530
 #1: ffffc90001c6be70 ((work_completion)(&(&ctx->rsrc_put_work)->work)){+.+.}-{0:0}, at: process_one_work+0x1bc/0x530

stack backtrace:
CPU: 2 PID: 2684 Comm: kworker/2:4 Tainted: G           OE     5.14.0-rc3-bluetea-test-00249-gc7d102232649 #5
Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIOS V1.05 07/02/2015
Workqueue: events io_rsrc_put_work
Call Trace:
 dump_stack_lvl+0x6a/0x9a
 check_noncircular+0xfe/0x110
 __lock_acquire+0x119a/0x1e10
 lock_acquire+0xc8/0x2f0
 ? io_rsrc_put_work+0x13d/0x1a0
 __mutex_lock+0x86/0x740
 ? io_rsrc_put_work+0x13d/0x1a0
 ? io_rsrc_put_work+0x13d/0x1a0
 ? io_rsrc_put_work+0x13d/0x1a0
 ? process_one_work+0x1ce/0x530
 io_rsrc_put_work+0x13d/0x1a0
 process_one_work+0x236/0x530
 worker_thread+0x52/0x3b0
 ? process_one_work+0x530/0x530
 kthread+0x135/0x160
 ? set_kthread_struct+0x40/0x40
 ret_from_fork+0x1f/0x30

which is due to holding the ctx->uring_lock when flushing existing
pending work, while the pending work flushing may need to grab the uring
lock if we're using IOPOLL.

Fix this by dropping the uring_lock a bit earlier as part of the flush.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/404
Tested-by: Ammar Faizi <ammarfaizi2@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7166,17 +7166,19 @@ static int io_rsrc_ref_quiesce(struct io
 		/* kill initial ref, already quiesced if zero */
 		if (atomic_dec_and_test(&data->refs))
 			break;
+		mutex_unlock(&ctx->uring_lock);
 		flush_delayed_work(&ctx->rsrc_put_work);
 		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret)
+		if (!ret) {
+			mutex_lock(&ctx->uring_lock);
 			break;
+		}
 
 		atomic_inc(&data->refs);
 		/* wait for all works potentially completing data->done */
 		flush_delayed_work(&ctx->rsrc_put_work);
 		reinit_completion(&data->done);
 
-		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
 	} while (ret >= 0);


