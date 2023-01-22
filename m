Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3728676F21
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjAVPSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjAVPSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:18:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972D58A70
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:18:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38179B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD7C433EF;
        Sun, 22 Jan 2023 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400678;
        bh=PXwRsd3OduKL48CriyI8E7kOgOEg6V6PkEYCjrWSADY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7gslqa2tGa3Sh98Ao3Z8QyxHdAATG+Lti7L/xYlE9PtRQNB3tOm6esJwLgWscRn5
         JqUXJQ6KYnmMsQNlI5fA/jn47sWjJQx/adQLBRQbtsYsfoPpOROyoPLhmVxjsY7vaQ
         Dw4+RiNzbfoyk60BNslnUZz2P57VwBx0Di94+G8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/117] io_uring: remove duplicated calls to io_kiocb_ppos
Date:   Sun, 22 Jan 2023 16:03:48 +0100
Message-Id: <20230122150234.318679518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

commit af9c45ecebaf1b428306f41421f4bcffe439f735 upstream.

io_kiocb_ppos is called in both branches, and it seems that the compiler
does not fuse this. Fusing removes a few bytes from loop_rw_iter.

Before:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 0000000000000124 t loop_rw_iter

After:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 000000000000010d t loop_rw_iter

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2caef6417260..14297add8485 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3303,6 +3303,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct file *file = req->file;
 	ssize_t ret = 0;
+	loff_t *ppos;
 
 	/*
 	 * Don't support polled IO through this interface, and we can't
@@ -3314,6 +3315,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	ppos = io_kiocb_ppos(kiocb);
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3327,10 +3330,10 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, io_kiocb_ppos(kiocb));
+					      iovec.iov_len, ppos);
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, io_kiocb_ppos(kiocb));
+					       iovec.iov_len, ppos);
 		}
 
 		if (nr < 0) {
-- 
2.39.0



