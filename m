Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BED676D12
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjAVNNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:13:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3571631B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A42B60C16
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C07C433D2;
        Sun, 22 Jan 2023 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674393191;
        bh=/G2DY31SK3Gx+ZQ93ZqpRF8+H69JDF2iLu6bbU5RGxc=;
        h=Subject:To:Cc:From:Date:From;
        b=Cj3mm4Ahu6q011DGo5Z/GX6UeACxewBnoUifhlpBbX/fAfW8mEQHBfllJtVOjkRUD
         MYmlIhhnEp77c0DgN7i5D/47XZ6NM9alWfmFl50jP8vpJbFgm5DWtg2drkFdKA1G13
         MUH3Dz8gWNWZXPao7w8nOlPCaWTUojBLWuhnUYcw=
Subject: FAILED: patch "[PATCH] io_uring/msg_ring: fix flagging remote execution" failed to apply to 6.1-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:13:08 +0100
Message-ID: <16743931882234@kroah.com>
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

From 56d8e3180c065c9b78ed77afcd0cf99677a4e22f Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 20 Jan 2023 16:38:05 +0000
Subject: [PATCH] io_uring/msg_ring: fix flagging remote execution

There is a couple of problems with queueing a tw in io_msg_ring_data()
for remote execution. First, once we queue it the target ring can
go away and so setting IORING_SQ_TASKRUN there is not safe. Secondly,
the userspace might not expect IORING_SQ_TASKRUN.

Extract a helper and uniformly use TWA_SIGNAL without TWA_SIGNAL_NO_IPI
tricks for now, just as it was done in the original patch.

Cc: stable@vger.kernel.org
Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index a333781565d3..bb868447dcdf 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -58,6 +58,25 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 	msg->src_file = NULL;
 }
 
+static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
+{
+	if (!target_ctx->task_complete)
+		return false;
+	return current != target_ctx->submitter_task;
+}
+
+static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
+{
+	struct io_ring_ctx *ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	init_task_work(&msg->tw, func);
+	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
+		return -EOWNERDEAD;
+
+	return IOU_ISSUE_SKIP_COMPLETE;
+}
+
 static void io_msg_tw_complete(struct callback_head *head)
 {
 	struct io_msg *msg = container_of(head, struct io_msg, tw);
@@ -96,15 +115,8 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 
-	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
-		init_task_work(&msg->tw, io_msg_tw_complete);
-		if (task_work_add(target_ctx->submitter_task, &msg->tw,
-				  TWA_SIGNAL_NO_IPI))
-			return -EOWNERDEAD;
-
-		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
-		return IOU_ISSUE_SKIP_COMPLETE;
-	}
+	if (io_msg_need_remote(target_ctx))
+		return io_msg_exec_remote(req, io_msg_tw_complete);
 
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
@@ -202,14 +214,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
-		init_task_work(&msg->tw, io_msg_tw_fd_complete);
-		if (task_work_add(target_ctx->submitter_task, &msg->tw,
-				  TWA_SIGNAL))
-			return -EOWNERDEAD;
-
-		return IOU_ISSUE_SKIP_COMPLETE;
-	}
+	if (io_msg_need_remote(target_ctx))
+		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
 	return io_msg_install_complete(req, issue_flags);
 }
 

