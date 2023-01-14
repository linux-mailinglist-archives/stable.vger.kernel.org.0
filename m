Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F03066AABD
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjANJvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjANJvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:51:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C0A195
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C1D260765
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A10FC433D2;
        Sat, 14 Jan 2023 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689903;
        bh=55p8b/+cogcfwXr6c+4dA+1QyiJsYvLpKQARm0rbVw4=;
        h=Subject:To:Cc:From:Date:From;
        b=suzQhoD6QIeiEvZtyPMvuqK9CyIv7jLKvZP8IzqYFzy6uc7AukvpJpaqspKidk1rl
         V8cmc9vbP3lTDVhrMsEBlB70/pTT3xft/ztOXTpWEKuEiGoLjdV/tD5Kai6MLn8yKF
         Uh3xySmdet17jvUXl3xdbIPuRlVKMuHOvNeUE1Ik=
Subject: FAILED: patch "[PATCH] io_uring/poll: attempt request issue after racy poll wakeup" failed to apply to 6.1-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:51:39 +0100
Message-ID: <1673689899136134@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
443e57550670 ("io_uring: combine poll tw handlers")
047b6aef0966 ("io_uring: remove ctx variable in io_poll_check_events")
9b8c54755a2b ("io_uring: add io_aux_cqe which allows deferred completion")
973fc83f3a94 ("io_uring: defer all io_req_complete_failed")
c06c6c5d2767 ("io_uring: always lock in io_apoll_task_func")
1bec951c3809 ("io_uring: iopoll protect complete_post")
fa18fa2272c7 ("io_uring: inline __io_req_complete_put()")
e276ae344a77 ("io_uring: hold locks for io_req_complete_failed")
f9d567c75ec2 ("io_uring: inline __io_req_complete_post()")
cd42a53d25d4 ("io_uring/poll: remove outdated comments of caching")
e2ad599d1ed3 ("io_uring: allow multishot recv CQEs to overflow")
515e26961295 ("io_uring: revert "io_uring fix multishot accept ordering"")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e5aedb9324aab1c14a23fae3d8eeb64a679c20e Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 10 Jan 2023 10:44:37 -0700
Subject: [PATCH] io_uring/poll: attempt request issue after racy poll wakeup

If we have multiple requests waiting on the same target poll waitqueue,
then it's quite possible to get a request triggered and get disappointed
in not being able to make any progress with it. If we race in doing so,
we'll potentially leave the poll request on the internal tables, but
removed from the waitqueue. That means that any subsequent trigger of
the poll waitqueue will not kick that request into action, causing an
application to potentially wait for completion of a request that will
never happen.

Fix this by adding a new poll return state, IOU_POLL_REISSUE. Rather
than have complicated logic for how to re-arm a given type of request,
just punt it for a reissue.

While in there, move the 'ret' variable to the only section where it
gets used. This avoids confusion the scope of it.

Cc: stable@vger.kernel.org
Fixes: eb0089d629ba ("io_uring: single shot poll removal optimisation")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index cf6a70bd54e0..32e5fc8365e6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -223,21 +223,22 @@ enum {
 	IOU_POLL_DONE = 0,
 	IOU_POLL_NO_ACTION = 1,
 	IOU_POLL_REMOVE_POLL_USE_RES = 2,
+	IOU_POLL_REISSUE = 3,
 };
 
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
  *
- * Returns a negative error on failure. IOU_POLL_NO_ACTION when no action require,
- * which is either spurious wakeup or multishot CQE is served.
- * IOU_POLL_DONE when it's done with the request, then the mask is stored in req->cqe.res.
- * IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot poll and that the result
- * is stored in req->cqe.
+ * Returns a negative error on failure. IOU_POLL_NO_ACTION when no action
+ * require, which is either spurious wakeup or multishot CQE is served.
+ * IOU_POLL_DONE when it's done with the request, then the mask is stored in
+ * req->cqe.res. IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot
+ * poll and that the result is stored in req->cqe.
  */
 static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
-	int v, ret;
+	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
@@ -276,10 +277,15 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 		if (!req->cqe.res) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
+			/*
+			 * We got woken with a mask, but someone else got to
+			 * it first. The above vfs_poll() doesn't add us back
+			 * to the waitqueue, so if we get nothing back, we
+			 * should be safe and attempt a reissue.
+			 */
+			if (unlikely(!req->cqe.res))
+				return IOU_POLL_REISSUE;
 		}
-
-		if ((unlikely(!req->cqe.res)))
-			continue;
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;
 
@@ -294,7 +300,7 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			ret = io_poll_issue(req, locked);
+			int ret = io_poll_issue(req, locked);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)
@@ -330,6 +336,9 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
+		} else if (ret == IOU_POLL_REISSUE) {
+			io_req_task_submit(req, locked);
+			return;
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
 			req_set_fail(req);
@@ -342,7 +351,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
 			io_req_task_complete(req, locked);
-		else if (ret == IOU_POLL_DONE)
+		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 			io_req_task_submit(req, locked);
 		else
 			io_req_defer_failed(req, ret);

