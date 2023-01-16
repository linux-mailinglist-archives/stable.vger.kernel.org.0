Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA95166C51B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjAPQBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjAPQB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:01:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2734E1DBAB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAFB561042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAF7C433EF;
        Mon, 16 Jan 2023 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884885;
        bh=rNqEF/aIXlvFqIWH47pT7l9K18fsuUb+KuesPhDypos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=led4P3nUb3wS4vSGpZF1adJeuoU/uKTNZ4WhmyR84VzdbvhX/Eee9n0+IQetRBfjM
         GVGW2zbD+VGMciWcTVh63vc+83i8Wzmce/9rI0REAHN8kUTfUgLHw3SLAPg1oLup4d
         53H4UrxikyJztudkuElyCIa6G42v1JT95CAaZoZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/183] io_uring/poll: attempt request issue after racy poll wakeup
Date:   Mon, 16 Jan 2023 16:51:40 +0100
Message-Id: <20230116154810.771826278@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 6e5aedb9324aab1c14a23fae3d8eeb64a679c20e upstream.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -223,22 +223,23 @@ enum {
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
 	struct io_ring_ctx *ctx = req->ctx;
-	int v, ret;
+	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
@@ -274,10 +275,15 @@ static int io_poll_check_events(struct i
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
 		if (io_is_uring_fops(req->file))
@@ -294,7 +300,7 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			ret = io_poll_issue(req, locked);
+			int ret = io_poll_issue(req, locked);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			if (ret < 0)
@@ -325,6 +331,11 @@ static void io_poll_task_func(struct io_
 	if (ret == IOU_POLL_DONE) {
 		struct io_poll *poll = io_kiocb_to_cmd(req, struct io_poll);
 		req->cqe.res = mangle_poll(req->cqe.res & poll->events);
+	} else if (ret == IOU_POLL_REISSUE) {
+		io_poll_remove_entries(req);
+		io_poll_tw_hash_eject(req, locked);
+		io_req_task_submit(req, locked);
+		return;
 	} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 		req->cqe.res = ret;
 		req_set_fail(req);
@@ -350,7 +361,7 @@ static void io_apoll_task_func(struct io
 
 	if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
 		io_req_complete_post(req);
-	else if (ret == IOU_POLL_DONE)
+	else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 		io_req_task_submit(req, locked);
 	else
 		io_req_complete_failed(req, ret);


