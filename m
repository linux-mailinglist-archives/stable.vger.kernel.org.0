Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A65FFDD7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJPH0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJPH0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:26:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025103ED51
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9336B60AAD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A48C433D6;
        Sun, 16 Oct 2022 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665905168;
        bh=zGUOQGzIRqK6m0wpD8E4y25hieYSv68F44ejD1QKTwA=;
        h=Subject:To:Cc:From:Date:From;
        b=nSQl0oPd749avWYMCBusVcFPTbt7QsGi0OwFc7rkyGscj1yDYJmlmWY89jJI0QEes
         yZP8QJtzJxpR1G3fn90p0DXzdNAjXdI2PsyUjaaeT53AEKHvE1KsZBd8L0zMTO7kft
         87kW4QzpyEEUt4ifyqeatwbJNzwslx2OQ7Rc2gE4=
Subject: FAILED: patch "[PATCH] io_uring/rw: fix unexpected link breakage" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, beldzhang@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:26:46 +0200
Message-ID: <16659052064246@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

bf68b5b34311 ("io_uring/rw: fix unexpected link breakage")
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
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bf68b5b34311ee57ed40749a1257a30b46127556 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 27 Sep 2022 00:44:39 +0100
Subject: [PATCH] io_uring/rw: fix unexpected link breakage

req->cqe.res is set in io_read() to the amount of bytes left to be done,
which is used to figure out whether to fail a read or not. However,
io_read() may do another without returning, and we stash the previous
value into ->bytes_done but forget to update cqe.res. Then we ask a read
to do strictly less than cqe.res but expect the return to be exactly
cqe.res.

Fix the bug by updating cqe.res for retries.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3a1088440c7be98e5800267af922a67da0ef9f13.1664235732.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 59c92a4616b8..ed14322aadb9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -793,6 +793,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
+		req->cqe.res = iov_iter_count(&s->iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the

