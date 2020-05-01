Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89481C1586
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgEAN3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgEAN3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:29:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3B53208C3;
        Fri,  1 May 2020 13:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339788;
        bh=O3QIexIeqU5P2QEyxwjjbx+5fccgxwre6dJpMsJdDm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK/2zhQiJnVb7CAZRWDUYETnOMT69imq8AhjVBgRvY/3fBkm+Gs3SAnqKb7xLlUhS
         A2LLlhzx+66ndq7YAPYKqcrpSMHIq5W2L8VXorJKeMCArYnRGt2ReW/luRg6ac6eDf
         AoEr8S8/eoP5iWL1zOUP8fKbVIeVQbDKg7eUs0s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 60/80] fuse: fix possibly missed wake-up after abort
Date:   Fri,  1 May 2020 15:21:54 +0200
Message-Id: <20200501131531.407149934@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 2d84a2d19b6150c6dbac1e6ebad9c82e4c123772 upstream.

In current fuse_drop_waiting() implementation it's possible that
fuse_wait_aborted() will not be woken up in the unlikely case that
fuse_abort_conn() + fuse_wait_aborted() runs in between checking
fc->connected and calling atomic_dec(&fc->num_waiting).

Do the atomic_dec_and_test() unconditionally, which also provides the
necessary barrier against reordering with the fc->connected check.

The explicit smp_mb() in fuse_wait_aborted() is not actually needed, since
the spin_unlock() in fuse_abort_conn() provides the necessary RELEASE
barrier after resetting fc->connected.  However, this is not a performance
sensitive path, and adding the explicit barrier makes it easier to
document.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: b8f95e5d13f5 ("fuse: umount should wait for all requests")
Cc: <stable@vger.kernel.org> #v4.19
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -132,9 +132,13 @@ static bool fuse_block_alloc(struct fuse
 
 static void fuse_drop_waiting(struct fuse_conn *fc)
 {
-	if (fc->connected) {
-		atomic_dec(&fc->num_waiting);
-	} else if (atomic_dec_and_test(&fc->num_waiting)) {
+	/*
+	 * lockess check of fc->connected is okay, because atomic_dec_and_test()
+	 * provides a memory barrier mached with the one in fuse_wait_aborted()
+	 * to ensure no wake-up is missed.
+	 */
+	if (atomic_dec_and_test(&fc->num_waiting) &&
+	    !READ_ONCE(fc->connected)) {
 		/* wake up aborters */
 		wake_up_all(&fc->blocked_waitq);
 	}
@@ -2164,6 +2168,8 @@ EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
 void fuse_wait_aborted(struct fuse_conn *fc)
 {
+	/* matches implicit memory barrier in fuse_drop_waiting() */
+	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
 }
 


