Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8270C4FCAA6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiDLAyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244296AbiDLAyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:54:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AFF31DF5;
        Mon, 11 Apr 2022 17:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21544B819A7;
        Tue, 12 Apr 2022 00:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A09DC385A3;
        Tue, 12 Apr 2022 00:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724536;
        bh=IzWB9zuOtlx0ap+FM2xveq4TF2ZOm0iCy1ubW0oMJsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWgVuuR7WXOOCsLe6waJu0j1gY9pq34gkbErRrcVR0tzAPljO9a747kXQ3Bd2Miqc
         gxEzuGymBF6b4WQITs/1aNkFygwynEkvTjgaeiVSDjAQzuMv7cpllkWzdkEVFZWaTW
         tfcn67f4EboTV+eCiFYY6esuKiR+dQ87jZGlh511cFxew5A1aGtHhBwYAu1wWwAhHl
         6HImdvnA1eSZgj5RVr361v5x3uhmg8gLlOkOvG9lO+lQLC3Ko+ZJjLpefUHl5cDcZm
         8r+ydqqfe2KUjXGLayZ4k3PtgDSOsyl9Lx/ouWxn3T69NVBq4JU2zNuXA5QYUFNojx
         WpbE+u9zdaXeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 39/41] io_uring: use nospec annotation for more indexes
Date:   Mon, 11 Apr 2022 20:46:51 -0400
Message-Id: <20220412004656.350101-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 4cdd158be9d09223737df83136a1fb65269d809a ]

There are still several places that using pre array_index_nospec()
indexes, fix them up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b01ef5ee83f72ed35ad525912370b729f5d145f4.1649336342.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d49d83a99c9f..d0daa726b624 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8495,7 +8495,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_fixed_file *file_slot;
 	struct file *file;
-	int ret, i;
+	int ret;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = -ENXIO;
@@ -8508,8 +8508,8 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		goto out;
 
-	i = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
 	ret = -EBADF;
 	if (!file_slot->file_ptr)
 		goto out;
@@ -8565,8 +8565,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -9235,7 +9234,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, offset,
+			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
-- 
2.35.1

