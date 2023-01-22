Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC30B676E97
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjAVPMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjAVPMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F88420079
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B73C60C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB03C433D2;
        Sun, 22 Jan 2023 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400327;
        bh=YrWJgo0YPlaC/qKjEkOZYd8xwQpg9FrVFHm3xrntbKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sfjrdeyrd4jtnj139ZX5oY3suHqXSa7qIRChqioyWA2tZN6ded8W7ZxlYYQpi4WEG
         PS9kyD2gCY4y2ONJ3LGrdLtBbKLP6qWNqO2Mf2LJkuIjZ9mDbH5FbciLlrrx3wbIrO
         vupRhdXP6aAdN+HOph6RxQ67mDjNLmSV++tDFXT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/98] io_uring: do not recalculate ppos unnecessarily
Date:   Sun, 22 Jan 2023 16:03:49 +0100
Message-Id: <20230122150230.889116156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

commit b4aec40015953b65f2f114641e7fd7714c8df8e6 upstream.

There is a slight optimisation to be had by calculating the correct pos
pointer inside io_kiocb_update_pos and then using that later.

It seems code size drops by a bit:
000000000000a1b0 0000000000000400 t io_read
000000000000a5b0 0000000000000319 t io_write

vs
000000000000a1b0 00000000000003f6 t io_read
000000000000a5b0 0000000000000310 t io_write

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eaf8463c9b14..d4e017b07371 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3000,18 +3000,22 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static inline void io_kiocb_update_pos(struct io_kiocb *req)
+static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
+	bool is_stream = req->file->f_mode & FMODE_STREAM;
 
 	if (kiocb->ki_pos == -1) {
-		if (!(req->file->f_mode & FMODE_STREAM)) {
+		if (!is_stream) {
 			req->flags |= REQ_F_CUR_POS;
 			kiocb->ki_pos = req->file->f_pos;
+			return &kiocb->ki_pos;
 		} else {
 			kiocb->ki_pos = 0;
+			return NULL;
 		}
 	}
+	return is_stream ? NULL : &kiocb->ki_pos;
 }
 
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
@@ -3537,6 +3541,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3569,9 +3574,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	io_kiocb_update_pos(req);
+	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+	ret = rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3675,6 +3680,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3705,9 +3711,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	io_kiocb_update_pos(req);
+	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
+	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
 
-- 
2.39.0



