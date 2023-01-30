Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8616810D3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbjA3OHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbjA3OHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0663B3FD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE72DB81147
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC67C433EF;
        Mon, 30 Jan 2023 14:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087625;
        bh=c8ZVW4xjWEJnhftBdbzNSiYJSGcA/I0CN+tSqmItAbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGjtYTwp9MBYVYEf5ToIGVBoklw4HUyhtLkJmhBD6ocoaO9/JSk72f1p0JN1c30F0
         OzXrpPwIObEZ/nsch+gcTCL+uHkfi23v91BqyMYwo5CIHFxBIMYcom+W9PoxwTbcvX
         UCfmp/g1qWgB3QQF+iFPnQhd74iMHcfsF37dk6s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/313] io_uring: inline __io_req_complete_post()
Date:   Mon, 30 Jan 2023 14:51:16 +0100
Message-Id: <20230130134347.913633952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit f9d567c75ec216447f36da6e855500023504fa04 ]

There is only one user of __io_req_complete_post(), inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ef4c9059950a3da5cf68df00f977f1fd13bd9306.1668597569.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 11 +++--------
 io_uring/io_uring.h |  1 -
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b4f9707730b8..9b1c917c99d9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -854,19 +854,14 @@ static void __io_req_complete_put(struct io_kiocb *req)
 	}
 }
 
-void __io_req_complete_post(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req->ctx, req);
-	__io_req_complete_put(req);
-}
-
 void io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_cq_lock(ctx);
-	__io_req_complete_post(req);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(ctx, req);
+	__io_req_complete_put(req);
 	io_cq_unlock_post(ctx);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 56ecc1550476..0cf544ba6656 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -33,7 +33,6 @@ int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
-void __io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
 		     bool allow_overflow);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
-- 
2.39.0



