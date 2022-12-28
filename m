Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC4D6576D7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 14:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiL1NMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 08:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiL1NMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 08:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9093D11811
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 05:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FDBC61338
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225D7C433D2;
        Wed, 28 Dec 2022 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672233131;
        bh=SVyYvM4vXu+qhuQCRdK3+JvAYbMjj4dpjJd7W+vjyQA=;
        h=Subject:To:Cc:From:Date:From;
        b=eSlE6aDqEbV630w6srw5gIcm69ZG9VSWHSPhgiomuYv9mQv4AI4Mw0mX2AFPvTJwq
         MsjqdL0Kk3PLuaFvR1TVM/hjWDlSny61R5ECEzykB88oZdBvyl4h+aMdCfe421dNd0
         9iWsuudv78vts3+y54TvDTbi1lPRm7gMBk5DkLSQ=
Subject: FAILED: patch "[PATCH] io_uring: dont remove file from msg_ring reqs" failed to apply to 6.0-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 14:12:07 +0100
Message-ID: <16722331272159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ef0ec1ad0311 ("io_uring: dont remove file from msg_ring reqs")
5756a3a7e713 ("io_uring: add iopoll infrastructure for io_uring_cmd")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef0ec1ad03119b8b46b035dad42bca7d6da7c2e5 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 7 Dec 2022 03:53:26 +0000
Subject: [PATCH] io_uring: dont remove file from msg_ring reqs

We should not be messing with req->file outside of core paths. Clearing
it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
request on failed io_double_lock_ctx() but clearly was originally
intended to do retries instead.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c30765579a8e..5fa92170c373 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1799,7 +1799,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index afb543aab9f6..615c85e164ab 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -167,9 +167,5 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	/* put file to avoid an attempt to IOPOLL the req */
-	if (!(req->flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	req->file = NULL;
 	return IOU_OK;
 }
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 83dc0f9ad3b2..04dd2c983fce 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -63,6 +63,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READV",
 		.prep			= io_prep_rw,
@@ -80,6 +81,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITEV",
 		.prep			= io_prep_rw,
@@ -103,6 +105,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
@@ -118,6 +121,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
@@ -277,6 +281,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ",
 		.prep			= io_prep_rw,
@@ -292,6 +297,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
@@ -481,6 +487,7 @@ const struct io_op_def io_op_defs[] = {
 		.plug			= 1,
 		.name			= "URING_CMD",
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 3efe06d25473..df7e13d9bfba 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -25,6 +25,8 @@ struct io_op_def {
 	unsigned		ioprio : 1;
 	/* supports iopoll */
 	unsigned		iopoll : 1;
+	/* have to be put into the iopoll list */
+	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
 	/* size of async data needed, if any */

