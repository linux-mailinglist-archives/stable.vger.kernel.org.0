Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D63676DC4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjAVOpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAVOpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:45:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158171BAF5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:45:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E7D60C17
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B89C433D2;
        Sun, 22 Jan 2023 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398716;
        bh=uFESqiKK442ox5Ddi3xPevNPaBlhCguuPvniAfJVHfc=;
        h=Subject:To:Cc:From:Date:From;
        b=PusvoQOhMoLho4Q1aEr0+wsXeV6EqeuEHb37EkytMnu1V5noT4Scl1MR219vzbrYd
         Imd3LIG21uVVHH4TgMyzt57attRBDp9bO4HKQr296fmlGwuH36DOaY/2RHw3ZPcvKX
         yJuPTTn70CtNjjfW+9LHiqsmeNyYdYv0LiL31AT8=
Subject: FAILED: patch "[PATCH] io_uring: fix double poll leak on repolling" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 15:45:05 +0100
Message-ID: <1674398705141140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

c0737fa9a5a5 ("io_uring: fix double poll leak on repolling")
10c873334feb ("io_uring: allow re-poll if we made progress")
52dd86406dfa ("io_uring: enable EPOLLEXCLUSIVE for accept poll")
4d9237e32c5d ("io_uring: recycle apoll_poll entries")
cc3cec8367cb ("io_uring: speedup provided buffer handling")
d5ec1dfaf59b ("io-uring: add __fill_cqe function")
77bc59b49817 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
0d7c1153d929 ("io_uring: Clean up a false-positive warning from GCC 9.3.0")
42a7b4ed45e7 ("Merge tag 'for-5.17/io_uring-2022-01-11' of git://git.kernel.dk/linux-block")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c0737fa9a5a5cf5a053bcc983f72d58919b997c6 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 22 Jun 2022 00:00:37 +0100
Subject: [PATCH] io_uring: fix double poll leak on repolling

We have re-polling for partial IO, so a request can be polled twice. If
it used two poll entries the first time then on the second
io_arm_poll_handler() it will find the old apoll entry and NULL
kmalloc()'ed second entry, i.e. apoll->double_poll, so leaking it.

Fixes: 10c873334feba ("io_uring: allow re-poll if we made progress")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/fee2452494222ecc7f1f88c8fb659baef971414a.1655852245.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cb719a53b8bd..5c95755619e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7208,6 +7208,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		mask |= EPOLLEXCLUSIVE;
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
+		kfree(apoll->double_poll);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 		   !list_empty(&ctx->apoll_cache)) {
 		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,

