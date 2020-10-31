Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741F62A16CD
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgJaLsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgJaLnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BBF205F4;
        Sat, 31 Oct 2020 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144610;
        bh=7FOVsB7YlhInGJThELoraNZAldV/rJyW34BnP0y0MBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrJzAC4TKNYmr9mZ7zcYAePBTR25yCr5FRefwWGDbbJH8CaFILelGUByOfQwVN0hQ
         vhpBAijr4MN2oRmIMLLIHqiA/L43IjK4F0IvDi84ttObJO1o9W5GPdkKvSgDN9xnZ4
         ogDp7WASsUY4OEeCFB2pllJU6tF2+w4J3xTpHJDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 14/74] io_uring: Fix use of XArray in __io_uring_files_cancel
Date:   Sat, 31 Oct 2020 12:35:56 +0100
Message-Id: <20201031113500.734482886@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
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
@@ -8415,28 +8415,19 @@ static void io_uring_attempt_task_drop(s
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


