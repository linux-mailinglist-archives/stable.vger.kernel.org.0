Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD55B446E
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiIJG3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIJG3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872C09E0E0
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E526B806A0
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3CDC433D6;
        Sat, 10 Sep 2022 06:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791337;
        bh=8qSvqeql3tXt4nS4g0i3EQmvvKNx4meS8Af+8YTHxIY=;
        h=Subject:To:Cc:From:Date:From;
        b=0p2UXl5FJsGB8HqrTam1iISPaqRxJMZ6I7XtpOWeEWp7mGYqsDtnNyOOG8Tx3Qmex
         zHz/uB1YDXF3xhr+7eXF4JpkS1qabwheeQSHSNTA5BxaryTspCc+vq0D1NW2f17Mj6
         8Z4ehSEou1GW9CegCL6O1bChQthkVayjOeQAryA8=
Subject: FAILED: patch "[PATCH] io_uring/rw: fix short rw error handling" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, beldzhang@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:29:09 +0200
Message-ID: <166279134922697@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4d9cb92ca41d ("io_uring/rw: fix short rw error handling")
f2ccb5aed7bc ("io_uring: make io_kiocb_to_cmd() typesafe")
14b146b688ad ("io_uring: notification completion optimisation")
6a9ce66f4d08 ("io_uring/net: make page accounting more consistent")
2e32ba5607ee ("io_uring/net: checks errors of zc mem accounting")
3ff1a0d395c0 ("io_uring: enable managed frags with register buffers")
492dddb4f6e3 ("io_uring: add zc notification flush requests")
4379d5f15b3f ("io_uring: rename IORING_OP_FILES_UPDATE")
63809137ebb5 ("io_uring: flush notifiers after sendzc")
10c7d33ecd51 ("io_uring: sendzc with fixed buffers")
e29e3bd4b968 ("io_uring: account locked pages for non-fixed zc")
06a5464be84e ("io_uring: wire send zc request type")
bc24d6bd32df ("io_uring: add notification slot registration")
68ef5578efc8 ("io_uring: add rsrc referencing for notifiers")
e58d498e81ba ("io_uring: complete notifiers in tw")
eb4a299b2f95 ("io_uring: cache struct io_notif")
eb42cebb2cf2 ("io_uring: add zc notification infrastructure")
e70cb60893ca ("io_uring: export io_put_task()")
72c531f8ef30 ("net: copy from user before calling __get_compat_msghdr")
7fa875b8e53c ("net: copy from user before calling __copy_msghdr")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d9cb92ca41dd8e905a4569ceba4716c2f39c75a Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 9 Sep 2022 12:11:49 +0100
Subject: [PATCH] io_uring/rw: fix short rw error handling

We have a couple of problems, first reports of unexpected link breakage
for reads when cqe->res indicates that the IO was done in full. The
reason here is partial IO with retries.

TL;DR; we compare the result in __io_complete_rw_common() against
req->cqe.res, but req->cqe.res doesn't store the full length but rather
the length left to be done. So, when we pass the full corrected result
via kiocb_done() -> __io_complete_rw_common(), it fails.

The second problem is that we don't try to correct res in
io_complete_rw(), which, for instance, might be a problem for O_DIRECT
but when a prefix of data was cached in the page cache. We also
definitely don't want to pass a corrected result into io_rw_done().

The fix here is to leave __io_complete_rw_common() alone, always pass
not corrected result into it and fix it up as the last step just before
actually finishing the I/O.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/643
Reported-by: Beld Zhang <beldzhang@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..1e18a44adcf5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -206,6 +206,20 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (req_has_async_data(req) && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -213,7 +227,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	io_req_set_res(req, res, 0);
+	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -240,22 +254,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
-	struct io_async_rw *io = req->async_data;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	/* add previously done IO, if any */
-	if (req_has_async_data(req) && io->bytes_done > 0) {
-		if (ret < 0)
-			ret = io->bytes_done;
-		else
-			ret += io->bytes_done;
-	}
+	unsigned final_ret = io_fixup_rw_res(req, ret);
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
-			io_req_set_res(req, req->cqe.res,
+			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;
 		}
@@ -268,7 +274,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		if (io_resubmit_prep(req))
 			io_req_task_queue_reissue(req);
 		else
-			io_req_task_queue_fail(req, ret);
+			io_req_task_queue_fail(req, final_ret);
 	}
 	return IOU_ISSUE_SKIP_COMPLETE;
 }

