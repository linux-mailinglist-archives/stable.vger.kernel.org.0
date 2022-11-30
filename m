Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2F63D559
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiK3MRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiK3MRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:17:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A992B600
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F413B81B30
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F90C433C1;
        Wed, 30 Nov 2022 12:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669810622;
        bh=9ESDACDUaS73Yi0K3BbyMtEzjHFWPNY2mIkc2gEIZ3E=;
        h=Subject:To:Cc:From:Date:From;
        b=x3v8gTbw/Qr7G5aszCxlf27DKWXhq3qkrp328SHB1NpCcyfGsT75QdxWh8RBbvkpp
         wxsDe1WjGzgLO6YygEpb4W88BkDZS6bFX3Sb0Aid/uXHFBZuSuvYo4LZn3Z/9bAucI
         P0mYeB+dpoU2s851LFpnjEwydCaU6T28Yt/VAcJM=
Subject: FAILED: patch "[PATCH] io_uring: cmpxchg for poll arm refs release" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:16:59 +0100
Message-ID: <166981061918834@kroah.com>
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

2f3893437a4e ("io_uring: cmpxchg for poll arm refs release")
49f1c68e048f ("io_uring: optimise submission side poll_refs")
de08356f4858 ("io_uring: refactor poll arm error handling")
063a007996bf ("io_uring: change arm poll return values")
13a99017ff19 ("io_uring: remove events caching atavisms")
0638cd7be212 ("io_uring: clean poll ->private flagging")
48863ffd3e81 ("io_uring: clean up tracing events")
9ca9fb24d5fe ("io_uring: mutex locked poll hashing")
e6f89be61410 ("io_uring: introduce a struct for hash table")
a2cdd5193218 ("io_uring: pass hash table into poll_find")
0ec6dca22319 ("io_uring: use state completion infra for poll reqs")
8b1dfd343ae6 ("io_uring: clean up io_ring_ctx_alloc")
4a07723fb4bb ("io_uring: limit the number of cancellation buckets")
1ab1edb0a104 ("io_uring: pass poll_find lock back")
38513c464d3d ("io_uring: switch cancel_hash to use per entry spinlock")
aff5b2df9e8b ("io_uring: better caching for ctx timeout fields")
b9ba8a4463cd ("io_uring: add support for level triggered poll")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2f3893437a4ebf2e892ca172e9e122841319d675 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 20 Nov 2022 16:57:41 +0000
Subject: [PATCH] io_uring: cmpxchg for poll arm refs release

Replace atomically substracting the ownership reference at the end of
arming a poll with a cmpxchg. We try to release ownership by setting 0
assuming that poll_refs didn't change while we were arming. If it did
change, we keep the ownership and use it to queue a tw, which is fully
capable to process all events and (even tolerates spurious wake ups).

It's a bit more elegant as we reduce races b/w setting the cancellation
flag and getting refs with this release, and with that we don't have to
worry about any kinds of underflows. It's not the fastest path for
polling. The performance difference b/w cmpxchg and atomic dec is
usually negligible and it's not the fastest path.

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 055632e9092a..1b78b527075d 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -518,7 +518,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
@@ -586,11 +585,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (ipt->owning) {
 		/*
-		 * Release ownership. If someone tried to queue a tw while it was
-		 * locked, kick it off for them.
+		 * Try to release ownership. If we see a change of state, e.g.
+		 * poll was waken up, queue up a tw, it'll deal with it.
 		 */
-		v = atomic_dec_return(&req->poll_refs);
-		if (unlikely(v & IO_POLL_REF_MASK))
+		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 			__io_poll_execute(req, 0);
 	}
 	return 0;

