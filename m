Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFEE10EFB2
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 20:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfLBTBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 14:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbfLBTBf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 14:01:35 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F4B821774;
        Mon,  2 Dec 2019 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575313294;
        bh=nQ4IeKnwbdMEBhjVbm5AFpcM+nV6NqByl2EJeEQw28c=;
        h=Date:From:To:Subject:From;
        b=qRHskiz/bF1+ybNcEW3N+wX1a/HYFCMmbSzSJ/fufHbI8zUk2TFV3KpW/bIsNhVzc
         YBlOnDYW6EIl3h2RPD7OAdjjnpmySNr0PETTyUYh+VnhJ/Yd5tjtVSU7JkYI0eB68Y
         SG7sYMOHedpfkET2FKmwXKfG5oeskhK5frn3nIHo=
Date:   Mon, 02 Dec 2019 11:01:34 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, joel@joelfernandes.org,
        mm-commits@vger.kernel.org, ngeoffray@google.com, shuah@kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 memfd-fix-cow-issue-on-map_private-and-f_seal_future_write-mappings.patch
 removed from -mm tree
Message-ID: <20191202190134.225erV7jP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memfd: fix COW issue on MAP_PRIVATE and F_SEAL_FUTURE_WRITE mappings
has been removed from the -mm tree.  Its filename was
     memfd-fix-cow-issue-on-map_private-and-f_seal_future_write-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Geoffray <ngeoffray@google.com>
Subject: mm, memfd: fix COW issue on MAP_PRIVATE and F_SEAL_FUTURE_WRITE mappings

F_SEAL_FUTURE_WRITE has unexpected behavior when used with MAP_PRIVATE: A
private mapping created after the memfd file that gets sealed with
F_SEAL_FUTURE_WRITE loses the copy-on-write at fork behavior, meaning
children and parent share the same memory, even though the mapping is
private.

The reason for this is due to the code below:

static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
{
        struct shmem_inode_info *info = SHMEM_I(file_inode(file));

        if (info->seals & F_SEAL_FUTURE_WRITE) {
                /*
                 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
                 * "future write" seal active.
                 */
                if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
                        return -EPERM;

                /*
                 * Since the F_SEAL_FUTURE_WRITE seals allow for a MAP_SHARED
                 * read-only mapping, take care to not allow mprotect to revert
                 * protections.
                 */
                vma->vm_flags &= ~(VM_MAYWRITE);
        }
        ...
}

And for the mm to know if a mapping is copy-on-write:

static inline bool is_cow_mapping(vm_flags_t flags)
{
        return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
}

The patch fixes the issue by making the mprotect revert protection happen
only for shared mappings.  For private mappings, using mprotect will have
no effect on the seal behavior.

The F_SEAL_FUTURE_WRITE feature was introduced in v5.1 so v5.3.x stable
kernels would need a backport.

[akpm@linux-foundation.org: reflow comment, per Christoph]
Link: http://lkml.kernel.org/r/20191107195355.80608-1-joel@joelfernandes.org
Fixes: ab3948f58ff84 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Signed-off-by: Nicolas Geoffray <ngeoffray@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~memfd-fix-cow-issue-on-map_private-and-f_seal_future_write-mappings
+++ a/mm/shmem.c
@@ -2214,11 +2214,14 @@ static int shmem_mmap(struct file *file,
 			return -EPERM;
 
 		/*
-		 * Since the F_SEAL_FUTURE_WRITE seals allow for a MAP_SHARED
-		 * read-only mapping, take care to not allow mprotect to revert
-		 * protections.
+		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * MAP_SHARED and read-only, take care to not allow mprotect to
+		 * revert protections on such mappings. Do this only for shared
+		 * mappings. For private mappings, don't need to mask
+		 * VM_MAYWRITE as we still want them to be COW-writable.
 		 */
-		vma->vm_flags &= ~(VM_MAYWRITE);
+		if (vma->vm_flags & VM_SHARED)
+			vma->vm_flags &= ~(VM_MAYWRITE);
 	}
 
 	file_accessed(file);
_

Patches currently in -mm which might be from ngeoffray@google.com are


