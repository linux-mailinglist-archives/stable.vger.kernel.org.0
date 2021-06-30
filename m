Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217FF3B8AF4
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbhF3XcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 19:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbhF3XcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 19:32:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4863C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 16:29:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q10-20020a056902150ab02905592911c932so6099379ybu.15
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 16:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m3QHt0YaV5fjryby/2MOs6T0BSYeS4ijMoP6EpEmiUY=;
        b=rPLyKmZBxtqRERXPdQXxzJZE9F+DY5fNjbfpqhuPCRcD7bQHjOEWdTDJGRQb+Daj61
         aeZ/Jzv29QBiexXGsU5JV7G/rDglragkiYJzQpfDj2C/bcxb9IL8KZuYeGFi5ZC1fc4q
         p+9Bu72qvvMTvZ/WDr4iB2G0zd6nfEBpqP+XHnftZ7diT+1BJzQTZ5J+gLkuHFW49YY6
         mdzqdXCaxT/eWuomw+edYO5YuKTUYYGCO7njfde/lIXjZ7m5AFGMvtJhLTn4qiDcsveW
         y/ozXY6Ml9n4DomDarHY8zeZnszOXihGmJC8hRVD7mm8CpPdfot9r49srQZ+JqSLfgHW
         ajQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m3QHt0YaV5fjryby/2MOs6T0BSYeS4ijMoP6EpEmiUY=;
        b=qnxKx3VSiNZj0QnUbdg1FFsvMBvjS1HB91Nw3MvN+0pw2PAp4pXAlAWu+hArGrCiYd
         QxIZdHmG0w9OGiTcsGCggM+o2htZMVPXIrMGg0qEPQpv89Ep6LsBFuxTk+ePoxstDxDJ
         uGK1cnq9ycD4nCf87Crr/wywcJ+/UAeSGCwNC4fppVycXEJiOq2UVCIgcxi1T9j6ngrz
         +CTvTVGSlUsWIyFa/6gJiFnDXnsYPPvp5KZ7DuYSOebLGCDdBj6TIBQCOegLoTICGLLy
         iWAA3O0VQDO504kzprsZLoGn6UTv++2/SX055iiSnbuQOOkRhHAnalXGWGQ6RASITVWX
         3V8Q==
X-Gm-Message-State: AOAM533z+Un5YNImxtY5Z2LukfdQcgG5iiGegnBES+amK2bUJrztc3k0
        WgVR+RMWG4h385OGEZZ8UTiwPUs=
X-Google-Smtp-Source: ABdhPJylF+lGMZYBAXJptYRcMY9ADykrpjY8DwWNPnXoR7zBD/Kv81XSUa5vAPUhbyb8YZKflZcS4Ws=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:8b00:104d:c249:d343])
 (user=pcc job=sendgmr) by 2002:a25:6c54:: with SMTP id h81mr51586027ybc.184.1625095776874;
 Wed, 30 Jun 2021 16:29:36 -0700 (PDT)
Date:   Wed, 30 Jun 2021 16:29:31 -0700
Message-Id: <20210630232931.3779403-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2] userfaultfd: preserve user-supplied address tag in struct uffd_msg
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
        linux-mm@kvack.org, stable@vger.kernel.org
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

Fix this by remembering which tag was used to originally register the
userfaultfd and passing that tag back in fault.address. In a future
enhancement, we may want to pass back the original fault address,
but like SA_EXPOSE_TAGBITS, this should be guarded by a flag.

[1] https://source.android.com/devices/tech/debug/tagged-pointers
[2] tools/testing/selftests/vm/userfaultfd.c

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
Cc: <stable@vger.kernel.org> # 5.4
---
 Documentation/arm64/tagged-pointers.rst |  5 +++++
 fs/userfaultfd.c                        | 17 +++++++++++------
 include/linux/mm_types.h                |  3 ++-
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Documentation/arm64/tagged-pointers.rst b/Documentation/arm64/tagged-pointers.rst
index 19d284b70384..ec8e1f90b744 100644
--- a/Documentation/arm64/tagged-pointers.rst
+++ b/Documentation/arm64/tagged-pointers.rst
@@ -73,6 +73,11 @@ flag setting.
 Non-zero tags are never preserved in sigcontext.fault_address
 regardless of the SA_EXPOSE_TAGBITS flag setting.
 
+When using userfaultfd the address tag supplied in the range.start
+field of the UFFDIO_REGISTER ioctl is preserved and returned to
+userspace via the fault.address field of struct uffd_msg, and the
+tag of the original fault address is discarded.
+
 The architecture prevents the use of a tagged PC, so the upper byte will
 be set to a sign-extension of bit 55 on exception return.
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index dd7a6c62b56f..adb0f7d0638a 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -110,15 +110,15 @@ static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 	struct userfaultfd_wake_range *range = key;
 	int ret;
 	struct userfaultfd_wait_queue *uwq;
-	unsigned long start, len;
+	unsigned long start, len, addr;
 
 	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
 	ret = 0;
 	/* len == 0 means wake all */
 	start = range->start;
 	len = range->len;
-	if (len && (start > uwq->msg.arg.pagefault.address ||
-		    start + len <= uwq->msg.arg.pagefault.address))
+	addr = untagged_addr(uwq->msg.arg.pagefault.address);
+	if (len && (start > addr || start + len <= addr))
 		goto out;
 	WRITE_ONCE(uwq->waken, true);
 	/*
@@ -480,8 +480,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason,
-			ctx->features);
+	uwq.msg = userfault_msg(
+		vmf->address + vmf->vma->vm_userfaultfd_ctx.address_tag,
+		vmf->flags, reason, ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
@@ -1287,7 +1288,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	unsigned long vm_flags, new_flags;
 	bool found;
 	bool basic_ioctls;
-	unsigned long start, end, vma_end;
+	unsigned long address_tag, start, end, vma_end;
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1313,6 +1314,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		vm_flags |= VM_UFFD_MINOR;
 	}
 
+	address_tag = uffdio_register.range.start -
+		      untagged_addr(uffdio_register.range.start);
+
 	ret = validate_range(mm, &uffdio_register.range.start,
 			     uffdio_register.range.len);
 	if (ret)
@@ -1462,6 +1466,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 */
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx.ctx = ctx;
+		vma->vm_userfaultfd_ctx.address_tag = address_tag;
 
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8f0fb62e8975..cb93e5b17896 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -286,9 +286,10 @@ struct vm_region {
 };
 
 #ifdef CONFIG_USERFAULTFD
-#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) { NULL, })
+#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) { NULL, 0, })
 struct vm_userfaultfd_ctx {
 	struct userfaultfd_ctx *ctx;
+	unsigned long address_tag;
 };
 #else /* CONFIG_USERFAULTFD */
 #define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) {})
-- 
2.32.0.93.g670b81a890-goog

