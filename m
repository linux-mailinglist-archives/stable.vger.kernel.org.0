Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA7D32DF4B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 02:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCEBz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 20:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhCEBz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 20:55:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2B4E64F79;
        Fri,  5 Mar 2021 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614909355;
        bh=2D+dSTXuYdp7wZj3ePrEsDXxt1gxeHc9DX4GF0DK6CM=;
        h=Date:From:To:Subject:From;
        b=0TkXOsRudh3i++ZFYZ3OjxePyuHwJDxa2AiUNC9+wwYgbRhBAwPy0OhhGI1UmnjAV
         SlJCLNz1C5WVoJWULm4TQ3HSA6AZ9rk2J6lRMEN0SLotz+MFvebt3v6N+6n4hyYJRP
         Uh7e12PbWcAlDlcDz3jAP2DKrqJuyocz7NYvN6JQ=
Date:   Thu, 04 Mar 2021 17:55:54 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org, tony.luck@intel.com
Subject:  +
 =?US-ASCII?Q?mm-hwpoison-do-not-lock-page-again-when-me=5Fhuge=5Fpage-suc?=
 =?US-ASCII?Q?cessfully-recovers.patch?= added to -mm tree
Message-ID: <20210305015554.gEJGOznd-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: do not lock page again when me_huge_page() successfully recovers
has been added to the -mm tree.  Its filename is
     mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: do not lock page again when me_huge_page() successfully recovers

Currently me_huge_page() temporary unlocks page to perform some actions
then locks it again later.  My testcase (which calls hard-offline on some
tail page in a hugetlb, then accesses the address of the hugetlb range)
showed that page allocation code detects the page lock on buddy page and
printed out "BUG: Bad page state" message.  PG_hwpoison does not prevent
it because PG_hwpoison flag is set on any subpage of the hugetlb page but
the 2nd page lock is on the head page.

This patch suggests to drop the 2nd page lock to fix the issue.

Link: https://lkml.kernel.org/r/20210304064437.962442-1-nao.horiguchi@gmail.com
Fixes: commit 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch

