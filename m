Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F252664A113
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiLLNex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiLLNeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:34:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9F113F03
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BB95CE0F7E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC841C433EF;
        Mon, 12 Dec 2022 13:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852082;
        bh=3HeFXCCOZUnbxBErbdHBJVBltb9y8Owem/VhVTDqosk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxTi8q0P4BM9vO8F5DbIT2CwFQNEs1ipxFf9iHdA3em6n4NiP9zqVaNvtBZHmCcsI
         gg2C+lh3vDGHczBG+uEtNIOzew3sRmez/vADT2ErT8wlTkcZecq+wOy+bWArgISHTc
         hU3TMjj2yqVybLPLAkJ3UkKfu749Hawfmrcl3bOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/123] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
Date:   Mon, 12 Dec 2022 14:18:09 +0100
Message-Id: <20221212130932.529361385@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 998b30c3948e4d0b1097e639918c5cff332acac5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1279b5c5c959..eebbe8a6da0c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -9467,8 +9467,10 @@ static void io_tctx_exit_cb(struct callback_head *cb)
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
-- 
2.35.1



