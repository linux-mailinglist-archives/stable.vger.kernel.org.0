Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E43D4317
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 00:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhGWWJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 18:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGWWJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 18:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F8860EB5;
        Fri, 23 Jul 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627080605;
        bh=0y/+0uE1HjhZS70mVxDmV/xT3KMhjnogjh4zfjnr7IU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yKvQ744TsnZLBGGY97tgFVU/ULcKVTeVzuBpqRYbZUdKI4jaTEUtWapcrdSPYhSO5
         3Pth/H/9U09oh1oF09UGL72EMEEIxxTOuFkLuAD4EaA+2/USQ1K3pGg0Q34wS/WWCE
         +mX765pTaTvqE5PjanSYdE0UMHVzRhwMi8u4/pho=
Date:   Fri, 23 Jul 2021 15:50:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adelva@google.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, catalin.marinas@arm.com, Dave.Martin@arm.com,
        eugenis@google.com, linux-mm@kvack.org, lokeshgidra@google.com,
        mitchp@google.com, mm-commits@vger.kernel.org, pcc@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org, willmcvicker@google.com
Subject:  [patch 02/15] selftest: use mmap instead of
 posix_memalign to allocate memory
Message-ID: <20210723225004.VMRataLna%akpm@linux-foundation.org>
In-Reply-To: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: selftest: use mmap instead of posix_memalign to allocate memory

This test passes pointers obtained from anon_allocate_area to the
userfaultfd and mremap APIs.  This causes a problem if the system
allocator returns tagged pointers because with the tagged address ABI the
kernel rejects tagged addresses passed to these APIs, which would end up
causing the test to fail.  To make this test compatible with such system
allocators, stop using the system allocator to allocate memory in
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
---

 tools/testing/selftests/vm/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftest-use-mmap-instead-of-posix_memalign-to-allocate-memory
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -210,8 +210,10 @@ static void anon_release_pages(char *rel
 
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
_
