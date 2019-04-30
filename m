Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC897F763
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfD3Lqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729801AbfD3Lql (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1439020449;
        Tue, 30 Apr 2019 11:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624800;
        bh=FIm/dYJUGKyWJsw104A+MAzQhk1rZCq5KdDwZvA7XWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrqnzOQDsqKywnEUQIQWFNkDE8jy72RjJClxU8pgTx/Na1bHaqO9aNDEfQxEsBo9v
         hCX4fjdg8FmNMFxiS6+CLxHwKmHoH67s5aeAqbkeopmlI1idpenUjFqukuqCmqrN/f
         SitCB+OS8t/dsZBNzrmqCmO8bw2bnc4aZeXN5AEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 076/100] aio: fold lookup_kiocb() into its sole caller
Date:   Tue, 30 Apr 2019 13:38:45 +0200
Message-Id: <20190430113612.324229328@linuxfoundation.org>
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

commit 833f4154ed560232120bc475935ee1d6a20e159f upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1992,24 +1992,6 @@ COMPAT_SYSCALL_DEFINE3(io_submit, compat
 }
 #endif
 
-/* lookup_kiocb
- *	Finds a given iocb for cancellation.
- */
-static struct aio_kiocb *
-lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb)
-{
-	struct aio_kiocb *kiocb;
-
-	assert_spin_locked(&ctx->ctx_lock);
-
-	/* TODO: use a hash or array, this sucks. */
-	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
-		if (kiocb->ki_user_iocb == iocb)
-			return kiocb;
-	}
-	return NULL;
-}
-
 /* sys_io_cancel:
  *	Attempts to cancel an iocb previously passed to io_submit.  If
  *	the operation is successfully cancelled, the resulting event is
@@ -2038,10 +2020,13 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->ctx_lock);
-	kiocb = lookup_kiocb(ctx, iocb);
-	if (kiocb) {
-		ret = kiocb->ki_cancel(&kiocb->rw);
-		list_del_init(&kiocb->ki_list);
+	/* TODO: use a hash or array, this sucks. */
+	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
+		if (kiocb->ki_user_iocb == iocb) {
+			ret = kiocb->ki_cancel(&kiocb->rw);
+			list_del_init(&kiocb->ki_list);
+			break;
+		}
 	}
 	spin_unlock_irq(&ctx->ctx_lock);
 


