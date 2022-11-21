Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC806320B3
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiKULds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiKULdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:33:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241E2DEE2
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:29:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8AABCCE1273
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49956C433D6;
        Mon, 21 Nov 2022 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669030141;
        bh=52FQh+H7OMQyfl4Zza8yejU+Y+mMw4Edprmr3Z03WGU=;
        h=Subject:To:Cc:From:Date:From;
        b=yUOswH74iK09gGr4Dqjg+7bbiVIIsJye+eTh9RJAOmd/30mgk2W1MJAnQoUj++she
         hr49Etn5Qf9uwELc/FcuKc/Hhv/mwxDfnX6e03AVYDbChGL7tm//62Iz4p7gXGrgBC
         toZ4vTn/Oopx608JqWifkpSqpqRFx/VfUKFDY1PA=
Subject: FAILED: patch "[PATCH] io_uring: update res mask in io_poll_check_events" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:28:58 +0100
Message-ID: <16690301389785@kroah.com>
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

b98186aee22f ("io_uring: update res mask in io_poll_check_events")
d245bca6375b ("io_uring: don't expose io_fill_cqe_aux()")
f3b44f92e59a ("io_uring: move read/write related opcodes to its own file")
c98817e6cd44 ("io_uring: move remaining file table manipulation to filetable.c")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
92ac8beaea1f ("io_uring: include and forward-declaration sanitation")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")
17437f311490 ("io_uring: move SQPOLL related handling into its own file")
59915143e89f ("io_uring: move timeout opcodes and handling into its own file")
e418bbc97bff ("io_uring: move our reference counting into a header")
36404b09aa60 ("io_uring: move msg_ring into its own file")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b98186aee22fa593bc8c6b2c5d839c2ee518bc8c Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 17 Nov 2022 18:40:14 +0000
Subject: [PATCH] io_uring: update res mask in io_poll_check_events

When io_poll_check_events() collides with someone attempting to queue a
task work, it'll spin for one more time. However, it'll continue to use
the mask from the first iteration instead of updating it. For example,
if the first wake up was a EPOLLIN and the second EPOLLOUT, the
userspace will not get EPOLLOUT in time.

Clear the mask for all subsequent iterations to force vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2dac97e8f691231049cb259c4ae57e79e40b537c.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index f500506984ec..90920abf91ff 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -258,6 +258,9 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return ret;
 		}
 
+		/* force the next iteration to vfs_poll() */
+		req->cqe.res = 0;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.

