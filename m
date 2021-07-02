Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A036F3BA626
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 00:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhGBW7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 18:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhGBW7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 18:59:51 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66B8C061762
        for <stable@vger.kernel.org>; Fri,  2 Jul 2021 15:57:17 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id 5-20020ad45b850000b02902986d9b7d2fso7140712qvp.15
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 15:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eD/aaF0+/ogeXZeNjhDOEniG4W67mBj100J0eAxvQ+U=;
        b=lGixFLToeD1HCgLYbj4zld5OKHRt6Gj/QGs1cGV1l7z2nVvMnIApVsC9qcAN1YXOC6
         y+G0luXpsadhVbnumJ9zn+n30sMmF5eRkxdgk+NdMZ4flxdzPj0TFBoc1vlQfX8euPLR
         GphDdbYtHfsc6HSLjooOXKGJTwKR2yQ507LS+sLu+1H352oARcmwRukhizurj28zW8Xt
         LeGMfjTbcmeh0GsdKD3bYdMFU3FtQJs4Nl2BaR6LzQxgqmKk86NSmmG7As0YqN5l1j0D
         LECZgY4lBw7bRZvj5GG5t60ZvMqmRdtznuAhraS28IDlFNvqQn8c4HexnPm0ylIN65yR
         3k1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eD/aaF0+/ogeXZeNjhDOEniG4W67mBj100J0eAxvQ+U=;
        b=YgpRwpS+679DctuK6fIAAo9xqX+Ma5uzqqfhv9lhBB1P4V23vodgdwOGRCwu6bLkw/
         poW0RKLlKEYZqkil0BuWTGNIvS/8ebVjSxA1G9CTiwd8p7inMvxCrNurjqDRtkx9w+vB
         uY2WRDybOYWCQr29FezAnmWaJQweF6qzXEeLlYK21fJzYMZKBrhsy2GUOg6BHV9wGDlp
         /yt6vPHzrJIcAnEnGTALWnzq71OvvEqBfjOgWQUBJzw5nx2DCgCVAYZujcj5dpOg/tcM
         eKF5TL81lPIhm78y8e+zlsKt8AmeoxFgQfYLpDW5ugw0qoG4azr8/B0C5km0X6khlr8I
         1S2A==
X-Gm-Message-State: AOAM530+qZg+T0Ulys1JK3NgB4IVYajBWd+Qd5wfCuME/ZaXH9Cbg1w9
        wpZn14XEQplsbXf1zcM2yjdfoeg=
X-Google-Smtp-Source: ABdhPJwqb2avj7yI+m+Fn5WehCafNibnnB9vG8LmiHheaxe5O83a4qAJ7H3M/RW7cRnyoFEp8B5LMXo=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7c5b:5407:a2db:c8fb])
 (user=pcc job=sendgmr) by 2002:ad4:50c5:: with SMTP id e5mr1779283qvq.40.1625266636905;
 Fri, 02 Jul 2021 15:57:16 -0700 (PDT)
Date:   Fri,  2 Jul 2021 15:57:04 -0700
In-Reply-To: <20210702225705.2477947-1-pcc@google.com>
Message-Id: <20210702225705.2477947-2-pcc@google.com>
Mime-Version: 1.0
References: <20210702225705.2477947-1-pcc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 1/2] userfaultfd: do not untag user pointers
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Alistair Delva <adelva@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a user program uses userfaultfd on ranges of heap memory, it may
end up passing a tagged pointer to the kernel in the range.start
field of the UFFDIO_REGISTER ioctl. This can happen when using an
MTE-capable allocator, or on Android if using the Tagged Pointers
feature for MTE readiness [1].

When a fault subsequently occurs, the tag is stripped from the fault
address returned to the application in the fault.address field
of struct uffd_msg. However, from the application's perspective,
the tagged address *is* the memory address, so if the application
is unaware of memory tags, it may get confused by receiving an
address that is, from its point of view, outside of the bounds of the
allocation. We observed this behavior in the kselftest for userfaultfd
[2] but other applications could have the same problem.

Address this by not untagging pointers passed to the userfaultfd
ioctls. Instead, let the system call fail. This will provide an
early indication of problems with tag-unaware userspace code instead
of letting the code get confused later, and is consistent with how
we decided to handle brk/mmap/mremap in commit dcde237319e6 ("mm:
Avoid creating virtual address aliases in brk()/mmap()/mremap()"),
as well as being consistent with the existing tagged address ABI
documentation relating to how ioctl arguments are handled.

The code change is a revert of commit 7d0325749a6c ("userfaultfd:
untag user pointers").

[1] https://source.android.com/devices/tech/debug/tagged-pointers
[2] tools/testing/selftests/vm/userfaultfd.c

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
Cc: <stable@vger.kernel.org> # 5.4
---
 Documentation/arm64/tagged-address-abi.rst | 25 +++++++++++++++-------
 fs/userfaultfd.c                           | 22 +++++++++----------
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/Documentation/arm64/tagged-address-abi.rst b/Documentation/arm64/tagged-address-abi.rst
index 459e6b66ff68..737f9d8565a2 100644
--- a/Documentation/arm64/tagged-address-abi.rst
+++ b/Documentation/arm64/tagged-address-abi.rst
@@ -45,14 +45,23 @@ how the user addresses are used by the kernel:
 
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
+   - The ``range.start`` argument to the ``UFFDIO_REGISTER`` ``ioctl()``
+     used on a file descriptor obtained from ``userfaultfd()``, as
+     fault addresses subsequently obtained by reading the file descriptor
+     will be untagged, which may otherwise confuse tag-unaware programs.
+
+     NOTE: This behaviour changed in v5.14 and so some earlier kernels may
+     incorrectly accept valid tagged pointers for this system call.
 
 2. User addresses accessed by the kernel (e.g. ``write()``). This ABI
    relaxation is disabled by default and the application thread needs to
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index dd7a6c62b56f..7613efe002c1 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1236,23 +1236,21 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
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
@@ -1313,7 +1311,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		vm_flags |= VM_UFFD_MINOR;
 	}
 
-	ret = validate_range(mm, &uffdio_register.range.start,
+	ret = validate_range(mm, uffdio_register.range.start,
 			     uffdio_register.range.len);
 	if (ret)
 		goto out;
@@ -1519,7 +1517,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
 		goto out;
 
-	ret = validate_range(mm, &uffdio_unregister.start,
+	ret = validate_range(mm, uffdio_unregister.start,
 			     uffdio_unregister.len);
 	if (ret)
 		goto out;
@@ -1668,7 +1666,7 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_wake, buf, sizeof(uffdio_wake)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_wake.start, uffdio_wake.len);
+	ret = validate_range(ctx->mm, uffdio_wake.start, uffdio_wake.len);
 	if (ret)
 		goto out;
 
@@ -1708,7 +1706,7 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 			   sizeof(uffdio_copy)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_copy.dst, uffdio_copy.len);
+	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
 	if (ret)
 		goto out;
 	/*
@@ -1765,7 +1763,7 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 			   sizeof(uffdio_zeropage)-sizeof(__s64)))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_zeropage.range.start,
+	ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
 			     uffdio_zeropage.range.len);
 	if (ret)
 		goto out;
-- 
2.32.0.93.g670b81a890-goog

