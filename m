Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0EE603BB2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJSIi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiJSIiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C437EFD9;
        Wed, 19 Oct 2022 01:37:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ACE4617D1;
        Wed, 19 Oct 2022 08:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A7EC433D7;
        Wed, 19 Oct 2022 08:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168654;
        bh=E3KbfE3JN8ZFZ/u0udqsUtKwyNtjegt0C+1iFAwMfeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWAB9h1Zb1Pae7YRh6R9cpp4lQUk60tTZV7QzvC4xBfY4Q+c3Q7ZgxDqELZXgITdA
         3CELAtU0OSqu6vDXK7zKFyJ8K0Swya6JEYxA/V+DAZf9mX+XKw9exjji6aNjUmXyBT
         1DUy5GnxrTwe+YNhPPLI9Mf+UDi+C3Yr/gXMyCUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 011/862] io_uring/rw: dont lose partial IO result on fail
Date:   Wed, 19 Oct 2022 10:21:38 +0200
Message-Id: <20221019083250.513888626@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 47b4c68660752facfa6247b1fc9ca9d722b8b601 upstream.

A partially done read/write may end up in io_req_complete_failed() and
loose the result, make sure we return the number of bytes processed.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/05e0879c226bcd53b441bf92868eadd4bf04e2fc.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/opdef.c |    6 ++++++
 io_uring/rw.c    |    8 ++++++++
 io_uring/rw.h    |    1 +
 3 files changed, 15 insertions(+)

--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -69,6 +69,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_read,
 		.prep_async		= io_readv_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITEV] = {
 		.needs_file		= 1,
@@ -85,6 +86,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_write,
 		.prep_async		= io_writev_prep_async,
 		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -105,6 +107,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -119,6 +122,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -273,6 +277,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "READ",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
@@ -287,6 +292,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "WRITE",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
+		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -984,6 +984,14 @@ static void io_cqring_ev_posted_iopoll(s
 		io_cqring_wake(ctx);
 }
 
+void io_rw_fail(struct io_kiocb *req)
+{
+	int res;
+
+	res = io_fixup_rw_res(req, req->cqe.res);
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -21,3 +21,4 @@ int io_readv_prep_async(struct io_kiocb
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 int io_writev_prep_async(struct io_kiocb *req);
 void io_readv_writev_cleanup(struct io_kiocb *req);
+void io_rw_fail(struct io_kiocb *req);


