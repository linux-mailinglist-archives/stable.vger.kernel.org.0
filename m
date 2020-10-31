Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FCD2A15F7
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgJaLkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727284AbgJaLka (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 958DA2074F;
        Sat, 31 Oct 2020 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144429;
        bh=9o9qNHyh/1doJtI+3C8J1EGIxXlMahPlTmIobiT05HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tr9wz2il7CrH0COYMJYDl0kklaFe6Ee7ObMmz1zx4b5QVwKg2n3U3xzT3kmw+VE7g
         /FFdMaUrSVm+Q4jMhN8e/fEr+z1bn94eGERIntVaEiioJiI98u5wqy+g1lMNMi2MYQ
         b43F98qW/oX6TwDTfop/UqJZrN43tHB9QIcmUe1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 15/70] io_uring: Fix XArray usage in io_uring_add_task_file
Date:   Sat, 31 Oct 2020 12:35:47 +0100
Message-Id: <20201031113500.235831979@linuxfoundation.org>
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

commit 236434c3438c4da3dfbd6aeeab807577b85e951a upstream.

The xas_store() wasn't paired with an xas_nomem() loop, so if it couldn't
allocate memory using GFP_NOWAIT, it would leak the reference to the file
descriptor.  Also the node pointed to by the xas could be freed between
the call to xas_load() under the rcu_read_lock() and the acquisition of
the xa_lock.

It's easier to just use the normal xa_load/xa_store interface here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[axboe: fix missing assign after alloc, cur_uring -> tctx rename]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7929,27 +7929,24 @@ static void io_uring_cancel_task_request
  */
 static int io_uring_add_task_file(struct file *file)
 {
-	if (unlikely(!current->io_uring)) {
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (unlikely(!tctx)) {
 		int ret;
 
 		ret = io_uring_alloc_task_context(current);
 		if (unlikely(ret))
 			return ret;
+		tctx = current->io_uring;
 	}
-	if (current->io_uring->last != file) {
-		XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-		void *old;
+	if (tctx->last != file) {
+		void *old = xa_load(&tctx->xa, (unsigned long)file);
 
-		rcu_read_lock();
-		old = xas_load(&xas);
-		if (old != file) {
+		if (!old) {
 			get_file(file);
-			xas_lock(&xas);
-			xas_store(&xas, file);
-			xas_unlock(&xas);
+			xa_store(&tctx->xa, (unsigned long)file, file, GFP_KERNEL);
 		}
-		rcu_read_unlock();
-		current->io_uring->last = file;
+		tctx->last = file;
 	}
 
 	return 0;


