Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC003D6140
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhGZPaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhGZP2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB4F60FE7;
        Mon, 26 Jul 2021 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315637;
        bh=nLaMHd5ZIveVsMInaOvIXwaHzShiRPZOrYHqcUJqKQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqvzeWXOOJBoIUOqPj7E8rb5N8Z/b5zQEMJ3O7Qb35+ay+RqeybdhUoDIcbnol37e
         XufKpwXfyqTqbo0WYqSTjXn6KCNRDlGI3WTU0ymsuB4P2+QvHUu0boPYHZCSR1Udkz
         wuVq6AQqEU9vN6QtKUwFFJoqMvbrdSrkiJYlX77k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 144/167] io_uring: explicitly count entries for poll reqs
Date:   Mon, 26 Jul 2021 17:39:37 +0200
Message-Id: <20210726153844.243024000@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 68b11e8b1562986c134764433af64e97d30c9fc0 upstream.

If __io_queue_proc() fails to add a second poll entry, e.g. kmalloc()
failed, but it goes on with a third waitqueue, it may succeed and
overwrite the error status. Count the number of poll entries we added,
so we can set pt->error to zero at the beginning and find out when the
mentioned scenario happens.

Cc: stable@vger.kernel.org
Fixes: 18bceab101add ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9d6b9e561f88bcc0163623b74a76c39f712151c3.1626774457.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4916,6 +4916,7 @@ static int io_connect(struct io_kiocb *r
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
+	int nr_entries;
 	int error;
 };
 
@@ -5098,11 +5099,11 @@ static void __io_queue_proc(struct io_po
 	struct io_kiocb *req = pt->req;
 
 	/*
-	 * If poll->head is already set, it's because the file being polled
-	 * uses multiple waitqueues for poll handling (eg one for read, one
-	 * for write). Setup a separate io_poll_iocb if this happens.
+	 * The file being polled uses multiple waitqueues for poll handling
+	 * (e.g. one for read, one for write). Setup a separate io_poll_iocb
+	 * if this happens.
 	 */
-	if (unlikely(poll->head)) {
+	if (unlikely(pt->nr_entries)) {
 		struct io_poll_iocb *poll_one = poll;
 
 		/* already have a 2nd entry, fail a third attempt */
@@ -5124,7 +5125,7 @@ static void __io_queue_proc(struct io_po
 		*poll_ptr = poll;
 	}
 
-	pt->error = 0;
+	pt->nr_entries++;
 	poll->head = head;
 
 	if (poll->events & EPOLLEXCLUSIVE)
@@ -5210,9 +5211,12 @@ static __poll_t __io_arm_poll_handler(st
 
 	ipt->pt._key = mask;
 	ipt->req = req;
-	ipt->error = -EINVAL;
+	ipt->error = 0;
+	ipt->nr_entries = 0;
 
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
+	if (unlikely(!ipt->nr_entries) && !ipt->error)
+		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (likely(poll->head)) {


