Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83E53834E6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbhEQPNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243655AbhEQPLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75030616EC;
        Mon, 17 May 2021 14:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261859;
        bh=DRF2xxxVxTcryOxi5DlOs877XO+fhe8mU3b1Cd34yGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vI95srweTHwdRE8B8FKMy6hD9fh1BZyN7R7V4g8ZES1GjCRq4QcCdFRhMnTPP46le
         QNrRIKReKmo9+eioTc1+UIR93Ad0qNCy13dA/rc0t6v/GVBVjNlusinfsKE/iFcXis
         I2dxvLYbXJMWvvYedBWdDccsXLevWX1nqZcJGQvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>,
        Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 101/141] userfaultfd: release page in error path to avoid BUG_ON
Date:   Mon, 17 May 2021 16:02:33 +0200
Message-Id: <20210517140246.180508390@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>

commit 7ed9d238c7dbb1fdb63ad96a6184985151b0171c upstream.

Consider the following sequence of events:

1. Userspace issues a UFFD ioctl, which ends up calling into
   shmem_mfill_atomic_pte(). We successfully account the blocks, we
   shmem_alloc_page(), but then the copy_from_user() fails. We return
   -ENOENT. We don't release the page we allocated.
2. Our caller detects this error code, tries the copy_from_user() after
   dropping the mmap_lock, and retries, calling back into
   shmem_mfill_atomic_pte().
3. Meanwhile, let's say another process filled up the tmpfs being used.
4. So shmem_mfill_atomic_pte() fails to account blocks this time, and
   immediately returns - without releasing the page.

This triggers a BUG_ON in our caller, which asserts that the page
should always be consumed, unless -ENOENT is returned.

To fix this, detect if we have such a "dangling" page when accounting
fails, and if so, release it before returning.

Link: https://lkml.kernel.org/r/20210428230858.348400-1-axelrasmussen@google.com
Fixes: cb658a453b93 ("userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2327,8 +2327,18 @@ static int shmem_mfill_atomic_pte(struct
 	pgoff_t offset, max_off;
 
 	ret = -ENOMEM;
-	if (!shmem_inode_acct_block(inode, 1))
+	if (!shmem_inode_acct_block(inode, 1)) {
+		/*
+		 * We may have got a page, returned -ENOENT triggering a retry,
+		 * and now we find ourselves with -ENOMEM. Release the page, to
+		 * avoid a BUG_ON in our caller.
+		 */
+		if (unlikely(*pagep)) {
+			put_page(*pagep);
+			*pagep = NULL;
+		}
 		goto out;
+	}
 
 	if (!*pagep) {
 		page = shmem_alloc_page(gfp, info, pgoff);


