Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C53D5FCF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbhGZPTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236404AbhGZPSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF7160FC2;
        Mon, 26 Jul 2021 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315156;
        bh=qj1s6WAPiwYljmjanr4iEukXgVMG+2Tt9T6QjPUJxLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4+oOVpp+OD0wLeD/9NTCmsNwK4djQ23YVnSzX0sXY2UaowVG1xyLZLggSLQCcX7c
         6qRchkfF2L7eePgzgv8Y0VRiN8gIbYTClErUxATKytKSkknfKb+wfZNdM4vNrOWvyi
         C5C/XgtO2U3Ow6mmXVaBWqwI2TMWX8xcEVmGpdog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alistair Delva <adelva@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        William McVicker <willmcvicker@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 095/108] userfaultfd: do not untag user pointers
Date:   Mon, 26 Jul 2021 17:39:36 +0200
Message-Id: <20210726153834.730063469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit e71e2ace5721a8b921dca18b045069e7bb411277 upstream.

Patch series "userfaultfd: do not untag user pointers", v5.

If a user program uses userfaultfd on ranges of heap memory, it may end
up passing a tagged pointer to the kernel in the range.start field of
the UFFDIO_REGISTER ioctl.  This can happen when using an MTE-capable
allocator, or on Android if using the Tagged Pointers feature for MTE
readiness [1].

When a fault subsequently occurs, the tag is stripped from the fault
address returned to the application in the fault.address field of struct
uffd_msg.  However, from the application's perspective, the tagged
address *is* the memory address, so if the application is unaware of
memory tags, it may get confused by receiving an address that is, from
its point of view, outside of the bounds of the allocation.  We observed
this behavior in the kselftest for userfaultfd [2] but other
applications could have the same problem.

Address this by not untagging pointers passed to the userfaultfd ioctls.
Instead, let the system call fail.  Also change the kselftest to use
mmap so that it doesn't encounter this problem.

[1] https://source.android.com/devices/tech/debug/tagged-pointers
[2] tools/testing/selftests/vm/userfaultfd.c

This patch (of 2):

Do not untag pointers passed to the userfaultfd ioctls.  Instead, let
the system call fail.  This will provide an early indication of problems
with tag-unaware userspace code instead of letting the code get confused
later, and is consistent with how we decided to handle brk/mmap/mremap
in commit dcde237319e6 ("mm: Avoid creating virtual address aliases in
brk()/mmap()/mremap()"), as well as being consistent with the existing
tagged address ABI documentation relating to how ioctl arguments are
handled.

The code change is a revert of commit 7d0325749a6c ("userfaultfd: untag
user pointers") plus some fixups to some additional calls to
validate_range that have appeared since then.

[1] https://source.android.com/devices/tech/debug/tagged-pointers
[2] tools/testing/selftests/vm/userfaultfd.c

Link: https://lkml.kernel.org/r/20210714195437.118982-1-pcc@google.com
Link: https://lkml.kernel.org/r/20210714195437.118982-2-pcc@google.com
Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Delva <adelva@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mitch Phillips <mitchp@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: William McVicker <willmcvicker@google.com>
Cc: <stable@vger.kernel.org>	[5.4]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/tagged-address-abi.rst |   26 ++++++++++++++++++--------
 fs/userfaultfd.c                           |   22 ++++++++++------------
 2 files changed, 28 insertions(+), 20 deletions(-)

--- a/Documentation/arm64/tagged-address-abi.rst
+++ b/Documentation/arm64/tagged-address-abi.rst
@@ -45,14 +45,24 @@ how the user addresses are used by the k
 
 1. User addresses not accessed by the kernel but used for address space
    management (e.g. ``mprotect()``, ``madvise()``). The use of valid
-   tagged pointers in this context is allowed with the exception of
-   ``brk()``, ``mmap()`` and the ``new_address`` argument to
-   ``mremap()`` as these have the potential to alias with existing
-   user addresses.
-
-   NOTE: This behaviour changed in v5.6 and so some earlier kernels may
-   incorrectly accept valid tagged pointers for the ``brk()``,
-   ``mmap()`` and ``mremap()`` system calls.
+   tagged pointers in this context is allowed with these exceptions:
+
+   - ``brk()``, ``mmap()`` and the ``new_address`` argument to
+     ``mremap()`` as these have the potential to alias with existing
+      user addresses.
+
+     NOTE: This behaviour changed in v5.6 and so some earlier kernels may
+     incorrectly accept valid tagged pointers for the ``brk()``,
+     ``mmap()`` and ``mremap()`` system calls.
+
+   - The ``range.start``, ``start`` and ``dst`` arguments to the
+     ``UFFDIO_*`` ``ioctl()``s used on a file descriptor obtained from
+     ``userfaultfd()``, as fault addresses subsequently obtained by reading
+     the file descriptor will be untagged, which may otherwise confuse
+     tag-unaware programs.
+
+     NOTE: This behaviour changed in v5.14 and so some earlier kernels may
+     incorrectly accept valid tagged pointers for this system call.
 
 2. User addresses accessed by the kernel (e.g. ``write()``). This ABI
    relaxation is disabled by default and the application thread needs to
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1272,23 +1272,21 @@ static __always_inline void wake_userfau
 }
 
 static __always_inline int validate_range(struct mm_struct *mm,
-					  __u64 *start, __u64 len)
+					  __u64 start, __u64 len)
 {
 	__u64 task_size = mm->task_size;
 
-	*start = untagged_addr(*start);
-
-	if (*start & ~PAGE_MASK)
+	if (start & ~PAGE_MASK)
 		return -EINVAL;
 	if (len & ~PAGE_MASK)
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (*start < mmap_min_addr)
+	if (start < mmap_min_addr)
 		return -EINVAL;
-	if (*start >= task_size)
+	if (start >= task_size)
 		return -EINVAL;
-	if (len > task_size - *start)
+	if (len > task_size - start)
 		return -EINVAL;
 	return 0;
 }
@@ -1338,7 +1336,7 @@ static int userfaultfd_register(struct u
 		goto out;
 	}
 
-	ret = validate_range(mm, &uffdio_register.range.start,
+	ret = validate_range(mm, uffdio_register.range.start,
 			     uffdio_register.range.len);
 	if (ret)
 		goto out;
@@ -1527,7 +1525,7 @@ static int userfaultfd_unregister(struct
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
 		goto out;
 
-	ret = validate_range(mm, &uffdio_unregister.start,
+	ret = validate_range(mm, uffdio_unregister.start,
 			     uffdio_unregister.len);
 	if (ret)
 		goto out;
@@ -1678,7 +1676,7 @@ static int userfaultfd_wake(struct userf
 	if (copy_from_user(&uffdio_wake, buf, sizeof(uffdio_wake)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_wake.start, uffdio_wake.len);
+	ret = validate_range(ctx->mm, uffdio_wake.start, uffdio_wake.len);
 	if (ret)
 		goto out;
 
@@ -1718,7 +1716,7 @@ static int userfaultfd_copy(struct userf
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_copy.dst, uffdio_copy.len);
+	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
 	if (ret)
 		goto out;
 	/*
@@ -1774,7 +1772,7 @@ static int userfaultfd_zeropage(struct u
 			   sizeof(uffdio_zeropage)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_zeropage.range.start,
+	ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
 			     uffdio_zeropage.range.len);
 	if (ret)
 		goto out;


