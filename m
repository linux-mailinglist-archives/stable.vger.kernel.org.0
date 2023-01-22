Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F6676DCA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAVOsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAVOsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:48:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE618AB3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16EA6B80AF5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62757C433EF;
        Sun, 22 Jan 2023 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398891;
        bh=SSfbsEb/W3Wj3pHKkVaehvBqm+i7hkua+2Sv9vjqg5c=;
        h=Subject:To:Cc:From:Date:From;
        b=CXw6dWVYSOdcpifevL4BGqdg/Evh3U/zT/EBN/WK0ELhwLXMVenIWJXFMMw4YRF79
         J28D4WN8CAVbXisw7xUx8Z7JgkuRziawwqpb4FDrdO/NmjwA8zIFb/oN9jG4Wpu8r3
         auZwCH899JX24WL4FGFpIhyT1zOJNxQQCQh2piiM=
Subject: FAILED: patch "[PATCH] io_uring/rw: ensure kiocb_end_write() is always called" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk, david@fromorbit.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 15:48:01 +0100
Message-ID: <1674398881179214@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2ec33a6c3cca ("io_uring/rw: ensure kiocb_end_write() is always called")
b000145e9907 ("io_uring/rw: defer fsnotify calls to task context")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ec33a6c3cca9fe2465e82050c81f5ffdc508b36 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 11 Oct 2022 09:06:23 -0600
Subject: [PATCH] io_uring/rw: ensure kiocb_end_write() is always called

A previous commit moved the notifications and end-write handling, but
it is now missing a few spots where we also want to call both of those.
Without that, we can potentially be missing file notifications, and
more importantly, have an imbalance in the super_block writers sem
accounting.

Fixes: b000145e9907 ("io_uring/rw: defer fsnotify calls to task context")
Reported-by: Dave Chinner <david@fromorbit.com>
Link: https://lore.kernel.org/all/20221010050319.GC2703033@dread.disaster.area/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 453e0ae92160..100de2626e47 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -234,11 +234,34 @@ static void kiocb_end_write(struct io_kiocb *req)
 	}
 }
 
+/*
+ * Trigger the notifications after having done some IO, and finish the write
+ * accounting, if any.
+ */
+static void io_req_io_end(struct io_kiocb *req)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	WARN_ON(!in_task());
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+}
+
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
+			/*
+			 * Reissue will start accounting again, finish the
+			 * current cycle.
+			 */
+			io_req_io_end(req);
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
@@ -264,15 +287,7 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
-
+	io_req_io_end(req);
 	io_req_task_complete(req, locked);
 }
 
@@ -317,6 +332,11 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
+			/*
+			 * Safe to call io_end from here as we're inline
+			 * from the submission path.
+			 */
+			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;

