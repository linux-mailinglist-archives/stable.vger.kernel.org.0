Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA67F6F7
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbfD3LyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbfD3Lue (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E5621707;
        Tue, 30 Apr 2019 11:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625033;
        bh=pBKdUghoiDyQBtMsgMbl27pwT5kKa9bcaBhf+wduELg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe/zMZNqh/pQ0EPmQiPJPE+THgn6g1cGHUjvpZLWcFzZVcK/HxM1/V0rHy6vgce2w
         k1hytEAC/Bsg6k9A58sBW9IiQ3ytwb19hXKk2PDQbWNPKe5Jstegf4pjOfWCnzJrjo
         RKkbWEi5XZzR++EsuWuwad0l+Oib5ACe6TDSydgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.0 66/89] aio: keep io_event in aio_kiocb
Date:   Tue, 30 Apr 2019 13:38:57 +0200
Message-Id: <20190430113612.819949878@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit a9339b7855094ba11a97e8822ae038135e879e79 upstream.

We want to separate forming the resulting io_event from putting it
into the ring buffer.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -204,8 +204,7 @@ struct aio_kiocb {
 	struct kioctx		*ki_ctx;
 	kiocb_cancel_fn		*ki_cancel;
 
-	struct iocb __user	*ki_user_iocb;	/* user's aiocb */
-	__u64			ki_user_data;	/* user's data for completion */
+	struct io_event		ki_res;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
@@ -1084,15 +1083,6 @@ static inline void iocb_put(struct aio_k
 		iocb_destroy(iocb);
 }
 
-static void aio_fill_event(struct io_event *ev, struct aio_kiocb *iocb,
-			   long res, long res2)
-{
-	ev->obj = (u64)(unsigned long)iocb->ki_user_iocb;
-	ev->data = iocb->ki_user_data;
-	ev->res = res;
-	ev->res2 = res2;
-}
-
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  */
@@ -1104,6 +1094,8 @@ static void aio_complete(struct aio_kioc
 	unsigned tail, pos, head;
 	unsigned long	flags;
 
+	iocb->ki_res.res = res;
+	iocb->ki_res.res2 = res2;
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->completion_lock to prevent other code from messing with the tail
@@ -1120,14 +1112,14 @@ static void aio_complete(struct aio_kioc
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	aio_fill_event(event, iocb, res, res2);
+	*event = iocb->ki_res;
 
 	kunmap_atomic(ev_page);
 	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 
-	pr_debug("%p[%u]: %p: %p %Lx %lx %lx\n",
-		 ctx, tail, iocb, iocb->ki_user_iocb, iocb->ki_user_data,
-		 res, res2);
+	pr_debug("%p[%u]: %p: %p %Lx %Lx %Lx\n", ctx, tail, iocb,
+		 (void __user *)(unsigned long)iocb->ki_res.obj,
+		 iocb->ki_res.data, iocb->ki_res.res, iocb->ki_res.res2);
 
 	/* after flagging the request as done, we
 	 * must never even look at it again
@@ -1844,8 +1836,10 @@ static int __io_submit_one(struct kioctx
 		goto out_put_req;
 	}
 
-	req->ki_user_iocb = user_iocb;
-	req->ki_user_data = iocb->aio_data;
+	req->ki_res.obj = (u64)(unsigned long)user_iocb;
+	req->ki_res.data = iocb->aio_data;
+	req->ki_res.res = 0;
+	req->ki_res.res2 = 0;
 
 	switch (iocb->aio_lio_opcode) {
 	case IOCB_CMD_PREAD:
@@ -2019,6 +2013,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	struct aio_kiocb *kiocb;
 	int ret = -EINVAL;
 	u32 key;
+	u64 obj = (u64)(unsigned long)iocb;
 
 	if (unlikely(get_user(key, &iocb->aio_key)))
 		return -EFAULT;
@@ -2032,7 +2027,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	spin_lock_irq(&ctx->ctx_lock);
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
-		if (kiocb->ki_user_iocb == iocb) {
+		if (kiocb->ki_res.obj == obj) {
 			ret = kiocb->ki_cancel(&kiocb->rw);
 			list_del_init(&kiocb->ki_list);
 			break;


