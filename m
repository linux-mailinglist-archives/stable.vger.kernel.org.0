Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1613B6077
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhF1OZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhF1OXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A12861CA0;
        Mon, 28 Jun 2021 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890019;
        bh=35CB7u/TEFVAwr9Xuh8Bnb1pEGX10voiJC/dsNvRedY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o52AucQ5ILqKJgFCn4BnSS9DizLV+ShYxs6G67lV+/oesFXs26+uD2AZL622g4Yne
         OuyC6qQhZUdtZoXAS2OI4QHJXQ9ijhZ0g+58H6nygtvajV83yW3+f08EuM02YWgOww
         sm2+qIeCBOQSdD6mpZop9UMyKFXxS5kBFRgsSs5X7v7ly2lCEB+WddqoHb5HGYEmna
         DsKJ1WatRUXjrMwKy5KmwDoK976ycLTfJPNVOK0kJDTyAySzJsmnOe2jb16tpDFu3t
         Lwfn1+eiNNBrffEPHyMHtXFPHuL1xLA8sMHOb20j+laRSe3edp14f0ThZafeO2FzEM
         Cc7z0ydDxkFcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 104/110] mm/hwpoison: do not lock page again when me_huge_page() successfully recovers
Date:   Mon, 28 Jun 2021 10:18:22 -0400
Message-Id: <20210628141828.31757-105-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit ea6d0630100b285f059d0a8d8e86f38a46407536 upstream.

Currently me_huge_page() temporary unlocks page to perform some actions
then locks it again later.  My testcase (which calls hard-offline on
some tail page in a hugetlb, then accesses the address of the hugetlb
range) showed that page allocation code detects this page lock on buddy
page and printed out "BUG: Bad page state" message.

check_new_page_bad() does not consider a page with __PG_HWPOISON as bad
page, so this flag works as kind of filter, but this filtering doesn't
work in this case because the "bad page" is not the actual hwpoisoned
page.  So stop locking page again.  Actions to be taken depend on the
page type of the error, so page unlocking should be done in ->action()
callbacks.  So let's make it assumed and change all existing callbacks
that way.

Link: https://lkml.kernel.org/r/20210609072029.74645-1-nao.horiguchi@gmail.com
Fixes: commit 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2dd60ad81216..4db6f95e55be 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -658,6 +658,7 @@ static int truncate_error_page(struct page *p, unsigned long pfn,
  */
 static int me_kernel(struct page *p, unsigned long pfn)
 {
+	unlock_page(p);
 	return MF_IGNORED;
 }
 
@@ -667,6 +668,7 @@ static int me_kernel(struct page *p, unsigned long pfn)
 static int me_unknown(struct page *p, unsigned long pfn)
 {
 	pr_err("Memory failure: %#lx: Unknown page state\n", pfn);
+	unlock_page(p);
 	return MF_FAILED;
 }
 
@@ -675,6 +677,7 @@ static int me_unknown(struct page *p, unsigned long pfn)
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -683,8 +686,10 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	 * For anonymous pages we're done the only reference left
 	 * should be the one m_f() holds.
 	 */
-	if (PageAnon(p))
-		return MF_RECOVERED;
+	if (PageAnon(p)) {
+		ret = MF_RECOVERED;
+		goto out;
+	}
 
 	/*
 	 * Now truncate the page in the page cache. This is really
@@ -698,7 +703,8 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 		/*
 		 * Page has been teared down in the meanwhile
 		 */
-		return MF_FAILED;
+		ret = MF_FAILED;
+		goto out;
 	}
 
 	/*
@@ -706,7 +712,10 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
 	 *
 	 * Open: to take i_mutex or not for this? Right now we don't.
 	 */
-	return truncate_error_page(p, pfn, mapping);
+	ret = truncate_error_page(p, pfn, mapping);
+out:
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -782,24 +791,26 @@ static int me_pagecache_dirty(struct page *p, unsigned long pfn)
  */
 static int me_swapcache_dirty(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	ClearPageDirty(p);
 	/* Trigger EIO in shmem: */
 	ClearPageUptodate(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_DELAYED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+	unlock_page(p);
+	return ret;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
 {
+	int ret;
+
 	delete_from_swap_cache(p);
 
-	if (!delete_from_lru_cache(p))
-		return MF_RECOVERED;
-	else
-		return MF_FAILED;
+	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+	unlock_page(p);
+	return ret;
 }
 
 /*
@@ -820,6 +831,7 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 	mapping = page_mapping(hpage);
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
+		unlock_page(hpage);
 	} else {
 		res = MF_FAILED;
 		unlock_page(hpage);
@@ -834,7 +846,6 @@ static int me_huge_page(struct page *p, unsigned long pfn)
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
-		lock_page(hpage);
 	}
 
 	return res;
@@ -866,6 +877,8 @@ static struct page_state {
 	unsigned long mask;
 	unsigned long res;
 	enum mf_action_page_type type;
+
+	/* Callback ->action() has to unlock the relevant page inside it. */
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
@@ -929,6 +942,7 @@ static int page_action(struct page_state *ps, struct page *p,
 	int result;
 	int count;
 
+	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(p, pfn);
 
 	count = page_count(p) - 1;
@@ -1313,7 +1327,7 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 		goto out;
 	}
 
-	res = identify_page_state(pfn, p, page_flags);
+	return identify_page_state(pfn, p, page_flags);
 out:
 	unlock_page(head);
 	return res;
@@ -1595,6 +1609,8 @@ try_again:
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
+	mutex_unlock(&mf_mutex);
+	return res;
 unlock_page:
 	unlock_page(p);
 unlock_mutex:
-- 
2.30.2

