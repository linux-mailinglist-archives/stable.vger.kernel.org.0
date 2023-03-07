Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C406AF54F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbjCGTYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbjCGTXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:23:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C53AD029
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECCFEB817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53333C433EF;
        Tue,  7 Mar 2023 19:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216165;
        bh=7nCHWbcbj5ZMPZ1DqBSUpUJQ0bD/trdvrJYTbnSwCdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6kj/QTrj2p3dHuv2JSTCVP58VSY2p5EAYSzxJluch5IJboJSE4l5F4YNsun5VERf
         8KZ7UCK2jXDBJ4s+idmQEZOk1GR2IQp/4Q7s8dmPO9EP2NUWqyBaCoRsePKugvW3jE
         SYkJsyY+jTayV9dJRvz5X4e0l7wdBB02G3Y8jPIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 495/567] io_uring/poll: allow some retries for poll triggering spuriously
Date:   Tue,  7 Mar 2023 18:03:51 +0100
Message-Id: <20230307165927.404253063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit c16bda37594f83147b167d381d54c010024efecf upstream.

If we get woken spuriously when polling and fail the operation with
-EAGAIN again, then we generally only allow polling again if data
had been transferred at some point. This is indicated with
REQ_F_PARTIAL_IO. However, if the spurious poll triggers when the socket
was originally empty, then we haven't transferred data yet and we will
fail the poll re-arm. This either punts the socket to io-wq if it's
blocking, or it fails the request with -EAGAIN if not. Neither condition
is desirable, as the former will slow things down, while the latter
will make the application confused.

We want to ensure that a repeated poll trigger doesn't lead to infinite
work making no progress, that's what the REQ_F_PARTIAL_IO check was
for. But it doesn't protect against a loop post the first receive, and
it's unnecessarily strict if we started out with an empty socket.

Add a somewhat random retry count, just to put an upper limit on the
potential number of retries that will be done. This should be high enough
that we won't really hit it in practice, unless something needs to be
aborted anyway.

Cc: stable@vger.kernel.org # v5.10+
Link: https://github.com/axboe/liburing/issues/364
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -486,6 +486,7 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 
@@ -5894,6 +5895,14 @@ enum {
 	IO_APOLL_READY
 };
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static int io_arm_poll_handler(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -5905,8 +5914,6 @@ static int io_arm_poll_handler(struct io
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 
@@ -5924,8 +5931,13 @@ static int io_arm_poll_handler(struct io
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
+		if (unlikely(!--apoll->poll.retries)) {
+			apoll->double_poll = NULL;
+			return IO_APOLL_ABORTED;
+		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;


