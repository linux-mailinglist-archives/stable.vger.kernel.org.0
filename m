Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70874F6A8
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbfD3Luk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbfD3Luj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D66072177B;
        Tue, 30 Apr 2019 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625038;
        bh=X5foVGflye9cJxsiqleKbMhbGXwsz1Zsd1/Sdea2fdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTUOq0PSTz0SkTnCTvr+KwrzW3C0BlBnCdze2V7pzVoDBI3274PfS9wd6ha9bQcAk
         3QoM7KCzkKx9qrQRrOYvLU2B488cgeJkvkam2qsCZYL6jr8sa0XiKIVoKsxGg9D6u/
         tN1hgLuHpkILhiK0d5lRG6hb1y1SXq4jaQ/nkY0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.0 67/89] aio: store event at final iocb_put()
Date:   Tue, 30 Apr 2019 13:38:58 +0200
Message-Id: <20190430113612.872379426@linuxfoundation.org>
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

commit 2bb874c0d873d13bd9b9b9c6d7b7c4edab18c8b4 upstream.

Instead of having aio_complete() set ->ki_res.{res,res2}, do that
explicitly in its callers, drop the reference (as aio_complete()
used to do) and delay the rest until the final iocb_put().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1077,16 +1077,10 @@ static inline void iocb_destroy(struct a
 	kmem_cache_free(kiocb_cachep, iocb);
 }
 
-static inline void iocb_put(struct aio_kiocb *iocb)
-{
-	if (refcount_dec_and_test(&iocb->ki_refcnt))
-		iocb_destroy(iocb);
-}
-
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  */
-static void aio_complete(struct aio_kiocb *iocb, long res, long res2)
+static void aio_complete(struct aio_kiocb *iocb)
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	struct aio_ring	*ring;
@@ -1094,8 +1088,6 @@ static void aio_complete(struct aio_kioc
 	unsigned tail, pos, head;
 	unsigned long	flags;
 
-	iocb->ki_res.res = res;
-	iocb->ki_res.res2 = res2;
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
 	 * ctx->completion_lock to prevent other code from messing with the tail
@@ -1161,7 +1153,14 @@ static void aio_complete(struct aio_kioc
 
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
-	iocb_put(iocb);
+}
+
+static inline void iocb_put(struct aio_kiocb *iocb)
+{
+	if (refcount_dec_and_test(&iocb->ki_refcnt)) {
+		aio_complete(iocb);
+		iocb_destroy(iocb);
+	}
 }
 
 /* aio_read_events_ring
@@ -1435,7 +1434,9 @@ static void aio_complete_rw(struct kiocb
 		file_end_write(kiocb->ki_filp);
 	}
 
-	aio_complete(iocb, res, res2);
+	iocb->ki_res.res = res;
+	iocb->ki_res.res2 = res2;
+	iocb_put(iocb);
 }
 
 static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
@@ -1583,11 +1584,10 @@ static ssize_t aio_write(struct kiocb *r
 
 static void aio_fsync_work(struct work_struct *work)
 {
-	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
-	int ret;
+	struct aio_kiocb *iocb = container_of(work, struct aio_kiocb, fsync.work);
 
-	ret = vfs_fsync(req->file, req->datasync);
-	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
+	iocb->ki_res.res = vfs_fsync(iocb->fsync.file, iocb->fsync.datasync);
+	iocb_put(iocb);
 }
 
 static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
@@ -1608,7 +1608,8 @@ static int aio_fsync(struct fsync_iocb *
 
 static inline void aio_poll_complete(struct aio_kiocb *iocb, __poll_t mask)
 {
-	aio_complete(iocb, mangle_poll(mask), 0);
+	iocb->ki_res.res = mangle_poll(mask);
+	iocb_put(iocb);
 }
 
 static void aio_poll_complete_work(struct work_struct *work)


