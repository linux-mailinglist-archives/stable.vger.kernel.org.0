Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AFB339BE9
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhCMFIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhCMFIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3913D64FA7;
        Sat, 13 Mar 2021 05:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612101;
        bh=xGzWrpNlMUt9/MxfPRiV1rbhDkPL83KBiXbTDs5FvRc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oyCWy5BtIuP8SrDRyMS9Q3U7qARGltEYhCMxM3sXdJPIRKywtxfoJ5UaRp4uEEOfH
         05BT48E/7ZBxRlWaC2j07QtWog2vtw35uZ1IvCmt0sXZ70feDoK1X5zcuTHGNAFvSg
         MmTfrDm2D6NxQtD8CEYSRx5fpbeWcM2gfMwx/Nh0=
Date:   Fri, 12 Mar 2021 21:08:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 23/29] mm, hwpoison: do not lock page again when
 me_huge_page() successfully recovers
Message-ID: <20210313050820.EoPGLS3gj%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
