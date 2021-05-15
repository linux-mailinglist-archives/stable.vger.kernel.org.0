Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1E3381491
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 02:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhEOA2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 20:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 20:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAEC61176;
        Sat, 15 May 2021 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038439;
        bh=KsHlOjWWpiWbhUWj38CsS3aihRqJiw43myh9AH5dSng=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t3f/TrCCXtal0pbeCTx/WmCrpSeCvvAIlJ/5ZFjnQ2enlcBkDGHY8Uk8Bdy/L1BCo
         NFVxEpjU3kDwmS//F12UAe/HwkXeAK9oC5D2J2sG/MsW6d9W6O/SXf1dqwj+QXeFmE
         RlOeO5JXkDJZnXYfaY1FzVXiQx5yBE+HpzdWLfz8=
Date:   Fri, 14 May 2021 17:27:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/13] userfaultfd: release page in error path to
 avoid BUG_ON
Message-ID: <20210515002719.QX9ZRXcYB%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: release page in error path to avoid BUG_ON

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
---

 mm/shmem.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~userfaultfd-release-page-in-error-path-to-avoid-bug_on
+++ a/mm/shmem.c
@@ -2361,8 +2361,18 @@ static int shmem_mfill_atomic_pte(struct
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
_
