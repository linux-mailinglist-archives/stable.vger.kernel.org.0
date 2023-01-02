Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7365B107
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbjABL35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbjABL31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:29:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C0C49
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77296B80CA9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA444C433EF;
        Mon,  2 Jan 2023 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658935;
        bh=5H1Ok/Poarh9aLhw8CMO1K9S/MtgNlF0gCLmX4szP68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUFMwpLA20t+w5u+h5gJI41QDobhE/DZOCdFkCXGUOFB7XsJjVyjNNt9RNT9SEuBQ
         iPB9xMnUdb8gr3NUcLPSFbVjz33OtKD6M2V1Ffp3tkzwd+VIuR6FlgNW6pxR5LreJF
         Js0xcXei/tvFDoy3SQ1WRKCAc8RE5adzilaX91Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 55/74] io_uring: dont remove file from msg_ring reqs
Date:   Mon,  2 Jan 2023 12:22:28 +0100
Message-Id: <20230102110554.449273607@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit ef0ec1ad03119b8b46b035dad42bca7d6da7c2e5 upstream.

We should not be messing with req->file outside of core paths. Clearing
it makes msg_ring non reentrant, i.e. luckily io_msg_send_fd() fails the
request on failed io_double_lock_ctx() but clearly was originally
intended to do retries instead.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e5ac9edadb574fe33f6d727cb8f14ce68262a684.1670384893.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/msg_ring.c |    4 ----
 io_uring/opdef.c    |    7 +++++++
 io_uring/opdef.h    |    2 ++
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1607,7 +1607,7 @@ static int io_issue_sqe(struct io_kiocb
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -169,9 +169,5 @@ done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	/* put file to avoid an attempt to IOPOLL the req */
-	if (!(req->flags & REQ_F_FIXED_FILE))
-		io_put_file(req->file);
-	req->file = NULL;
 	return IOU_OK;
 }
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
@@ -275,6 +279,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ",
 		.prep			= io_prep_rw,
@@ -290,6 +295,7 @@ const struct io_op_def io_op_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.iopoll			= 1,
+		.iopoll_queue		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
@@ -475,6 +481,7 @@ const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.plug			= 1,
 		.name			= "URING_CMD",
+		.iopoll_queue		= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
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


