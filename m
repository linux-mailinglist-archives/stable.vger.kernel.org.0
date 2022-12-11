Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1FF64936A
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 10:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLKJvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 04:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLKJvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 04:51:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508C10FD9
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 01:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 309D3B80975
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E72C433D2;
        Sun, 11 Dec 2022 09:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670752295;
        bh=+W1EZLj3Cg1NMctGRE95lhRfhpQekZ54iJhP7K+u/ZU=;
        h=Subject:To:Cc:From:Date:From;
        b=sRLR9jzZSJAmTWPWDq47Qd7Lnll0QuE2n4CIZPFYiXGRoN6+AQrMKu+rDyLEpmqd3
         4aq8B96F98styV5sV/ehsXqNBWzEN+64sYt+ceLB6NbhvJgsDSjpTMg4wVKIQDB3v/
         DyV1cLDxllG0sMQl22t1qdzL2xrh9u4CGZzePqo0=
Subject: FAILED: patch "[PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()" failed to apply to 5.15-stable tree
To:     harshit.m.mogalapalli@oracle.com, axboe@kernel.dk,
        syzkaller@googlegroups.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Dec 2022 10:51:32 +0100
Message-ID: <16707522923183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

998b30c3948e ("io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()")
ed29b0b4fd83 ("io_uring: move to separate directory")
4c928904ff77 ("block: move CONFIG_BLOCK guard to top Makefile")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 998b30c3948e4d0b1097e639918c5cff332acac5 Mon Sep 17 00:00:00 2001
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Date: Tue, 6 Dec 2022 01:38:32 -0800
Subject: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()

Syzkaller reports a NULL deref bug as follows:

 BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
 Read of size 4 at addr 0000000000000138 by task file1/1955

 CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0xcd/0x134
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_report+0xbb/0x1f0
  ? io_tctx_exit_cb+0x53/0xd3
  kasan_check_range+0x140/0x190
  io_tctx_exit_cb+0x53/0xd3
  task_work_run+0x164/0x250
  ? task_work_cancel+0x30/0x30
  get_signal+0x1c3/0x2440
  ? lock_downgrade+0x6e0/0x6e0
  ? lock_downgrade+0x6e0/0x6e0
  ? exit_signals+0x8b0/0x8b0
  ? do_raw_read_unlock+0x3b/0x70
  ? do_raw_spin_unlock+0x50/0x230
  arch_do_signal_or_restart+0x82/0x2470
  ? kmem_cache_free+0x260/0x4b0
  ? putname+0xfe/0x140
  ? get_sigframe_size+0x10/0x10
  ? do_execveat_common.isra.0+0x226/0x710
  ? lockdep_hardirqs_on+0x79/0x100
  ? putname+0xfe/0x140
  ? do_execveat_common.isra.0+0x238/0x710
  exit_to_user_mode_prepare+0x15f/0x250
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x42/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0023:0x0
 Code: Unable to access opcode bytes at 0xffffffffffffffd6.
 RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
 Kernel panic - not syncing: panic_on_warn set ...

This happens because the adding of task_work from io_ring_exit_work()
isn't synchronized with canceling all work items from eg exec. The
execution of the two are ordered in that they are both run by the task
itself, but if io_tctx_exit_cb() is queued while we're canceling all
work items off exec AND gets executed when the task exits to userspace
rather than in the main loop in io_uring_cancel_generic(), then we can
find current->io_uring == NULL and hit the above crash.

It's safe to add this NULL check here, because the execution of the two
paths are done by the task itself.

Cc: stable@vger.kernel.org
Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com
[axboe: add code comment and also put an explanation in the commit msg]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8840cf3e20f2..61cd7ffd0f6a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2707,8 +2707,10 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	/*
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 * tctx can be NULL if the queueing of this task_work raced with
+	 * work cancelation off the exec path.
 	 */
-	if (!atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }

