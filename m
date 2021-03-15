Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555AD33A95C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 02:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhCOBf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 21:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCOBfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Mar 2021 21:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A460464E55;
        Mon, 15 Mar 2021 01:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615772116;
        bh=/w5t/X8sgzb1j2Vgk2s0YI4cu6ACdXirsvZu8eDMc3s=;
        h=Date:From:To:Subject:From;
        b=FWHmd/pP9T5EMZLgvg/reZAgDeuwYn+VszR9v3nieiY3L8N1MVNy+aJVBc/KJrox1
         ZmDQTko6x0sOpye91gZJJbNgu2VQVNpKK53Gheieep4g7SmNr3kDhxmH9iTPT+Y6aR
         Ksw4FDWgrf7bIlJAT1yzTVaxIi1HTrBH1/aqxxQM=
Date:   Sun, 14 Mar 2021 18:35:15 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com
Subject:  [to-be-updated]
 =?US-ASCII?Q?mm-hwpoison-do-not-lock-page-again-when-me=5Fhuge=5Fpage-suc?=
 =?US-ASCII?Q?cessfully-recovers.patch?= removed from -mm tree
Message-ID: <20210315013515.7XLre4gfc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: do not lock page again when me_huge_page() successfully recovers
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: do not lock page again when me_huge_page() successfully recovers

Currently me_huge_page() temporary unlocks page to perform some actions
then locks it again later.  My testcase (which calls hard-offline on
some tail page in a hugetlb, then accesses the address of the hugetlb
range) showed that page allocation code detects this page lock on buddy
page and printed out "BUG: Bad page state" message.

check_new_page_bad() does not consider a page with __PG_HWPOISON as bad
page, so this flag works as kind of filter, but this filtering doesn't
work in this case because the "bad page" is not the actual hwpoisoned
page.

This patch suggests to drop the 2nd page lock to fix the issue.

Link: https://lkml.kernel.org/r/20210304064437.962442-1-nao.horiguchi@gmail.com
Fixes: commit 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers
+++ a/mm/memory-failure.c
@@ -834,7 +834,6 @@ static int me_huge_page(struct page *p,
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		}
-		lock_page(hpage);
 	}
 
 	return res;
@@ -1290,7 +1289,8 @@ static int memory_failure_hugetlb(unsign
 
 	res = identify_page_state(pfn, p, page_flags);
 out:
-	unlock_page(head);
+	if (PageLocked(head))
+		unlock_page(head);
 	return res;
 }
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


