Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36A3BEFA3
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 20:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhGGSqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 14:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhGGSqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 14:46:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69E1C061762
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 11:43:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t11-20020a056902124bb029055a821867baso17386847ybu.14
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 11:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fBecXpdoiWZRY4lnkZjFBk2ArEoGd2LP5hh3zPDWUYc=;
        b=K+LM7F0IB0aSYNtOvg0E9GvXKjCLql5DSPqjvVB86twQXXyF/q6PHxDdU+BFLULHal
         sadBOrS4uDhUi3ch0QwQHNPBTWqBtvn7g/9tCpsvnCthWK16fCqiUndoAyS08PGjQo6S
         2LBmWo+Mo4tbLwf8vdGc9MzdPAjGe1ayDo+fSkgL8CGutBMUW6MdTioWibNdlSj5eKsi
         jqRpLGtz+zlNzVV8jVz3wc4uU7vdEhNf5H9BoyOH0O15axjOZz9b1nCjjMgUprGCD7CN
         39vnltrjCKQfAZLxNBUfMsKbjjpOP84V3OLtSj+2LV1xEwNEpeOWu10XgJp+dXLWp34b
         ZFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fBecXpdoiWZRY4lnkZjFBk2ArEoGd2LP5hh3zPDWUYc=;
        b=K4eRzNl1lSLWhl7ag1iHUWdWosEH8TOsc3zSCEUDxYXuQIpPquWpydc97Dxna63vJU
         BrogDpIGNSFWHzQhnPn8LykFkUEE+tTkqh/+tYFOGZUgwKYhiqgsvZbfDKZpJSK/dZsD
         Arvq58E2iGrtWtdm9rYQpOeweNbr6IWfDD6dk7A2kNIHzIdMdEonhN5OAFXivvBPHrJC
         CeMCnSB4c8e+s7gRPiZUTSX8Lq33siTGH34NBBXCbrJz9MjnghzMuD/5PfqnfC0qaEho
         3Dpl2ASbVcQNJe+JOW0J94ZOnDD+81VFvXx51+CJ+BMFlALrM9VTVUqwIvO3wmQ6agVq
         Y/hA==
X-Gm-Message-State: AOAM530XoH1ANObRM1URjo9QgukigtFmP5hcMhqlThbfD1nSAX/MeYcY
        m2DGcplcOFce6auGvuhWi5dGbtU=
X-Google-Smtp-Source: ABdhPJzfsRJUloKscyxRckLCLZ2ozVeHI7bDJY4UJtahYxURZSftvGl/YpEKOwF+37yu/uiTBkRJFIw=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:3b71:8b83:5f3c:e3df])
 (user=pcc job=sendgmr) by 2002:a25:4095:: with SMTP id n143mr31599183yba.22.1625683400900;
 Wed, 07 Jul 2021 11:43:20 -0700 (PDT)
Date:   Wed,  7 Jul 2021 11:43:12 -0700
In-Reply-To: <20210707184313.3697385-1-pcc@google.com>
Message-Id: <20210707184313.3697385-2-pcc@google.com>
Mime-Version: 1.0
References: <20210707184313.3697385-1-pcc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v4 1/2] userfaultfd: do not untag user pointers
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
untag user pointers") plus some fixups to some additional calls to
validate_range that have appeared since then.

[1] https://source.android.com/devices/tech/debug/tagged-pointers
[2] tools/testing/selftests/vm/userfaultfd.c

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
Cc: <stable@vger.kernel.org> # 5.4
---
v4:
- document the changes more accurately
- fix new calls to validate_range

 Documentation/arm64/tagged-address-abi.rst | 26 +++++++++++++++-------
 fs/userfaultfd.c                           | 26 ++++++++++------------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/Documentation/arm64/tagged-address-abi.rst b/Documentation/arm64/tagged-address-abi.rst
index 459e6b66ff68..0c9120ec58ae 100644
--- a/Documentation/arm64/tagged-address-abi.rst
+++ b/Documentation/arm64/tagged-address-abi.rst
@@ -45,14 +45,24 @@ how the user addresses are used by the kernel:
 
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
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index dd7a6c62b56f..27af6b82a758 100644
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
@@ -1815,7 +1813,7 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 			   sizeof(struct uffdio_writeprotect)))
 		return -EFAULT;
 
-	ret = validate_range(ctx->mm, &uffdio_wp.range.start,
+	ret = validate_range(ctx->mm, uffdio_wp.range.start,
 			     uffdio_wp.range.len);
 	if (ret)
 		return ret;
@@ -1863,7 +1861,7 @@ static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 			   sizeof(uffdio_continue) - (sizeof(__s64))))
 		goto out;
 
-	ret = validate_range(ctx->mm, &uffdio_continue.range.start,
+	ret = validate_range(ctx->mm, uffdio_continue.range.start,
 			     uffdio_continue.range.len);
 	if (ret)
 		goto out;
-- 
2.32.0.93.g670b81a890-goog

