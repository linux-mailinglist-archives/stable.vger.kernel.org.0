Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112726358E6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbiKWKEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiKWKDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:03:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BE411E825
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E9AA61B56
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9C7C433C1;
        Wed, 23 Nov 2022 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197313;
        bh=ZhQvqvQ+Hq5w0ipKppdMZwwU9csPVlrKf48RFa46F8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlJ37e5Z4Ke1cYai0hXs23XkgP8byvKEvGEwLrCZQqx/gRbUMAquyNvYf8/YkEigF
         toSZaD9UV/ttAmWn5r0ekqWh6Fhsz+SILTFNVAjpyqH+hJLbAdlOioKSXmZAqwRQW4
         Nh+IvZHc96HGMm69r/VLH/ho/2BEpECVm36Ymj9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 258/314] io_uring: fix multishot accept request leaks
Date:   Wed, 23 Nov 2022 09:51:43 +0100
Message-Id: <20221123084637.218693066@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 91482864768a874c4290ef93b84a78f4f1dac51b upstream.

Having REQ_F_POLLED set doesn't guarantee that the request is
executed as a multishot from the polling path. Fortunately for us, if
the code thinks it's multishot issue when it's not, it can only ask to
skip completion so leaking the request. Use issue_flags to mark
multipoll issues.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7700ac57653f2823e30b34dc74da68678c0c5f13.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring.h |    3 +++
 io_uring/io_uring.c      |    2 +-
 io_uring/io_uring.h      |    4 ++--
 io_uring/net.c           |    7 ++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -15,6 +15,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+
+	/* the request is executed from poll, it should not be freed */
+	IO_URING_F_MULTISHOT		= 32,
 };
 
 struct io_uring_cmd {
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1618,7 +1618,7 @@ int io_poll_issue(struct io_kiocb *req,
 	io_tw_lock(req->ctx, locked);
 	if (unlikely(req->task->flags & PF_EXITING))
 		return -EFAULT;
-	return io_issue_sqe(req, IO_URING_F_NONBLOCK);
+	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT);
 }
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,8 +17,8 @@ enum {
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
 	/*
-	 * Intended only when both REQ_F_POLLED and REQ_F_APOLL_MULTISHOT
-	 * are set to indicate to the poll runner that multishot should be
+	 * Intended only when both IO_URING_F_MULTISHOT is passed
+	 * to indicate to the poll runner that multishot should be
 	 * removed and the result is set on req->cqe.res.
 	 */
 	IOU_STOP_MULTISHOT	= -ECANCELED,
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1168,8 +1168,7 @@ retry:
 			 * return EAGAIN to arm the poll infra since it
 			 * has already been done
 			 */
-			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
-			    IO_APOLL_MULTI_POLLED)
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				ret = IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
@@ -1194,9 +1193,7 @@ retry:
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
-	if (req->flags & REQ_F_POLLED)
-		return IOU_STOP_MULTISHOT;
-	return IOU_OK;
+	return (issue_flags & IO_URING_F_MULTISHOT) ? IOU_STOP_MULTISHOT : IOU_OK;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


