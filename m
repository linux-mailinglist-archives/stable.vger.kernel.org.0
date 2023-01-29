Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8444367FF57
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 14:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjA2N0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 08:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2N0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 08:26:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBAD125B8
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 05:26:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 352E1B80AFB
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 13:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEB0C433EF;
        Sun, 29 Jan 2023 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674998790;
        bh=VbKe8fahcjy+Jevtq/SLxhoVKCg7AkPlTUmutsOIrsA=;
        h=Subject:To:Cc:From:Date:From;
        b=Ra+77VyBJLa+asKNLPiNIxO8YbhkFgv59vrybutgX5Bz75Hp55fTpGf8lDDGk3aas
         5lOSpGYWwcWNWEQ7aXg1lSay9KkUVE0BucBheR7R9Heo2SeJEMQUTVSBMlgi4v5+MQ
         J2dpiNR5gCVxE4yanFXNImM1c1QSmmHGE5UdL3/w=
Subject: FAILED: patch "[PATCH] io_uring: always prep_async for drain requests" failed to apply to 6.1-stable tree
To:     dylany@meta.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Jan 2023 14:26:27 +0100
Message-ID: <1674998787177121@kroah.com>
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

Possible dependencies:

ef5c600adb1d ("io_uring: always prep_async for drain requests")
973fc83f3a94 ("io_uring: defer all io_req_complete_failed")
1bec951c3809 ("io_uring: iopoll protect complete_post")
fa18fa2272c7 ("io_uring: inline __io_req_complete_put()")
e276ae344a77 ("io_uring: hold locks for io_req_complete_failed")
f9d567c75ec2 ("io_uring: inline __io_req_complete_post()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef5c600adb1d985513d2b612cc90403a148ff287 Mon Sep 17 00:00:00 2001
From: Dylan Yudaken <dylany@meta.com>
Date: Fri, 27 Jan 2023 02:59:11 -0800
Subject: [PATCH] io_uring: always prep_async for drain requests

Drain requests all go through io_drain_req, which has a quick exit in case
there is nothing pending (ie the drain is not useful). In that case it can
run the issue the request immediately.

However for safety it queues it through task work.
The problem is that in this case the request is run asynchronously, but
the async work has not been prepared through io_req_prep_async.

This has not been a problem up to now, as the task work always would run
before returning to userspace, and so the user would not have a chance to
race with it.

However - with IORING_SETUP_DEFER_TASKRUN - this is no longer the case and
the work might be defered, giving userspace a chance to change data being
referred to in the request.

Instead _always_ prep_async for drain requests, which is simpler anyway
and removes this issue.

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20230127105911.2420061-1-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0a4efada9b3c..db623b3185c8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1765,17 +1765,12 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	}
 	spin_unlock(&ctx->completion_lock);
 
-	ret = io_req_prep_async(req);
-	if (ret) {
-fail:
-		io_req_defer_failed(req, ret);
-		return;
-	}
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
 		ret = -ENOMEM;
-		goto fail;
+		io_req_defer_failed(req, ret);
+		return;
 	}
 
 	spin_lock(&ctx->completion_lock);
@@ -2048,13 +2043,16 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		req->flags &= ~REQ_F_HARDLINK;
 		req->flags |= REQ_F_LINK;
 		io_req_defer_failed(req, req->cqe.res);
-	} else if (unlikely(req->ctx->drain_active)) {
-		io_drain_req(req);
 	} else {
 		int ret = io_req_prep_async(req);
 
-		if (unlikely(ret))
+		if (unlikely(ret)) {
 			io_req_defer_failed(req, ret);
+			return;
+		}
+
+		if (unlikely(req->ctx->drain_active))
+			io_drain_req(req);
 		else
 			io_queue_iowq(req, NULL);
 	}

