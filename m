Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F0C3D6297
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhGZPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237751AbhGZPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18014604AC;
        Mon, 26 Jul 2021 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316193;
        bh=oXQPLTtnLwa4Q5l926i50RFNtfg8BEi86KK7K8/ySIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUqWnrXvlljbr0AWFTBvlY/zQ8/CST6ZSxjRGKUmVVzEh6R0L56cHW6WsXoZ0zV29
         s3fSlBX0miNwhvNoqOltcjFmd9vjSjGAwbjy9LhZJmsppBAu6b2dXidxZCgJAr7Ofl
         +uQ5Sg/M+oxgeG4pY1z+0/W6huTnsMFK772FWB9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 191/223] selftest: use mmap instead of posix_memalign to allocate memory
Date:   Mon, 26 Jul 2021 17:39:43 +0200
Message-Id: <20210726153852.445207631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 0db282ba2c12c1515d490d14a1ff696643ab0f1b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -197,8 +197,10 @@ static int anon_release_pages(char *rel_
 
 static void anon_allocate_area(void **alloc_area)
 {
-	if (posix_memalign(alloc_area, page_size, nr_pages * page_size)) {
-		fprintf(stderr, "out of memory\n");
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED)
+		fprintf(stderr, "mmap of anonymous memory failed");
 		*alloc_area = NULL;
 	}
 }


