Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B4519BAE3
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 06:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgDBEK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 00:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8045F2074D;
        Thu,  2 Apr 2020 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585800625;
        bh=k9o3gGz2f1GvRMFtNyQllPEX5z9bwFsGxQAhbsAMPcA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BruWMi5c3eQVUBb9PjaIFmAWs+DmGzHf6vLJ/8Nv6MV3V4udzUaml8BcgCBg3U3s9
         4PheG/Zq/WyHJ4ljUviL1Ztk5/9J7G5CM73tm1x4UF19eBDLt1IlmJuoBoal4ZmhPA
         5UUhVEjg2rQ3A4c8Rw0hjDfcjWAMqcLN9lBVN+/o=
Date:   Wed, 01 Apr 2020 21:10:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aquini@redhat.com, emunson@akamai.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shuah@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 127/155] selftests: vm: drop dependencies on page
 flags from mlock2 tests
Message-ID: <20200402041025.39b--EZsz%akpm@linux-foundation.org>
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: selftests: vm: drop dependencies on page flags from mlock2 tests

It was noticed that mlock2 tests are failing after 9c4e6b1a7027f ("mm,
mlock, vmscan: no more skipping pagevecs") because the patch has changed
the timing on when the page is added to the unevictable LRU list and thus
gains the unevictable page flag.

The test was just too dependent on the implementation details which were
true at the time when it was introduced.  Page flags and the timing when
they are set is something no userspace should ever depend on.  The test
should be testing only for the user observable contract of the tested
syscalls.  Those are defined pretty well for the mlock and there are other
means for testing them.  In fact this is already done and testing for page
flags can be safely dropped to achieve the aimed purpose.  Present bits
can be checked by /proc/<pid>/smaps RSS field and the locking state by
VmFlags although I would argue that Locked: field would be more
appropriate.

Drop all the page flag machinery and considerably simplify the test.  This
should be more robust for future kernel changes while checking the
promised contract is still valid.

Link: http://lkml.kernel.org/r/20200324154218.GS19542@dhcp22.suse.cz
Fixes: 9c4e6b1a7027f ("mm, mlock, vmscan: no more skipping pagevecs")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |  233 +++-----------------
 1 file changed, 37 insertions(+), 196 deletions(-)

--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-drop-dependencies-on-page-flags-from-mlock2-tests
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -67,59 +67,6 @@ out:
 	return ret;
 }
 
-static uint64_t get_pageflags(unsigned long addr)
-{
-	FILE *file;
-	uint64_t pfn;
-	unsigned long offset;
-
-	file = fopen("/proc/self/pagemap", "r");
-	if (!file) {
-		perror("fopen pagemap");
-		_exit(1);
-	}
-
-	offset = addr / getpagesize() * sizeof(pfn);
-
-	if (fseek(file, offset, SEEK_SET)) {
-		perror("fseek pagemap");
-		_exit(1);
-	}
-
-	if (fread(&pfn, sizeof(pfn), 1, file) != 1) {
-		perror("fread pagemap");
-		_exit(1);
-	}
-
-	fclose(file);
-	return pfn;
-}
-
-static uint64_t get_kpageflags(unsigned long pfn)
-{
-	uint64_t flags;
-	FILE *file;
-
-	file = fopen("/proc/kpageflags", "r");
-	if (!file) {
-		perror("fopen kpageflags");
-		_exit(1);
-	}
-
-	if (fseek(file, pfn * sizeof(flags), SEEK_SET)) {
-		perror("fseek kpageflags");
-		_exit(1);
-	}
-
-	if (fread(&flags, sizeof(flags), 1, file) != 1) {
-		perror("fread kpageflags");
-		_exit(1);
-	}
-
-	fclose(file);
-	return flags;
-}
-
 #define VMFLAGS "VmFlags:"
 
 static bool is_vmflag_set(unsigned long addr, const char *vmflag)
@@ -159,19 +106,13 @@ out:
 #define RSS  "Rss:"
 #define LOCKED "lo"
 
-static bool is_vma_lock_on_fault(unsigned long addr)
+static unsigned long get_value_for_name(unsigned long addr, const char *name)
 {
-	bool ret = false;
-	bool locked;
-	FILE *smaps = NULL;
-	unsigned long vma_size, vma_rss;
 	char *line = NULL;
-	char *value;
 	size_t size = 0;
-
-	locked = is_vmflag_set(addr, LOCKED);
-	if (!locked)
-		goto out;
+	char *value_ptr;
+	FILE *smaps = NULL;
+	unsigned long value = -1UL;
 
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
@@ -180,112 +121,70 @@ static bool is_vma_lock_on_fault(unsigne
 	}
 
 	while (getline(&line, &size, smaps) > 0) {
-		if (!strstr(line, SIZE)) {
+		if (!strstr(line, name)) {
 			free(line);
 			line = NULL;
 			size = 0;
 			continue;
 		}
 
-		value = line + strlen(SIZE);
-		if (sscanf(value, "%lu kB", &vma_size) < 1) {
+		value_ptr = line + strlen(name);
+		if (sscanf(value_ptr, "%lu kB", &value) < 1) {
 			printf("Unable to parse smaps entry for Size\n");
 			goto out;
 		}
 		break;
 	}
 
-	while (getline(&line, &size, smaps) > 0) {
-		if (!strstr(line, RSS)) {
-			free(line);
-			line = NULL;
-			size = 0;
-			continue;
-		}
-
-		value = line + strlen(RSS);
-		if (sscanf(value, "%lu kB", &vma_rss) < 1) {
-			printf("Unable to parse smaps entry for Rss\n");
-			goto out;
-		}
-		break;
-	}
-
-	ret = locked && (vma_rss < vma_size);
 out:
-	free(line);
 	if (smaps)
 		fclose(smaps);
-	return ret;
+	free(line);
+	return value;
 }
 
-#define PRESENT_BIT     0x8000000000000000ULL
-#define PFN_MASK        0x007FFFFFFFFFFFFFULL
-#define UNEVICTABLE_BIT (1UL << 18)
-
-static int lock_check(char *map)
+static bool is_vma_lock_on_fault(unsigned long addr)
 {
-	unsigned long page_size = getpagesize();
-	uint64_t page1_flags, page2_flags;
+	bool locked;
+	unsigned long vma_size, vma_rss;
+
+	locked = is_vmflag_set(addr, LOCKED);
+	if (!locked)
+		return false;
 
-	page1_flags = get_pageflags((unsigned long)map);
-	page2_flags = get_pageflags((unsigned long)map + page_size);
+	vma_size = get_value_for_name(addr, SIZE);
+	vma_rss = get_value_for_name(addr, RSS);
 
-	/* Both pages should be present */
-	if (((page1_flags & PRESENT_BIT) == 0) ||
-	    ((page2_flags & PRESENT_BIT) == 0)) {
-		printf("Failed to make both pages present\n");
-		return 1;
-	}
+	/* only one page is faulted in */
+	return (vma_rss < vma_size);
+}
 
-	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
-	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
+#define PRESENT_BIT     0x8000000000000000ULL
+#define PFN_MASK        0x007FFFFFFFFFFFFFULL
+#define UNEVICTABLE_BIT (1UL << 18)
 
-	/* Both pages should be unevictable */
-	if (((page1_flags & UNEVICTABLE_BIT) == 0) ||
-	    ((page2_flags & UNEVICTABLE_BIT) == 0)) {
-		printf("Failed to make both pages unevictable\n");
-		return 1;
-	}
+static int lock_check(unsigned long addr)
+{
+	bool locked;
+	unsigned long vma_size, vma_rss;
 
-	if (!is_vmflag_set((unsigned long)map, LOCKED)) {
-		printf("VMA flag %s is missing on page 1\n", LOCKED);
-		return 1;
-	}
+	locked = is_vmflag_set(addr, LOCKED);
+	if (!locked)
+		return false;
 
-	if (!is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
-		printf("VMA flag %s is missing on page 2\n", LOCKED);
-		return 1;
-	}
+	vma_size = get_value_for_name(addr, SIZE);
+	vma_rss = get_value_for_name(addr, RSS);
 
-	return 0;
+	return (vma_rss == vma_size);
 }
 
 static int unlock_lock_check(char *map)
 {
-	unsigned long page_size = getpagesize();
-	uint64_t page1_flags, page2_flags;
-
-	page1_flags = get_pageflags((unsigned long)map);
-	page2_flags = get_pageflags((unsigned long)map + page_size);
-	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
-	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
-
-	if ((page1_flags & UNEVICTABLE_BIT) || (page2_flags & UNEVICTABLE_BIT)) {
-		printf("A page is still marked unevictable after unlock\n");
-		return 1;
-	}
-
 	if (is_vmflag_set((unsigned long)map, LOCKED)) {
 		printf("VMA flag %s is present on page 1 after unlock\n", LOCKED);
 		return 1;
 	}
 
-	if (is_vmflag_set((unsigned long)map + page_size, LOCKED)) {
-		printf("VMA flag %s is present on page 2 after unlock\n", LOCKED);
-		return 1;
-	}
-
 	return 0;
 }
 
@@ -311,7 +210,7 @@ static int test_mlock_lock()
 		goto unmap;
 	}
 
-	if (lock_check(map))
+	if (!lock_check((unsigned long)map))
 		goto unmap;
 
 	/* Now unlock and recheck attributes */
@@ -330,64 +229,18 @@ out:
 
 static int onfault_check(char *map)
 {
-	unsigned long page_size = getpagesize();
-	uint64_t page1_flags, page2_flags;
-
-	page1_flags = get_pageflags((unsigned long)map);
-	page2_flags = get_pageflags((unsigned long)map + page_size);
-
-	/* Neither page should be present */
-	if ((page1_flags & PRESENT_BIT) || (page2_flags & PRESENT_BIT)) {
-		printf("Pages were made present by MLOCK_ONFAULT\n");
-		return 1;
-	}
-
 	*map = 'a';
-	page1_flags = get_pageflags((unsigned long)map);
-	page2_flags = get_pageflags((unsigned long)map + page_size);
-
-	/* Only page 1 should be present */
-	if ((page1_flags & PRESENT_BIT) == 0) {
-		printf("Page 1 is not present after fault\n");
-		return 1;
-	} else if (page2_flags & PRESENT_BIT) {
-		printf("Page 2 was made present\n");
-		return 1;
-	}
-
-	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
-
-	/* Page 1 should be unevictable */
-	if ((page1_flags & UNEVICTABLE_BIT) == 0) {
-		printf("Failed to make faulted page unevictable\n");
-		return 1;
-	}
-
 	if (!is_vma_lock_on_fault((unsigned long)map)) {
 		printf("VMA is not marked for lock on fault\n");
 		return 1;
 	}
 
-	if (!is_vma_lock_on_fault((unsigned long)map + page_size)) {
-		printf("VMA is not marked for lock on fault\n");
-		return 1;
-	}
-
 	return 0;
 }
 
 static int unlock_onfault_check(char *map)
 {
 	unsigned long page_size = getpagesize();
-	uint64_t page1_flags;
-
-	page1_flags = get_pageflags((unsigned long)map);
-	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
-
-	if (page1_flags & UNEVICTABLE_BIT) {
-		printf("Page 1 is still marked unevictable after unlock\n");
-		return 1;
-	}
 
 	if (is_vma_lock_on_fault((unsigned long)map) ||
 	    is_vma_lock_on_fault((unsigned long)map + page_size)) {
@@ -445,7 +298,6 @@ static int test_lock_onfault_of_present(
 	char *map;
 	int ret = 1;
 	unsigned long page_size = getpagesize();
-	uint64_t page1_flags, page2_flags;
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
@@ -465,17 +317,6 @@ static int test_lock_onfault_of_present(
 		goto unmap;
 	}
 
-	page1_flags = get_pageflags((unsigned long)map);
-	page2_flags = get_pageflags((unsigned long)map + page_size);
-	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
-	page2_flags = get_kpageflags(page2_flags & PFN_MASK);
-
-	/* Page 1 should be unevictable */
-	if ((page1_flags & UNEVICTABLE_BIT) == 0) {
-		printf("Failed to make present page unevictable\n");
-		goto unmap;
-	}
-
 	if (!is_vma_lock_on_fault((unsigned long)map) ||
 	    !is_vma_lock_on_fault((unsigned long)map + page_size)) {
 		printf("VMA with present pages is not marked lock on fault\n");
@@ -507,7 +348,7 @@ static int test_munlockall()
 		goto out;
 	}
 
-	if (lock_check(map))
+	if (!lock_check((unsigned long)map))
 		goto unmap;
 
 	if (munlockall()) {
@@ -549,7 +390,7 @@ static int test_munlockall()
 		goto out;
 	}
 
-	if (lock_check(map))
+	if (!lock_check((unsigned long)map))
 		goto unmap;
 
 	if (munlockall()) {
_
