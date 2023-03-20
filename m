Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630C26C1129
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCTLuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCTLuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:50:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504C817150
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 042F9B80E5C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C62CC433D2;
        Mon, 20 Mar 2023 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679313006;
        bh=npEezdijeMZdMDB3gvXgq1VgcBiOHDn6xhqBk5zhO7U=;
        h=Subject:To:Cc:From:Date:From;
        b=yLeO3SxsScC2M9wD4/7E2GhIx0/yz+1fS5EdlT0mxFBJFi9OnBOYDoNAsQxzUi8vj
         6JvNpMucVeFCF/LMCcdAurLx0wFER/kUswzfnoQzlY7vJwthHuljV8/WgrfHKKdhM6
         Sr7p5Id78CRMTQxCdcSqSj7oDCZSNx7s/4b2HKcQ=
Subject: FAILED: patch "[PATCH] io_uring/msg_ring: let target know allocated index" failed to apply to 6.1-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 12:50:04 +0100
Message-ID: <167931300423217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 5da28edd7bd5518f97175ecea77615bb729a7a28
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167931300423217@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

5da28edd7bd5 ("io_uring/msg_ring: let target know allocated index")
172113101641 ("io_uring: extract a io_msg_install_complete helper")
11373026f296 ("io_uring: get rid of double locking")
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

From 5da28edd7bd5518f97175ecea77615bb729a7a28 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 16 Mar 2023 12:11:42 +0000
Subject: [PATCH] io_uring/msg_ring: let target know allocated index

msg_ring requests transferring files support auto index selection via
IORING_FILE_INDEX_ALLOC, however they don't return the selected index
to the target ring and there is no other good way for the userspace to
know where is the receieved file.

Return the index for allocated slots and 0 otherwise, which is
consistent with other fixed file installing requests.

Cc: stable@vger.kernel.org # v6.0+
Fixes: e6130eba8a848 ("io_uring: add support for passing fixed file descriptors")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/809
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 8803c0979e2a..85fd7ce5f05b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -202,7 +202,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
 		ret = -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(target_ctx);
@@ -229,6 +229,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *src_file = msg->src_file;
 
+	if (msg->len)
+		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)

