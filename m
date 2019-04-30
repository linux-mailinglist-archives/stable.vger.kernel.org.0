Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAFF762
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfD3Lqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730581AbfD3Lqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CB902173E;
        Tue, 30 Apr 2019 11:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624798;
        bh=7i0qbDAAVK4UIM2Ubwq1gfN+7iNggbZzTIJc5cVSH1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkMGR735q05dA9wPIvQuryNVprGlHXcN1WlXn+5csN3hmTx86vcpcmNopXUSfWDQ5
         Jkm88VUPzbaFQPS5UCeVDLu5IbMVFZhTtqgoVwOfR0MJBCrMYulj2/qT/yxg+ZjihE
         5q0xUIsx0e7WRlowmswcOesn7DabZkDr7v4i50Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 075/100] pin iocb through aio.
Date:   Tue, 30 Apr 2019 13:38:44 +0200
Message-Id: <20190430113612.273058889@linuxfoundation.org>
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
@@ -1016,6 +1016,9 @@ static bool get_reqs_available(struct ki
 /* aio_get_req
  *	Allocate a slot for an aio request.
  * Returns NULL if no requests are free.
+ *
+ * The refcount is initialized to 2 - one for the async op completion,
+ * one for the synchronous code that does this.
  */
 static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
 {
@@ -1028,7 +1031,7 @@ static inline struct aio_kiocb *aio_get_
 	percpu_ref_get(&ctx->reqs);
 	req->ki_ctx = ctx;
 	INIT_LIST_HEAD(&req->ki_list);
-	refcount_set(&req->ki_refcnt, 0);
+	refcount_set(&req->ki_refcnt, 2);
 	req->ki_eventfd = NULL;
 	return req;
 }
@@ -1061,15 +1064,18 @@ out:
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
@@ -1743,9 +1749,6 @@ static ssize_t aio_poll(struct aio_kiocb
 	INIT_LIST_HEAD(&req->wait.entry);
 	init_waitqueue_func_entry(&req->wait, aio_poll_wake);
 
-	/* one for removal from waitqueue, one for this function */
-	refcount_set(&aiocb->ki_refcnt, 2);
-
 	mask = vfs_poll(req->file, &apt.pt) & req->events;
 	if (unlikely(!req->head)) {
 		/* we did not manage to set up a waitqueue, done */
@@ -1776,7 +1779,6 @@ out:
 
 	if (mask)
 		aio_poll_complete(aiocb, mask);
-	iocb_put(aiocb);
 	return 0;
 }
 
@@ -1867,18 +1869,21 @@ static int __io_submit_one(struct kioctx
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


