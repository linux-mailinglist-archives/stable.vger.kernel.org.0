Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88D06DEF9A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjDLIwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjDLIwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB17593D7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC49463197
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD286C433EF;
        Wed, 12 Apr 2023 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289522;
        bh=eVeOYfFUZgYqjrBqTpVJacTwLpzHvUKZU36EBWEYO+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XaXN8+ZuOJ8/dOmSwcp7229H+Dx2ozC4hoYGioDncvU576nm9yqyXQQgSF+jVX+Ti
         UURwX82nYo8ELLOCEj0sjSipRgHCC6ytGvp2llX9l9HXPoKX4K836amObdh0Qquj1/
         iRBbkFTnqhY3aaPRI9DzOfdwyK5Hnplwmn+8fiXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wojciech Lukowicz <wlukowicz01@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 132/173] io_uring: fix memory leak when removing provided buffers
Date:   Wed, 12 Apr 2023 10:34:18 +0200
Message-Id: <20230412082843.479732757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wojciech Lukowicz <wlukowicz01@gmail.com>

[ Upstream commit b4a72c0589fdea6259720375426179888969d6a2 ]

When removing provided buffers, io_buffer structs are not being disposed
of, leading to a memory leak. They can't be freed individually, because
they are allocated in page-sized groups. They need to be added to some
free list instead, such as io_buffers_cache. All callers already hold
the lock protecting it, apart from when destroying buffers, so had to
extend the lock there.

Fixes: cc3cec8367cb ("io_uring: speedup provided buffer handling")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
Link: https://lore.kernel.org/r/20230401195039.404909-2-wlukowicz01@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.c     | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a4e9dbc7b67a8..add5cff7952c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2722,8 +2722,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
-	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
 	if (ctx->submitter_task)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 0fdcc0adbdbcc..a90c820ce99e1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,11 +228,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
+	/* protects io_buffers_cache */
+	lockdep_assert_held(&ctx->uring_lock);
+
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_del(&nxt->list);
+		list_move(&nxt->list, &ctx->io_buffers_cache);
 		if (++i == nbufs)
 			return i;
 		cond_resched();
-- 
2.39.2



