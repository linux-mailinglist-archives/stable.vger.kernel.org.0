Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD4F6433D2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiLETj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiLETj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0D7101EC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2CA612C5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA1EC433D7;
        Mon,  5 Dec 2022 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269001;
        bh=f3m9sWW8su0LLcneKWL7CjsOFCIWHi43c0szgiAqwSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TK9tR3L9nPb5h3eJFUzzAuTdSHa4FxZHNdRPUbSjdaJs0+vaR9VRM2mswnSVuMn5G
         2U6eYVllGBgdHd/90iop1SiXNJsl6hp8Oqqi+De12/XH5K5A5CHbCDmA/9w5aE9wYL
         8KP0NdWFBeEUD8MNXiwFOeELP9Ti4m1OpKoovhWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 090/120] io_uring: cmpxchg for poll arm refs release
Date:   Mon,  5 Dec 2022 20:10:30 +0100
Message-Id: <20221205190809.282885771@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ upstream commit 2f3893437a4ebf2e892ca172e9e122841319d675 ]

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
 fs/io_uring.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5650,7 +5650,6 @@ static int __io_arm_poll_handler(struct
 				 struct io_poll_table *ipt, __poll_t mask)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
@@ -5696,11 +5695,10 @@ static int __io_arm_poll_handler(struct
 	}
 
 	/*
-	 * Release ownership. If someone tried to queue a tw while it was
-	 * locked, kick it off for them.
+	 * Try to release ownership. If we see a change of state, e.g.
+	 * poll was waken up, queue up a tw, it'll deal with it.
 	 */
-	v = atomic_dec_return(&req->poll_refs);
-	if (unlikely(v & IO_POLL_REF_MASK))
+	if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 		__io_poll_execute(req, 0);
 	return 0;
 }


