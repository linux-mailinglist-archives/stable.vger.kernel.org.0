Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC02387F90
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 20:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344485AbhERS0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 14:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242486AbhERS0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 14:26:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DCC6124C;
        Tue, 18 May 2021 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621362318;
        bh=HPafWqI9ZsTI+LEyyzQR9z+ZjKpwuru7KzVHiF25j9E=;
        h=Date:From:To:Subject:From;
        b=hlXWThMLGD2eBfR6k3c59VfniTZu2WbKYvhd5/duUEPiv0OvpXPiMTSwcxacOjeOd
         BI4MlHI4vdu/1b9Mc7KyfRNxeEbNdCvvzO9RP1OV5S7oPQaojrA+/S6DRTf1McXxEv
         YhmBmiEMPjtHpTKmYkzhwtqcSjItnyRNxqPc2Icg=
Date:   Tue, 18 May 2021 11:25:18 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, hughd@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        stable@vger.kernel.org
Subject:  [merged]
 userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch removed from
 -mm tree
Message-ID: <20210518182518.4by7Q4pDf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd: release page in error path to avoid BUG_ON
has been removed from the -mm tree.  Its filename was
     userfaultfd-release-page-in-error-path-to-avoid-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte.patch
userfaultfd-shmem-support-minor-fault-registration-for-shmem.patch
userfaultfd-shmem-support-uffdio_continue-for-shmem.patch
userfaultfd-shmem-advertise-shmem-minor-fault-support.patch
userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

