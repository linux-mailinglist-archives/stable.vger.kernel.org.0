Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E37B2A15F5
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgJaLka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727353AbgJaLk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA37620731;
        Sat, 31 Oct 2020 11:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144426;
        bh=Csmu/aoph/I1G8huV9ayhGWzcyNnZ3WOSLX47x3dAH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7DuFU9eoOduceZ5+P7GT9I0SdLGR3sMbkFBPz+OR5snPULTfqZueF1aliVkKvw9Q
         eCFVK+M5YxoczsyNz8eNs/4WSXTXrCknqg6l4GOuxp9hxFbp8QNzCf9fpjDGcy8jyw
         Tu2XTfmtv1VH9gZ9iqPgrc51wnRbzXn1Y2bhej2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 14/70] io_uring: Fix use of XArray in __io_uring_files_cancel
Date:   Sat, 31 Oct 2020 12:35:46 +0100
Message-Id: <20201031113500.188798721@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit ce765372bc443573d1d339a2bf4995de385dea3a upstream.

We have to drop the lock during each iteration, so there's no advantage
to using the advanced API.  Convert this to a standard xa_for_each() loop.

Reported-by: syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8008,28 +8008,19 @@ static void io_uring_attempt_task_drop(s
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, 0);
+	struct file *file;
+	unsigned long index;
 
 	/* make sure overflow events are dropped */
 	tctx->in_idle = true;
 
-	do {
-		struct io_ring_ctx *ctx;
-		struct file *file;
-
-		xas_lock(&xas);
-		file = xas_next_entry(&xas, ULONG_MAX);
-		xas_unlock(&xas);
-
-		if (!file)
-			break;
-
-		ctx = file->private_data;
+	xa_for_each(&tctx->xa, index, file) {
+		struct io_ring_ctx *ctx = file->private_data;
 
 		io_uring_cancel_task_requests(ctx, files);
 		if (files)
 			io_uring_del_task_file(file);
-	} while (1);
+	}
 }
 
 static inline bool io_uring_task_idle(struct io_uring_task *tctx)


