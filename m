Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA043A2A2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhJYTuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238324AbhJYTsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F344161215;
        Mon, 25 Oct 2021 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190857;
        bh=t8BKmU5E84+0vPlygvz/cltHK0fjDdlKB+sWx8uD0eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUyTMaJ0NoHatPc8erKde/sFZescOKaqdOCRBvBwjRgS72h1nEX9uKSiyz8MHhwF6
         PwH7oTuPJLGPJhdDrHxSceNQBbT5+OPEvXjxeTpOLmaVRZ9nXxDUm688+EdLt4acKs
         LSmnQqckPnxDEqaNaRRo4H7sUQ8uhZFnhnnnnLhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Li Wang <liwan@redhat.com>, Li Wang <liwang@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 080/169] mm/userfaultfd: selftests: fix memory corruption with thp enabled
Date:   Mon, 25 Oct 2021 21:14:21 +0200
Message-Id: <20211025191027.481097506@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 8913970c19915bbe773d97d42989cd85b7fdc098 upstream.

In RHEL's gating selftests we've encountered memory corruption in the
uffd event test even with upstream kernel:

        # ./userfaultfd anon 128 4
        nr_pages: 32768, nr_pages_per_cpu: 32768
        bounces: 3, mode: rnd racing read, userfaults: 6240 missing (6240) 14729 wp (14729)
        bounces: 2, mode: racing read, userfaults: 1444 missing (1444) 28877 wp (28877)
        bounces: 1, mode: rnd read, userfaults: 6055 missing (6055) 14699 wp (14699)
        bounces: 0, mode: read, userfaults: 82 missing (82) 25196 wp (25196)
        testing uffd-wp with pagemap (pgsize=4096): done
        testing uffd-wp with pagemap (pgsize=2097152): done
        testing events (fork, remap, remove): ERROR: nr 32427 memory corruption 0 1 (errno=0, line=963)
        ERROR: faulting process failed (errno=0, line=1117)

It can be easily reproduced when global thp enabled, which is the
default for RHEL.

It's also known as a side effect of commit 0db282ba2c12 ("selftest: use
mmap instead of posix_memalign to allocate memory", 2021-07-23), which
is imho right itself on using mmap() to make sure the addresses will be
untagged even on arm.

The problem is, for each test we allocate buffers using two
allocate_area() calls.  We assumed these two buffers won't affect each
other, however they could, because mmap() could have found that the two
buffers are near each other and having the same VMA flags, so they got
merged into one VMA.

It won't be a big problem if thp is not enabled, but when thp is
agressively enabled it means when initializing the src buffer it could
accidentally setup part of the dest buffer too when there's a shared THP
that overlaps the two regions.  Then some of the dest buffer won't be
able to be trapped by userfaultfd missing mode, then it'll cause memory
corruption as described.

To fix it, do release_pages() after initializing the src buffer.

Since the previous two release_pages() calls are after
uffd_test_ctx_clear() which will unmap all the buffers anyway (which is
stronger than release pages; as unmap() also tear town pgtables), drop
them as they shouldn't really be anything useful.

We can mark the Fixes tag upon 0db282ba2c12 as it's reported to only
happen there, however the real "Fixes" IMHO should be 8ba6e8640844, as
before that commit we'll always do explicit release_pages() before
registration of uffd, and 8ba6e8640844 changed that logic by adding
extra unmap/map and we didn't release the pages at the right place.
Meanwhile I don't have a solid glue anyway on whether posix_memalign()
could always avoid triggering this bug, hence it's safer to attach this
fix to commit 8ba6e8640844.

Link: https://lkml.kernel.org/r/20210923232512.210092-1-peterx@redhat.com
Fixes: 8ba6e8640844 ("userfaultfd/selftests: reinitialize test context in each test")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1994931
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Li Wang <liwan@redhat.com>
Tested-by: Li Wang <liwang@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/userfaultfd.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -414,9 +414,6 @@ static void uffd_test_ctx_init_ext(uint6
 	uffd_test_ops->allocate_area((void **)&area_src);
 	uffd_test_ops->allocate_area((void **)&area_dst);
 
-	uffd_test_ops->release_pages(area_src);
-	uffd_test_ops->release_pages(area_dst);
-
 	userfaultfd_open(features);
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
@@ -437,6 +434,26 @@ static void uffd_test_ctx_init_ext(uint6
 		*(area_count(area_src, nr) + 1) = 1;
 	}
 
+	/*
+	 * After initialization of area_src, we must explicitly release pages
+	 * for area_dst to make sure it's fully empty.  Otherwise we could have
+	 * some area_dst pages be errornously initialized with zero pages,
+	 * hence we could hit memory corruption later in the test.
+	 *
+	 * One example is when THP is globally enabled, above allocate_area()
+	 * calls could have the two areas merged into a single VMA (as they
+	 * will have the same VMA flags so they're mergeable).  When we
+	 * initialize the area_src above, it's possible that some part of
+	 * area_dst could have been faulted in via one huge THP that will be
+	 * shared between area_src and area_dst.  It could cause some of the
+	 * area_dst won't be trapped by missing userfaults.
+	 *
+	 * This release_pages() will guarantee even if that happened, we'll
+	 * proactively split the thp and drop any accidentally initialized
+	 * pages within area_dst.
+	 */
+	uffd_test_ops->release_pages(area_dst);
+
 	pipefd = malloc(sizeof(int) * nr_cpus * 2);
 	if (!pipefd)
 		err("pipefd");


