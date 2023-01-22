Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128F7676E96
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjAVPMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjAVPMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66320060
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C2CB80B0E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719B0C433D2;
        Sun, 22 Jan 2023 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400324;
        bh=BFvU+Y+GhSRBBqrSsPuAGqrNZ0IA8GjdbOXu4thJeyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDCoI7ABVmFXVAXBEqVPYkGe/r5AGxR6ugB+/ajVwLTIgun6P6rLqjHwwV0PeR5C3
         xcNN+jQHW2nEjuXovh7Xa+v2YWRCEjN4BTkF7Hs9HQiTOgzkbT710o+lxxicDVDi9q
         72a7opN0jLr+InkFBoQFJS5CR2P9c1nGCmNTpRuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/98] io_uring: update kiocb->ki_pos at execution time
Date:   Sun, 22 Jan 2023 16:03:48 +0100
Message-Id: <20230122150230.842319602@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dylan Yudaken <dylany@fb.com>

commit d34e1e5b396a0dbaa4a29b7138df662cfb9d8e8e upstream.

Update kiocb->ki_pos at execution time rather than in io_prep_rw().
io_prep_rw() happens before the job is enqueued to a worker and so the
offset might be read multiple times before being executed once.

Ensures that the file position in a set of _linked_ SQEs will be only
obtained after earlier SQEs have completed, and so will include their
incremented file position.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d8926475cd88..eaf8463c9b14 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2919,14 +2919,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
-			kiocb->ki_pos = 0;
-		}
-	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
@@ -3008,6 +3000,20 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
+static inline void io_kiocb_update_pos(struct io_kiocb *req)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+
+	if (kiocb->ki_pos == -1) {
+		if (!(req->file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = req->file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
+	}
+}
+
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       unsigned int issue_flags)
 {
@@ -3563,6 +3569,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
+	io_kiocb_update_pos(req);
+
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
@@ -3697,6 +3705,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
+	io_kiocb_update_pos(req);
+
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret))
 		goto out_free;
-- 
2.39.0



