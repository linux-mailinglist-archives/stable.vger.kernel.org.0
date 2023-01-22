Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF04F676D13
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjAVNNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:13:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A9D1631B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2BA9B80AC6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C74C433D2;
        Sun, 22 Jan 2023 13:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393198;
        bh=ofsqczqMh/6J4r+bL+yxwIdPzqxtIBXMDPOCRDh5YxE=;
        h=Subject:To:Cc:From:Date:From;
        b=Zykkv6ZeOzBt2srPwyYklo3OFdAC7y1/goV/oGB/ZZHAoRZTo+P9bB8sl5eT+Mwx8
         gSuBDbo8a3whkeL+ahn6UYfykGv2xsEAqmFFsP8BxZ89lxaqb8Dex1ZTaHyY4A+blf
         uPw1PiDsDNDEa3lKxjBweqdEvgZt0Q/ZUlWRlFUo=
Subject: FAILED: patch "[PATCH] io_uring/msg_ring: fix remote queue to disabled ring" failed to apply to 6.1-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:13:16 +0100
Message-ID: <167439319620546@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8579538c89e3 ("io_uring/msg_ring: fix remote queue to disabled ring")
56d8e3180c06 ("io_uring/msg_ring: fix flagging remote execution")
423d5081d045 ("io_uring/msg_ring: move double lock/unlock helpers higher up")
761c61c15903 ("io_uring/msg_ring: flag target ring as having task_work, if needed")
6d043ee1164c ("io_uring: do msg_ring in target task via tw")
172113101641 ("io_uring: extract a io_msg_install_complete helper")
11373026f296 ("io_uring: get rid of double locking")
4c979eaefa43 ("io_uring: improve io_double_lock_ctx fail handling")
b529c96a896b ("io_uring: remove overflow param from io_post_aux_cqe")
a77ab745f28d ("io_uring: make io_fill_cqe_aux static")
9b8c54755a2b ("io_uring: add io_aux_cqe which allows deferred completion")
931147ddfa6e ("io_uring: allow defer completion for aux posted cqes")
1bec951c3809 ("io_uring: iopoll protect complete_post")
fa18fa2272c7 ("io_uring: inline __io_req_complete_put()")
f9d567c75ec2 ("io_uring: inline __io_req_complete_post()")
e2ad599d1ed3 ("io_uring: allow multishot recv CQEs to overflow")
515e26961295 ("io_uring: revert "io_uring fix multishot accept ordering"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8579538c89e33ce78be2feb41e07489c8cbf8f31 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 20 Jan 2023 16:38:06 +0000
Subject: [PATCH] io_uring/msg_ring: fix remote queue to disabled ring

IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
it's not always safe to use ->submitter_task. Disallow posting msg_ring
messaged to disabled rings. Also add task NULL check for loosy sync
around testing for IORING_SETUP_R_DISABLED.

Cc: stable@vger.kernel.org
Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..0a4efada9b3c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3674,7 +3674,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
 	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
@@ -3868,7 +3868,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 		return -EBADFD;
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task)
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bb868447dcdf..15602a136821 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -69,6 +69,10 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+
+	if (unlikely(!task))
+		return -EOWNERDEAD;
 
 	init_task_work(&msg->tw, func);
 	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
@@ -114,6 +118,8 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_exec_remote(req, io_msg_tw_complete);
@@ -206,6 +212,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (target_ctx == ctx)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 	if (!src_file) {
 		src_file = io_msg_grab_file(req, issue_flags);
 		if (!src_file)

