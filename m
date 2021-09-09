Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36662404285
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348992AbhIIBBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348959AbhIIBBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA4C61132;
        Thu,  9 Sep 2021 01:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631149237;
        bh=vvUQSt/TXPjtKT/V8QBOOn0K+CU9XvKpmj4qs/egiAI=;
        h=Date:From:To:Subject:From;
        b=wufLLa8GJnDtU0h1QhhBv5tpegULiHRiV4A6Wf+K1zumPKFQybfkTYADfXU/f7j+q
         sjTfzWY8dikAkcdv37HAImZWS3yS/opvAjPL1PAtB2H1VlHZ8CK27/eqJ1LoAtXf4t
         ZM5tOt+xCmgO2yaQhRzlC/h3hxPe19A1X1qifgrs=
Date:   Wed, 08 Sep 2021 18:00:36 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        tony.luck@intel.com
Subject:  +
 mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable.patch added to -mm
 tree
Message-ID: <20210909010036.KFc0UhCIW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()
has been added to the -mm tree.  Its filename is
     mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable.patch

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
Subject: mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()

commit fcc00621d88b ("mm/hwpoison: retry with shake_page() for unhandlable
pages") changes the return value of __get_hwpoison_page() to retry for
transiently unhandlable cases.  However, __get_hwpoison_page() currently
fails to properly judge buddy pages as handlable, so hard/soft offline for
buddy pages always fail as "unhandlable page".  This is totally
regrettable.

So let's add is_free_buddy_page() in HWPoisonHandlable(), so that
__get_hwpoison_page() returns different return values between buddy
pages and unhandlable pages as intended.

Link: https://lkml.kernel.org/r/20210909004131.163221-1-naoya.horiguchi@linux.dev
Fixes: fcc00621d88b ("mm/hwpoison: retry with shake_page() for unhandlable pages")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable
+++ a/mm/memory-failure.c
@@ -1126,7 +1126,7 @@ static int page_action(struct page_state
  */
 static inline bool HWPoisonHandlable(struct page *page)
 {
-	return PageLRU(page) || __PageMovable(page);
+	return PageLRU(page) || __PageMovable(page) || is_free_buddy_page(page);
 }
 
 static int __get_hwpoison_page(struct page *page)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-sparse-set-section_nid_shift-to-6.patch
mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable.patch

