Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97F10BF4E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbfK0UkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbfK0UkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28D71215A5;
        Wed, 27 Nov 2019 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887214;
        bh=Tk62XXmbAj7T/YAPVWiuez5jbTb0s9/iqhhmPflfepI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OS6JwdmB0lMsRodjQUnsuX6LVAV+zSwqkA627mhXTj2mhbm3+ZbogL7M6vUpGbxWv
         7zTZubF20qPqOU1T/DZoFMSCG87Nk+ek1PsKk6sk0K3zsdbXe2gOyRkpfI1zGPYUY1
         DQHH0jw3bwFzM0Ka4zsCa8BP7EK9p9rH1iC0JxD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 009/151] mm/ksm.c: dont WARN if page is still mapped in remove_stable_node()
Date:   Wed, 27 Nov 2019 21:29:52 +0100
Message-Id: <20191127203007.033795705@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 9a63236f1ad82d71a98aa80320b6cb618fb32f44 upstream.

It's possible to hit the WARN_ON_ONCE(page_mapped(page)) in
remove_stable_node() when it races with __mmput() and squeezes in
between ksm_exit() and exit_mmap().

  WARNING: CPU: 0 PID: 3295 at mm/ksm.c:888 remove_stable_node+0x10c/0x150

  Call Trace:
   remove_all_stable_nodes+0x12b/0x330
   run_store+0x4ef/0x7b0
   kernfs_fop_write+0x200/0x420
   vfs_write+0x154/0x450
   ksys_write+0xf9/0x1d0
   do_syscall_64+0x99/0x510
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Remove the warning as there is nothing scary going on.

Link: http://lkml.kernel.org/r/20191119131850.5675-1-aryabinin@virtuozzo.com
Fixes: cbf86cfe04a6 ("ksm: remove old stable nodes more thoroughly")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/ksm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -710,13 +710,13 @@ static int remove_stable_node(struct sta
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(page_mapped(page))) {
-		/*
-		 * This should not happen: but if it does, just refuse to let
-		 * merge_across_nodes be switched - there is no need to panic.
-		 */
-		err = -EBUSY;
-	} else {
+	/*
+	 * Page could be still mapped if this races with __mmput() running in
+	 * between ksm_exit() and exit_mmap(). Just refuse to let
+	 * merge_across_nodes/max_page_sharing be switched.
+	 */
+	err = -EBUSY;
+	if (!page_mapped(page)) {
 		/*
 		 * The stable node did not yet appear stale to get_ksm_page(),
 		 * since that allows for an unmapped ksm page to be recognized


