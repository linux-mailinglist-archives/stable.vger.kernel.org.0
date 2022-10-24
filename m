Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5982060AD03
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiJXORS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiJXOP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD35F2AC67;
        Mon, 24 Oct 2022 05:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85195612E6;
        Mon, 24 Oct 2022 12:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923C1C433C1;
        Mon, 24 Oct 2022 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616132;
        bh=7amcw60WT4FfsU+UZhY0SmndoGQTOG4dNSqmVeJCEuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByYhLL0flCkrgu+Lrv6ZfgC9TDKBSdLQPDgEqB+wrDeUIFFI6R8jWeiaJy6xB/4La
         8w4kjlFJJaYOzbmBs/BK2j0vryY2o8rm4EXQPzpN/R7JaEoCIxL+xHOrpGVKivQeEd
         G4H2QEmoWeYTobo00QF5P+Hc5aH0PBH+OJPlUYVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15 513/530] io_uring/rw: fix short rw error handling
Date:   Mon, 24 Oct 2022 13:34:17 +0200
Message-Id: <20221024113108.241023895@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 89473c1a9205760c4fa6d158058da7b594a815f0 ]

We have a couple of problems, first reports of unexpected link breakage
for reads when cqe->res indicates that the IO was done in full. The
reason here is partial IO with retries.

TL;DR; we compare the result in __io_complete_rw_common() against
req->cqe.res, but req->cqe.res doesn't store the full length but rather
the length left to be done. So, when we pass the full corrected result
via kiocb_done() -> __io_complete_rw_common(), it fails.

The second problem is that we don't try to correct res in
io_complete_rw(), which, for instance, might be a problem for O_DIRECT
but when a prefix of data was cached in the page cache. We also
definitely don't want to pass a corrected result into io_rw_done().

The fix here is to leave __io_complete_rw_common() alone, always pass
not corrected result into it and fix it up as the last step just before
actually finishing the I/O.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2701,6 +2701,20 @@ static bool __io_complete_rw_common(stru
 	return false;
 }
 
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (io && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
@@ -2724,7 +2738,7 @@ static void __io_complete_rw(struct io_k
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, issue_flags, req->result, io_put_rw_kbuf(req));
+	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
@@ -2733,7 +2747,7 @@ static void io_complete_rw(struct kiocb
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	req->result = res;
+	req->result = io_fixup_rw_res(req, res);
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -2979,15 +2993,6 @@ static void kiocb_done(struct kiocb *kio
 		       unsigned int issue_flags)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-	struct io_async_rw *io = req->async_data;
-
-	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
-		if (ret < 0)
-			ret = io->bytes_done;
-		else
-			ret += io->bytes_done;
-	}
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
@@ -3004,6 +3009,7 @@ static void kiocb_done(struct kiocb *kio
 			unsigned int cflags = io_put_rw_kbuf(req);
 			struct io_ring_ctx *ctx = req->ctx;
 
+			ret = io_fixup_rw_res(req, ret);
 			req_set_fail(req);
 			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
 				mutex_lock(&ctx->uring_lock);


