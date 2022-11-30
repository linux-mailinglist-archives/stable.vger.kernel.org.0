Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654BE63DFB7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiK3Stz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiK3Stp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F68A99F07
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0B861D5E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A173C433D6;
        Wed, 30 Nov 2022 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834183;
        bh=8VUJviAZu9DREPgUYsje3/HirMm0w8ZisG56Eu6lYbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLqlmBY6oAJff7YVFMltI/xuDS3jMcUdUHueXJRIDub4h+v8iwlckcvp02sXwunFi
         67zdZn1HqrTmq4ByvmA4C83qeZr4sjUuxfTrSG3sc7iJCUZd/3EFv9TSml7noUPtZl
         x0sO/gAbhNyfbMPq/XMZrbyICNlF/DZXsImc2NDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Ma <linma@zju.edu.cn>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 159/289] io_uring/poll: fix poll_refs race with cancelation
Date:   Wed, 30 Nov 2022 19:22:24 +0100
Message-Id: <20221130180547.738600572@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 12ad3d2d6c5b0131a6052de91360849e3e154846 ]

There is an interesting race condition of poll_refs which could result
in a NULL pointer dereference. The crash trace is like:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 30781 Comm: syz-executor.2 Not tainted 6.0.0-g493ffd6605b2 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:io_poll_remove_entry io_uring/poll.c:154 [inline]
RIP: 0010:io_poll_remove_entries+0x171/0x5b4 io_uring/poll.c:190
Code: ...
RSP: 0018:ffff88810dfefba0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc900030c4000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000008 R08: ffffffff9764d3dd R09: fffffbfff3836781
R10: fffffbfff3836781 R11: 0000000000000000 R12: 1ffff11003422d60
R13: ffff88801a116b04 R14: ffff88801a116ac0 R15: dffffc0000000000
FS:  00007f9c07497700(0000) GS:ffff88811a600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffb5c00ea98 CR3: 0000000105680005 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 io_apoll_task_func+0x3f/0xa0 io_uring/poll.c:299
 handle_tw_list io_uring/io_uring.c:1037 [inline]
 tctx_task_work+0x37e/0x4f0 io_uring/io_uring.c:1090
 task_work_run+0x13a/0x1b0 kernel/task_work.c:177
 get_signal+0x2402/0x25a0 kernel/signal.c:2635
 arch_do_signal_or_restart+0x3b/0x660 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0xc2/0x160 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x58/0x160 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The root cause for this is a tiny overlooking in
io_poll_check_events() when cocurrently run with poll cancel routine
io_poll_cancel_req().

The interleaving to trigger use-after-free:

CPU0                                       |  CPU1
                                           |
io_apoll_task_func()                       |  io_poll_cancel_req()
 io_poll_check_events()                    |
  // do while first loop                   |
  v = atomic_read(...)                     |
  // v = poll_refs = 1                     |
  ...                                      |  io_poll_mark_cancelled()
                                           |   atomic_or()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |
  atomic_sub_return(...)                   |
  // poll_refs = IO_POLL_CANCEL_FLAG       |
  // loop continue                         |
                                           |
                                           |  io_poll_execute()
                                           |   io_poll_get_ownership()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |   // gets the ownership
  v = atomic_read(...)                     |
  // poll_refs not change                  |
                                           |
  if (v & IO_POLL_CANCEL_FLAG)             |
   return -ECANCELED;                      |
  // io_poll_check_events return           |
  // will go into                          |
  // io_req_complete_failed() free req     |
                                           |
                                           |  io_apoll_task_func()
                                           |  // also go into
io_req_complete_failed()

And the interleaving to trigger the kernel WARNING:

CPU0                                       |  CPU1
                                           |
io_apoll_task_func()                       |  io_poll_cancel_req()
 io_poll_check_events()                    |
  // do while first loop                   |
  v = atomic_read(...)                     |
  // v = poll_refs = 1                     |
  ...                                      |  io_poll_mark_cancelled()
                                           |   atomic_or()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |
  atomic_sub_return(...)                   |
  // poll_refs = IO_POLL_CANCEL_FLAG       |
  // loop continue                         |
                                           |
  v = atomic_read(...)                     |
  // v = IO_POLL_CANCEL_FLAG               |
                                           |  io_poll_execute()
                                           |   io_poll_get_ownership()
                                           |   // poll_refs =
IO_POLL_CANCEL_FLAG | 1
                                           |   // gets the ownership
                                           |
  WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))   |
  // v & IO_POLL_REF_MASK = 0 WARN         |
                                           |
                                           |  io_apoll_task_func()
                                           |  // also go into
io_req_complete_failed()

By looking up the source code and communicating with Pavel, the
implementation of this atomic poll refs should continue the loop of
io_poll_check_events() just to avoid somewhere else to grab the
ownership. Therefore, this patch simply adds another AND operation to
make sure the loop will stop if it finds the poll_refs is exactly equal
to IO_POLL_CANCEL_FLAG. Since io_poll_cancel_req() grabs ownership and
will finally make its way to io_req_complete_failed(), the req will
be reclaimed as expected.

Fixes: aa43477b0402 ("io_uring: poll rework")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: tweak description and code style]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..0d721f8c4bc4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -274,7 +274,8 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
+					IO_POLL_REF_MASK);
 
 	return IOU_POLL_NO_ACTION;
 }
-- 
2.35.1



