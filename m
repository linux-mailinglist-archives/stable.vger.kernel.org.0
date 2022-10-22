Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC859609072
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 01:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJVXiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 19:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJVXiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 19:38:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830517E827;
        Sat, 22 Oct 2022 16:38:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45471B80BED;
        Sat, 22 Oct 2022 23:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45DC433D7;
        Sat, 22 Oct 2022 23:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666481879;
        bh=SfoVmO3YQp1qSH5jER8lLAVps1YZsFc1IW+5A0cFOKk=;
        h=Date:To:From:Subject:From;
        b=ql//SrqgHBjUA1nV45dsmqjJRTAUyQHy2qKzed3nUS9yGg8M55L5WOPi1VrZJqZ2L
         0IOryFJAZgMZBol2vVDsvG/DLMD1dc6lPwj4h9bIZQbXg0LPTLYHrS3PbxxItiM7GQ
         44st0tuJV+VjlW9ri2M9QuktdiAFyrRQ0xwG6jL8=
Date:   Sat, 22 Oct 2022 16:37:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, mgorman@techsingularity.net,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prep_compound_tail-clear-page-private.patch added to mm-hotfixes-unstable branch
Message-Id: <20221022233758.DD45DC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: prep_compound_tail() clear page->private
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-prep_compound_tail-clear-page-private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prep_compound_tail-clear-page-private.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: prep_compound_tail() clear page->private
Date: Sat, 22 Oct 2022 00:51:06 -0700 (PDT)

Although page allocation always clears page->private in the first page or
head page of an allocation, it has never made a point of clearing
page->private in the tails (though 0 is often what is already there).

But now commit 71e2d666ef85 ("mm/huge_memory: do not clobber swp_entry_t
during THP split") issues a warning when page_tail->private is found to be
non-0 (unless it's swapcache).

Change that warning to dump page_tail (which also dumps head), instead of
just the head: so far we have seen dead000000000122, dead000000000003,
dead000000000001 or 0000000000000002 in the raw output for tail private.

We could just delete the warning, but today's consensus appears to want
page->private to be 0, unless there's a good reason for it to be set: so
now clear it in prep_compound_tail() (more general than just for THP; but
not for high order allocation, which makes no pass down the tails).

Link: https://lkml.kernel.org/r/1c4233bb-4e4d-5969-fbd4-96604268a285@google.com
Fixes: 71e2d666ef85 ("mm/huge_memory: do not clobber swp_entry_t during THP split")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 mm/page_alloc.c  |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-prep_compound_tail-clear-page-private
+++ a/mm/huge_memory.c
@@ -2462,7 +2462,7 @@ static void __split_huge_page_tail(struc
 	 * Fix up and warn once if private is unexpectedly set.
 	 */
 	if (!folio_test_swapcache(page_folio(head))) {
-		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, head);
+		VM_WARN_ON_ONCE_PAGE(page_tail->private != 0, page_tail);
 		page_tail->private = 0;
 	}
 
--- a/mm/page_alloc.c~mm-prep_compound_tail-clear-page-private
+++ a/mm/page_alloc.c
@@ -807,6 +807,7 @@ static void prep_compound_tail(struct pa
 
 	p->mapping = TAIL_MAPPING;
 	set_compound_head(p, head);
+	set_page_private(p, 0);
 }
 
 void prep_compound_page(struct page *page, unsigned int order)
_

Patches currently in -mm which might be from hughd@google.com are

mm-prep_compound_tail-clear-page-private.patch

