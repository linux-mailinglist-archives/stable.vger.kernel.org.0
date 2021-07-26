Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4CB3D55EA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhGZIMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhGZIMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F4260F22;
        Mon, 26 Jul 2021 08:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627289602;
        bh=/VCwI4NqBjFmF43yOza8Rss3YLh52jb57ebp1pK22k8=;
        h=Subject:To:Cc:From:Date:From;
        b=ztlfPzxUIuCQkVPT5P1btHWyXIPhqFPvBOQEVkUVI88ElhtmWgPl30YRzAL/WsUAH
         A3+FXNxc+C7C9/UctJoZ25VRR+pcdqUvXkRL1Y2liDLG9b0YNBWdM9Gs/w7r6gUbuf
         Ee0NwXaL82VXm3DUwOx2Pxo/X4mZcandTTY76C9U=
Subject: FAILED: patch "[PATCH] selftest: use mmap instead of posix_memalign to allocate" failed to apply to 4.4-stable tree
To:     pcc@google.com, Dave.Martin@arm.com, aarcange@redhat.com,
        adelva@google.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
        catalin.marinas@arm.com, eugenis@google.com,
        lokeshgidra@google.com, mitchp@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        will@kernel.org, willmcvicker@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:50:51 +0200
Message-ID: <162728945196198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0db282ba2c12c1515d490d14a1ff696643ab0f1b Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Fri, 23 Jul 2021 15:50:04 -0700
Subject: [PATCH] selftest: use mmap instead of posix_memalign to allocate
 memory

This test passes pointers obtained from anon_allocate_area to the
userfaultfd and mremap APIs.  This causes a problem if the system
allocator returns tagged pointers because with the tagged address ABI
the kernel rejects tagged addresses passed to these APIs, which would
end up causing the test to fail.  To make this test compatible with such
system allocators, stop using the system allocator to allocate memory in
anon_allocate_area, and instead just use mmap.

Link: https://lkml.kernel.org/r/20210714195437.118982-3-pcc@google.com
Link: https://linux-review.googlesource.com/id/Icac91064fcd923f77a83e8e133f8631c5b8fc241
Fixes: c47174fc362a ("userfaultfd: selftest")
Co-developed-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alistair Delva <adelva@google.com>
Cc: William McVicker <willmcvicker@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mitch Phillips <mitchp@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index e363bdaff59d..2ea438e6b8b1 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -210,8 +210,10 @@ static void anon_release_pages(char *rel_area)
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size))
-		err("posix_memalign() failed");
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED)
+		err("mmap of anonymous memory failed");
 }
 
 static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)

