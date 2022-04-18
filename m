Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED345052A0
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiDRMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240428AbiDRMtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:49:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11B22B1BD;
        Mon, 18 Apr 2022 05:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57995B80ED6;
        Mon, 18 Apr 2022 12:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6A8C385A7;
        Mon, 18 Apr 2022 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285224;
        bh=g8Q2+7CHiKjILami8t6hn7pMcUNJyhDrXAmITMxT9QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1HXsKbKnAHlq26JRJZDOUgjpyH2y3El7GkHPTOvtmMr4yynzNy9b2zOS8qxtvNUW
         Slev7VFn2PLet6Xd19pPViyZ6HfFpbMhFjdXDLN5ufm/9Gh5DT3cTjJj8qd4UxW2QF
         wY8y+OjesHUu2jIw+4bIMlb+v7mEVJCaIU6B4ZHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/189] io_uring: use nospec annotation for more indexes
Date:   Mon, 18 Apr 2022 14:12:42 +0200
Message-Id: <20220418121205.588146582@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ca207e9a87cd..1bf1ea2cd8b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8489,7 +8489,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_fixed_file *file_slot;
 	struct file *file;
-	int ret, i;
+	int ret;
 
 	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	ret = -ENXIO;
@@ -8502,8 +8502,8 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		goto out;
 
-	i = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	offset = array_index_nospec(offset, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
 	ret = -EBADF;
 	if (!file_slot->file_ptr)
 		goto out;
@@ -8559,8 +8559,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (file_slot->file_ptr) {
 			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
-			err = io_queue_rsrc_removal(data, up->offset + done,
-						    ctx->rsrc_node, file);
+			err = io_queue_rsrc_removal(data, i, ctx->rsrc_node, file);
 			if (err)
 				break;
 			file_slot->file_ptr = 0;
@@ -9229,7 +9228,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
 		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, offset,
+			err = io_queue_rsrc_removal(ctx->buf_data, i,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
 				io_buffer_unmap(ctx, &imu);
-- 
2.35.1



