Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C002A1719
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJaLvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgJaLkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C446720719;
        Sat, 31 Oct 2020 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144431;
        bh=2qmKlyrce1/VdJfv1GImth9seO9GFcC//1Ed/4rXr34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTM4zg7coC2D2q2WU38uVqvjuiFhuhQWk3Ry//dtRj5kb8j12rjNrTMCX0Yhznpxi
         G0q4vUY9I4Qvih+rD8ftUi32vaT0/BcVRoeUbK7fdq3QlenyHyxuxVlisjxVNb60gv
         djmZxma2MUaKzV8JFeGIH4FMmn8fkzg862Ia/tPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 16/70] io_uring: Convert advanced XArray uses to the normal API
Date:   Sat, 31 Oct 2020 12:35:48 +0100
Message-Id: <20201031113500.284498737@linuxfoundation.org>
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
@@ -7958,27 +7958,17 @@ static int io_uring_add_task_file(struct
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


