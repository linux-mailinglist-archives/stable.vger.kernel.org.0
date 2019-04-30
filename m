Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DFDF6F5
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfD3Lu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730312AbfD3Lu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC2D20449;
        Tue, 30 Apr 2019 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625027;
        bh=u/7bNiFXHlXiSpvKf6zXVsjpXVoJ5NO9TeUy2831uKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcofmEmTrZd8x4RrNX6hp9AooGg05zf7OrKOdUX0gVpk9KP8pMQjRht9yl3oMjEti
         9JKBgIKdxMq5bUwIPTBJQp8GTq93Zv0ciTaacBNzcSIubnzkUKrcZIR9azV5vBxE8+
         LpxQGOzCw5PwqokCOUfis3/UJ20GgKzzs/85sGXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.0 64/89] pin iocb through aio.
Date:   Tue, 30 Apr 2019 13:38:55 +0200
Message-Id: <20190430113612.718349457@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b53119f13a04879c3bf502828d99d13726639ead upstream.

aio_poll() is not the only case that needs file pinned; worse, while
aio_read()/aio_write() can live without pinning iocb itself, the
proof is rather brittle and can easily break on later changes.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1022,6 +1022,9 @@ static bool get_reqs_available(struct ki
 /* aio_get_req
  *	Allocate a slot for an aio request.
  * Returns NULL if no requests are free.
+ *
+ * The refcount is initialized to 2 - one for the async op completion,
+ * one for the synchronous code that does this.
  */
 static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
 {
@@ -1034,7 +1037,7 @@ static inline struct aio_kiocb *aio_get_
 	percpu_ref_get(&ctx->reqs);
 	req->ki_ctx = ctx;
 	INIT_LIST_HEAD(&req->ki_list);
-	refcount_set(&req->ki_refcnt, 0);
+	refcount_set(&req->ki_refcnt, 2);
 	req->ki_eventfd = NULL;
 	return req;
 }
@@ -1067,15 +1070,18 @@ out:
 	return ret;
 }
 
+static inline void iocb_destroy(struct aio_kiocb *iocb)
+{
+	if (iocb->ki_filp)
+		fput(iocb->ki_filp);
+	percpu_ref_put(&iocb->ki_ctx->reqs);
+	kmem_cache_free(kiocb_cachep, iocb);
+}
+
 static inline void iocb_put(struct aio_kiocb *iocb)
 {
-	if (refcount_read(&iocb->ki_refcnt) == 0 ||
-	    refcount_dec_and_test(&iocb->ki_refcnt)) {
-		if (iocb->ki_filp)
-			fput(iocb->ki_filp);
-		percpu_ref_put(&iocb->ki_ctx->reqs);
-		kmem_cache_free(kiocb_cachep, iocb);
-	}
+	if (refcount_dec_and_test(&iocb->ki_refcnt))
+		iocb_destroy(iocb);
 }
 
 static void aio_fill_event(struct io_event *ev, struct aio_kiocb *iocb,
@@ -1749,9 +1755,6 @@ static ssize_t aio_poll(struct aio_kiocb
 	INIT_LIST_HEAD(&req->wait.entry);
 	init_waitqueue_func_entry(&req->wait, aio_poll_wake);
 
-	/* one for removal from waitqueue, one for this function */
-	refcount_set(&aiocb->ki_refcnt, 2);
-
 	mask = vfs_poll(req->file, &apt.pt) & req->events;
 	if (unlikely(!req->head)) {
 		/* we did not manage to set up a waitqueue, done */
@@ -1782,7 +1785,6 @@ out:
 
 	if (mask)
 		aio_poll_complete(aiocb, mask);
-	iocb_put(aiocb);
 	return 0;
 }
 
@@ -1873,18 +1875,21 @@ static int __io_submit_one(struct kioctx
 		break;
 	}
 
+	/* Done with the synchronous reference */
+	iocb_put(req);
+
 	/*
 	 * If ret is 0, we'd either done aio_complete() ourselves or have
 	 * arranged for that to be done asynchronously.  Anything non-zero
 	 * means that we need to destroy req ourselves.
 	 */
-	if (ret)
-		goto out_put_req;
-	return 0;
+	if (!ret)
+		return 0;
+
 out_put_req:
 	if (req->ki_eventfd)
 		eventfd_ctx_put(req->ki_eventfd);
-	iocb_put(req);
+	iocb_destroy(req);
 out_put_reqs_available:
 	put_reqs_available(ctx, 1);
 	return ret;


