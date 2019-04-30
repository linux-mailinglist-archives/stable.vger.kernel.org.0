Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218A3F65E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfD3Lqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfD3Lqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD34F21670;
        Tue, 30 Apr 2019 11:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624803;
        bh=hl6y8IpcADeWZh/TJFJvpqeR6jds7Xsld/cDqmw6QaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVN1CFS27vjxlEVZO9qVv6qjBbfHLGSlpmp9lxpzAj01fIrOXnXJitc53RUx9jvci
         obfGorEM2Sm6M0EKMEE7Ks8ychKlcpgHFRdLw7p90SX3p9/v6xF5D8Hur+9g/p0f70
         s977+IHQd9G1zbg7iW49+Vd+DDz7COf8r8+1MdU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 077/100] aio: keep io_event in aio_kiocb
Date:   Tue, 30 Apr 2019 13:38:46 +0200
Message-Id: <20190430113612.367079427@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
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
@@ -198,8 +198,7 @@ struct aio_kiocb {
 	struct kioctx		*ki_ctx;
 	kiocb_cancel_fn		*ki_cancel;
 
-	struct iocb __user	*ki_user_iocb;	/* user's aiocb */
-	__u64			ki_user_data;	/* user's data for completion */
+	struct io_event		ki_res;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
@@ -1078,15 +1077,6 @@ static inline void iocb_put(struct aio_k
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
@@ -1098,6 +1088,8 @@ static void aio_complete(struct aio_kioc
 	unsigned tail, pos, head;
 	unsigned long	flags;
 
+	iocb->ki_res.res = res;
+	iocb->ki_res.res2 = res2;
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->completion_lock to prevent other code from messing with the tail
@@ -1114,14 +1106,14 @@ static void aio_complete(struct aio_kioc
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
@@ -1838,8 +1830,10 @@ static int __io_submit_one(struct kioctx
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
@@ -2009,6 +2003,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	struct aio_kiocb *kiocb;
 	int ret = -EINVAL;
 	u32 key;
+	u64 obj = (u64)(unsigned long)iocb;
 
 	if (unlikely(get_user(key, &iocb->aio_key)))
 		return -EFAULT;
@@ -2022,7 +2017,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 	spin_lock_irq(&ctx->ctx_lock);
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
-		if (kiocb->ki_user_iocb == iocb) {
+		if (kiocb->ki_res.obj == obj) {
 			ret = kiocb->ki_cancel(&kiocb->rw);
 			list_del_init(&kiocb->ki_list);
 			break;


