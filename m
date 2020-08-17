Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5492474FA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgHQTRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbgHQPi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A2A23105;
        Mon, 17 Aug 2020 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678706;
        bh=hVCf1vtbcgT6nblngcNF5TbXlrzSAIyUa+ja/yUPDxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fp7/xgo9wt9teLOvp4EQ+LdpWcpHJT2sWBgUJSfOGHwsZrMZYMZIDAXjJl9TcczWS
         ofp6aaRVUpdbkgIaYku68LNPdWsoB6A0WJhBcLAjNySkjoK8D/pb5xpV5WBARpZRuE
         ukUt/qbxApDVEibiou2mgEmngP7ZHKozNcjqRb4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 427/464] io_uring: sanitize double poll handling
Date:   Mon, 17 Aug 2020 17:16:20 +0200
Message-Id: <20200817143854.232224051@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c upstream.

There's a bit of confusion on the matching pairs of poll vs double poll,
depending on if the request is a pure poll (IORING_OP_POLL_ADD) or
poll driven retry.

Add io_poll_get_double() that returns the double poll waitqueue, if any,
and io_poll_get_single() that returns the original poll waitqueue. With
that, remove the argument to io_poll_remove_double().

Finally ensure that wait->private is cleared once the double poll handler
has run, so that remove knows it's already been seen.

Cc: stable@vger.kernel.org # v5.8
Reported-by: syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4172,9 +4172,24 @@ static bool io_poll_rewait(struct io_kio
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req, void *data)
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = data;
+	/* pure poll stashes this in ->io, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return (struct io_poll_iocb *) req->io;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_double(req);
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4194,7 +4209,7 @@ static void io_poll_complete(struct io_k
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req, req->io);
+	io_poll_remove_double(req);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4236,7 +4251,7 @@ static int io_poll_double_wake(struct wa
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = req->apoll->double_poll;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
@@ -4250,6 +4265,8 @@ static int io_poll_double_wake(struct wa
 		done = list_empty(&poll->wait.entry);
 		if (!done)
 			list_del_init(&poll->wait.entry);
+		/* make sure double remove sees this as being gone */
+		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
@@ -4358,7 +4375,7 @@ static void io_async_task_func(struct ca
 		}
 	}
 
-	io_poll_remove_double(req, apoll->double_poll);
+	io_poll_remove_double(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
@@ -4484,7 +4501,7 @@ static bool io_arm_poll_handler(struct i
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req, apoll->double_poll);
+		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		if (req->flags & REQ_F_WORK_INITIALIZED)
 			memcpy(&req->work, &apoll->work, sizeof(req->work));
@@ -4518,14 +4535,13 @@ static bool io_poll_remove_one(struct io
 {
 	bool do_complete;
 
+	io_poll_remove_double(req);
+
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
-		io_poll_remove_double(req, apoll->double_poll);
-
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {


