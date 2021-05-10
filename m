Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D963377B8F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 07:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJFeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 01:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhEJFet (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 01:34:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B770460FF2;
        Mon, 10 May 2021 05:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620624819;
        bh=gM/aJSbq3DQ9Rbro5Qyk0Iv2OGxSteSR9ZllfE5VKLk=;
        h=Date:From:To:Subject:From;
        b=S2WK7TZhwQK6tqS1fOrCl1TNb6cbGZXQRCEJ8IJ/qhP+fLyze+6DSNkVG7YeOsbjr
         VQYeZms+uEKK/MbCRkJR50LaMlOzACxhTt4JWUzT3VvbCXA5SqPVTiZJb5JG/MCm+g
         Nb0zIv+CRKUZvV4t0OjqDFLNhUyi9WsCyB5RNhFo=
Date:   Sun, 09 May 2021 22:33:39 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, hughd@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org
Subject:  +
 userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch added to -mm
 tree
Message-ID: <20210510053339.91US3w9Em%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd: release page in error path to avoid BUG_ON
has been added to the -mm tree.  Its filename is
     userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch
userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch
userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte.patch
userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch
userfaultfd-shmem-support-uffdio_continue-for-shmem.patch
userfaultfd-shmem-advertise-shmem-minor-fault-support.patch
userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

