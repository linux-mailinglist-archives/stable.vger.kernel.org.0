Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340C2632192
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiKUMG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiKUMGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:06:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238A51EC6E
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:06:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38926113C
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA54DC433C1;
        Mon, 21 Nov 2022 12:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032414;
        bh=p2goEZw2fN6qPhCAS5w+uPdCaLao3Vc8HE6JQ9YehJk=;
        h=Subject:To:Cc:From:Date:From;
        b=2pQJTDzPKnLoSqnZ9lI93Eglm/9pdp26JDTpkOAGd8kKdgVOFUpDrKlcuVmvGEn10
         IeRF8SqaXJhd4D8N4BinDE4taSlZXRa0hgLtzNo1yqRI2hsuC5HbZ9Ixd4G3yRrsJn
         kTLLSrPCflyqw12MH25SJAwR0aD6gUOLroz/D3pg=
Subject: FAILED: patch "[PATCH] io_uring: fix tw losing poll events" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 13:04:06 +0100
Message-ID: <1669032246212254@kroah.com>
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

539bcb57da2f ("io_uring: fix tw losing poll events")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
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
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")
453b329be5ea ("io_uring: separate out file table handling code")
f4c163dd7d4b ("io_uring: split out fadvise/madvise operations")
0d5847274037 ("io_uring: split out fs related sync/fallocate functions")
531113bbd5bf ("io_uring: split out splice related operations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 539bcb57da2f58886d7d5c17134236b0ec9cd15d Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 17 Nov 2022 18:40:15 +0000
Subject: [PATCH] io_uring: fix tw losing poll events

We may never try to process a poll wake and its mask if there was
multiple wake ups racing for queueing up a tw. Force
io_poll_check_events() to update the mask by vfs_poll().

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/00344d60f8b18907171178d7cf598de71d127b0b.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 90920abf91ff..c34019b18211 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -228,6 +228,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 			return IOU_POLL_DONE;
 		if (v & IO_POLL_CANCEL_FLAG)
 			return -ECANCELED;
+		/*
+		 * cqe.res contains only events of the first wake up
+		 * and all others are be lost. Redo vfs_poll() to get
+		 * up to date state.
+		 */
+		if ((v & IO_POLL_REF_MASK) != 1)
+			req->cqe.res = 0;
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {

