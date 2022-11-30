Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEE963DFE4
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiK3Svk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiK3SvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20369D83A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D2E861D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5A5C433D7;
        Wed, 30 Nov 2022 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834280;
        bh=f469Eyl9iTgGdzilUrmfkK6gyjtcEXnM/7qfFyjJtCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2LGn5QEBXoUzTtqtAGj8mfpGy1SG5Ycscw+IiT3gwJ0oC5EED9p+xFYpg2cJJgzN
         Q73QxZ3dsEReLrRKarJ6Yqk3/UKJVSQgE3+QlGX39wj2+f70by9DORwF3LYrsZDHVi
         CdFT/nNUsUxuU7HXGwxTj98eiVcgiYFD59ymo2DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 195/289] io_uring: cmpxchg for poll arm refs release
Date:   Wed, 30 Nov 2022 19:23:00 +0100
Message-Id: <20221130180548.542665171@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 2f3893437a4ebf2e892ca172e9e122841319d675 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -519,7 +519,6 @@ static int __io_arm_poll_handler(struct
 				 unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
@@ -587,11 +586,10 @@ static int __io_arm_poll_handler(struct
 
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


