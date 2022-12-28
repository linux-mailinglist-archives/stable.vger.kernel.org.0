Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2D6584FC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiL1RE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiL1RED (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE920180
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3259961558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C56C433D2;
        Wed, 28 Dec 2022 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246714;
        bh=u2ZVmdy/mQ2rc9BloLo59YAIgaRGPILHcWtU5sWASPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1JKXuqN/mce0+RQCxfLfyuy+eSyEqfwdO7WsbPvDSBj4vtEdMCsUzIRauyF9nIC1
         ZKQRsQvhdLlEwCPK24mU0DC+LlO8IoTnQmA+xzLJP1cQwQSPHfR8qd9vHl7poQP+dk
         0C3R8ww7j04jaOQJSlBzq4il4Bhq1M4AF9qWBmHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1137/1146] io_uring: dont remove file from msg_ring reqs
Date:   Wed, 28 Dec 2022 15:44:36 +0100
Message-Id: <20221228144401.027882798@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
@@ -1757,7 +1757,7 @@ static int io_issue_sqe(struct io_kiocb
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */
-	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -167,9 +167,5 @@ done:
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


