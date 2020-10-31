Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E352A1640
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgJaLng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbgJaLng (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27FDE205F4;
        Sat, 31 Oct 2020 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144615;
        bh=p9xOMi2A1ymsc7DjD2I228sDJtDklQg6PmzGKwwFzHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+3RYoIKKOApoyocp2SRC8VcBuPSuAm7dUTWcapdZbFI5tMpaWn4VRyJASIa+eFea
         pa/J62d04IypPRafYpTfz2giZYz1Sql6opHd42xY8eSUw6johCGOaqAx3Z7FcovPz4
         PIP+4+bwP6Nl56Bhqs9MSbmSNodFYebrEIeVNdqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 16/74] io_uring: Convert advanced XArray uses to the normal API
Date:   Sat, 31 Oct 2020 12:35:58 +0100
Message-Id: <20201031113500.829249474@linuxfoundation.org>
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

commit 5e2ed8c4f45093698855b1f45cdf43efbf6dd498 upstream.

There are no bugs here that I've spotted, it's just easier to use the
normal API and there are no performance advantages to using the more
verbose advanced API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8365,27 +8365,17 @@ static int io_uring_add_task_file(struct
 static void io_uring_del_task_file(struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, (unsigned long) file);
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-
-	xas_lock(&xas);
-	file = xas_store(&xas, NULL);
-	xas_unlock(&xas);
-
+	file = xa_erase(&tctx->xa, (unsigned long)file);
 	if (file)
 		fput(file);
 }
 
 static void __io_uring_attempt_task_drop(struct file *file)
 {
-	XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-	struct file *old;
-
-	rcu_read_lock();
-	old = xas_load(&xas);
-	rcu_read_unlock();
+	struct file *old = xa_load(&current->io_uring->xa, (unsigned long)file);
 
 	if (old == file)
 		io_uring_del_task_file(file);


