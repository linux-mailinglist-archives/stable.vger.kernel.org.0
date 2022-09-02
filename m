Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3815F5AB0EA
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiIBNAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiIBM72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D199E1A89;
        Fri,  2 Sep 2022 05:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0449CB82A9D;
        Fri,  2 Sep 2022 12:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550E6C433D6;
        Fri,  2 Sep 2022 12:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121860;
        bh=YFas5/i9fM9TSKFuzmOHtIl6G+dYm71RgkTU9lguU0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW7Pm7O62++f/A3j87DFX6i/bQRJh3jpgtVTyq0ntdm9ZQ6TCvVxhl1ZSWdjV+HzJ
         spVowec1eoFRCuH6JVa/ziFMsKWyqiSlSg3jf5v9gUImYtbCutfcUHHfjQPnGZQstm
         rJh0xjp9gxyIRzCEaVgNdxt6O0E4l/77HHMocLks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 11/73] io_uring: correct fill events helpers types
Date:   Fri,  2 Sep 2022 14:18:35 +0200
Message-Id: <20220902121404.806308311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 54daa9b2d80ab35824464b35a99f716e1cdf2ccb ]

CQE result is a 32-bit integer, so the functions generating CQEs are
better to accept not long but ints. Convert io_cqring_fill_event() and
other helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7ca6f15255e9117eae28adcac272744cae29b113.1633373302.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1080,7 +1080,7 @@ static void io_uring_try_cancel_requests
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+				 s32 res, u32 cflags);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1763,7 +1763,7 @@ static __cold void io_uring_drop_tctx_re
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     long res, unsigned int cflags)
+				     s32 res, u32 cflags)
 {
 	struct io_overflow_cqe *ocqe;
 
@@ -1791,7 +1791,7 @@ static bool io_cqring_event_overflow(str
 }
 
 static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1814,13 +1814,13 @@ static inline bool __io_cqring_fill_even
 
 /* not as hot to bloat with inlining */
 static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1861,8 +1861,8 @@ static inline bool io_req_needs_clean(st
 	return req->flags & IO_REQ_CLEAN_FLAGS;
 }
 
-static void io_req_complete_state(struct io_kiocb *req, long res,
-				  unsigned int cflags)
+static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
+					 u32 cflags)
 {
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
@@ -1872,7 +1872,7 @@ static void io_req_complete_state(struct
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
-				     long res, unsigned cflags)
+				     s32 res, u32 cflags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 		io_req_complete_state(req, res, cflags);
@@ -1880,12 +1880,12 @@ static inline void __io_req_complete(str
 		io_req_complete_post(req, res, cflags);
 }
 
-static inline void io_req_complete(struct io_kiocb *req, long res)
+static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	__io_req_complete(req, 0, res, 0);
 }
 
-static void io_req_complete_failed(struct io_kiocb *req, long res)
+static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
 	io_req_complete_post(req, res, 0);
@@ -2707,7 +2707,7 @@ static bool __io_complete_rw_common(stru
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
-	long res = req->result;
+	int res = req->result;
 
 	if (*locked) {
 		struct io_ring_ctx *ctx = req->ctx;


