Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421594835C5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiACRaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 12:30:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38178 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiACRaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 12:30:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419ABB81042;
        Mon,  3 Jan 2022 17:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AFBC36AEB;
        Mon,  3 Jan 2022 17:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231001;
        bh=hGZoP9uw3DF1rXbfqgRNRdoKO70l4Df7FXUiLI2e/w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSNH0UkV1MmXnLIPMf7A8fotIZ7yaDMhrVummbZo+1BGLan/M4Hb5eA96N++qY7XX
         gi8XyI18QOuG/+dwtEnnWNNWd94aSTlXs5TzG/bALo6IGYrX2AZZBsED9HaJ0GG01p
         sFTosrxwchNLNpBEtXm4Bd0fJ5SkJm5+ePKCzfn+5rHb2uN29/ZSy+0Tlt1J8g1bq6
         o6VoZu5Z0HtQBOZCd650UTcPqTnhLNFHyD5gwFokhYXiSOKrwBXs7h1pGEwTZ2mPI7
         D3GGpWyzkdQB+OieaxTGWsYgw20J+yLMBAPgzotdPZ3va636xV9juK1yngRqv9YEfj
         p1h9XInp2Ce8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/16] userfaultfd/selftests: fix hugetlb area allocations
Date:   Mon,  3 Jan 2022 12:28:49 -0500
Message-Id: <20220103172849.1612731-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

