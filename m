Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFDA318E0B
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhBKPTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2186664EE8;
        Thu, 11 Feb 2021 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055859;
        bh=wUK9OGL1h0Qhog08GnNk0WylrDiiA+cqNwg3rfsdqCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkzAvMxZB/NQiMLpAHVRoiWb1zucLzvMINyFnLfQcVxhNjNdq3qAE2I1lqAdGfR0A
         SZEqMA/W3mN0zWKRGfkeg7QYUY+BG3fCtx3BcVVVUNK/9mUotViARgsSYiFk+dMt5s
         C05JBEXCogMso/KEPLyvIPyc8FiVf0XaGlqCb7aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josef Grieb <josef.grieb@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 08/54] io_uring: if we see flush on exit, cancel related tasks
Date:   Thu, 11 Feb 2021 16:01:52 +0100
Message-Id: <20210211150153.241428769@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 84965ff8a84f0368b154c9b367b62e59c1193f30 ]

Ensure we match tasks that belong to a dead or dying task as well, as we
need to reap those in addition to those belonging to the exiting task.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1014,8 +1014,12 @@ static bool io_match_task(struct io_kioc
 {
 	struct io_kiocb *link;
 
-	if (task && head->task != task)
+	if (task && head->task != task) {
+		/* in terms of cancelation, always match if req task is dead */
+		if (head->task->flags & PF_EXITING)
+			return true;
 		return false;
+	}
 	if (!files)
 		return true;
 	if (__io_match_files(head, files))
@@ -8844,6 +8848,9 @@ static int io_uring_flush(struct file *f
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = file->private_data;
 
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_uring_cancel_task_requests(ctx, NULL);
+
 	if (!tctx)
 		return 0;
 


