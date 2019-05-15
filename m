Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF51F10E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfEOLUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730864AbfEOLUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:20:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C7E206BF;
        Wed, 15 May 2019 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919216;
        bh=SKZ9qeeTBySRAnlYi0jC94wl+mrFfYTefmuPbd65elQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EP862omoafKtwlaxxEZ0+a7vEx9nkVspr5CxNiDgfUAvzVdVTn3icChZA2K3PNr4
         6FmwVJTQB9DVV8OSXbtmrBt6grgGIUtUa2TN9HHwjyL4dqVmScJfiyzYgWerHJtKVk
         5Z6K1tluJa9cXXvml3owhVBJHawFuc7cYoqNgDok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 052/115] fuse: fix possibly missed wake-up after abort
Date:   Wed, 15 May 2019 12:55:32 +0200
Message-Id: <20190515090703.370416818@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2d84a2d19b6150c6dbac1e6ebad9c82e4c123772 ]

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
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/fuse/dev.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 770733106d6d4..c934fab444529 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -133,9 +133,13 @@ static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 
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
@@ -2170,6 +2174,8 @@ EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
 void fuse_wait_aborted(struct fuse_conn *fc)
 {
+	/* matches implicit memory barrier in fuse_drop_waiting() */
+	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
 }
 
-- 
2.20.1



