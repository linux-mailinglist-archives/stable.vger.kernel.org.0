Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6644892CA
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbiAJHva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiAJHmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:42:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAE4C029820;
        Sun,  9 Jan 2022 23:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC04B81161;
        Mon, 10 Jan 2022 07:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75986C36AE9;
        Mon, 10 Jan 2022 07:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800103;
        bh=hGZoP9uw3DF1rXbfqgRNRdoKO70l4Df7FXUiLI2e/w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDJtod849dW0J2PTWE5/LPv/pXIPPV9Ot9kkfVFp+mH6IqXsnimEdrqNuNgNnYSpV
         pqn2g7AN4yBSC39fSBtKeRfaAR+PibJad5hG9JpZVCgKci4kZ1Qa2poR/K6pYqJbhs
         /9Y/lJnNopK2bEKfRWdatRZj3c0Xvohj7ylY/4es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 68/72] userfaultfd/selftests: fix hugetlb area allocations
Date:   Mon, 10 Jan 2022 08:23:45 +0100
Message-Id: <20220110071823.867961281@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit f5c73297181c6b3ad76537bad98eaad6d29b9333 ]

Currently, userfaultfd selftest for hugetlb as run from run_vmtests.sh
or any environment where there are 'just enough' hugetlb pages will
always fail with:

  testing events (fork, remap, remove):
		ERROR: UFFDIO_COPY error: -12 (errno=12, line=616)

The ENOMEM error code implies there are not enough hugetlb pages.
However, there are free hugetlb pages but they are all reserved.  There
is a basic problem with the way the test allocates hugetlb pages which
has existed since the test was originally written.

Due to the way 'cleanup' was done between different phases of the test,
this issue was masked until recently.  The issue was uncovered by commit
8ba6e8640844 ("userfaultfd/selftests: reinitialize test context in each
test").

For the hugetlb test, src and dst areas are allocated as PRIVATE
mappings of a hugetlb file.  This means that at mmap time, pages are
reserved for the src and dst areas.  At the start of event testing (and
other tests) the src area is populated which results in allocation of
huge pages to fill the area and consumption of reserves associated with
the area.  Then, a child is forked to fault in the dst area.  Note that
the dst area was allocated in the parent and hence the parent owns the
reserves associated with the mapping.  The child has normal access to
the dst area, but can not use the reserves created/owned by the parent.
Thus, if there are no other huge pages available allocation of a page
for the dst by the child will fail.

Fix by not creating reserves for the dst area.  In this way the child
can use free (non-reserved) pages.

Also, MAP_PRIVATE of a file only makes sense if you are interested in
the contents of the file before making a COW copy.  The test does not do
this.  So, just use MAP_ANONYMOUS | MAP_HUGETLB to create an anonymous
hugetlb mapping.  There is no need to create a hugetlb file in the
non-shared case.

Link: https://lkml.kernel.org/r/20211217172919.7861-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/userfaultfd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 60aa1a4fc69b6..81690f1737c80 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -86,7 +86,7 @@ static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int shm_fd;
-static int huge_fd;
+static int huge_fd = -1;	/* only used for hugetlb_shared test */
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
@@ -222,6 +222,9 @@ static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
 
 static void hugetlb_release_pages(char *rel_area)
 {
+	if (huge_fd == -1)
+		return;
+
 	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
 		      nr_pages * page_size))
@@ -234,16 +237,17 @@ static void hugetlb_allocate_area(void **alloc_area)
 	char **alloc_area_alias;
 
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
-			   MAP_HUGETLB,
-			   huge_fd, *alloc_area == area_src ? 0 :
-			   nr_pages * page_size);
+			   map_shared ? MAP_SHARED :
+			   MAP_PRIVATE | MAP_HUGETLB |
+			   (*alloc_area == area_src ? 0 : MAP_NORESERVE),
+			   huge_fd,
+			   *alloc_area == area_src ? 0 : nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
 		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_HUGETLB,
+				  MAP_SHARED,
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
 		if (area_alias == MAP_FAILED)
-- 
2.34.1



