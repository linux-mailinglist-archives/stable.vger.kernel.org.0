Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F166183DD7
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 01:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCMA0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 20:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgCMA0e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 20:26:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F99206B1;
        Fri, 13 Mar 2020 00:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584059193;
        bh=YDz9cjY0QPcCRwMOYzMYI2foLrMesx2kpTAibiGDXlI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qWemYbCQiLlY33ebO5mF+hmU1S57oOXBtqffFU+CCuPc6c2x80I/aKgiqn/8+fyty
         imvfGMm6W2Sgjc2jyn825XdErK5eKRz1v2NZ0Y8scPRLzeNhU2an2QJ/U3BJPx0dSV
         Rh6DNKV6BCjsGdvQv/4540wGY+S0IrzHf1dNvvFc=
Date:   Thu, 12 Mar 2020 17:26:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dancol@google.com, dave.hansen@intel.com, jannh@google.com,
        joel@joelfernandes.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-do-not-allow-madv_pageout-for-cow-pages.patch added
 to -mm tree
Message-ID: <20200313002632.K95DZ6F32%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: do not allow MADV_PAGEOUT for CoW pages
has been added to the -mm tree.  Its filename is
     mm-do-not-allow-madv_pageout-for-cow-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-allow-madv_pageout-for-cow-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-allow-madv_pageout-for-cow-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: do not allow MADV_PAGEOUT for CoW pages

Jann has brought up a very interesting point [1].  While shared pages are
excluded from MADV_PAGEOUT normally, CoW pages can be easily reclaimed
that way.  This can lead to all sorts of hard to debug problems.  E.g. 
performance problems outlined by Daniel [2].

There are runtime environments where there is a substantial memory shared
among security domains via CoW memory and a easy to reclaim way of that
memory, which MADV_{COLD,PAGEOUT} offers, can lead to either performance
degradation in for the parent process which might be more privileged or
even open side channel attacks.

The feasibility of the latter is not really clear to me TBH but there is
no real reason for exposure at this stage.  It seems there is no real use
case to depend on reclaiming CoW memory via madvise at this stage so it is
much easier to simply disallow it and this is what this patch does.  Put
it simply MADV_{PAGEOUT,COLD} can operate only on the exclusively owned
memory which is a straightforward semantic.

[1] http://lkml.kernel.org/r/CAG48ez0G3JkMq61gUmyQAaCq=_TwHbi1XKzWRooxZkv08PQKuw@mail.gmail.com
[2] http://lkml.kernel.org/r/CAKOZueua_v8jHCpmEtTB6f3i9e2YnmX4mqdYVWhV4E=Z-n+zRQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200312082248.GS23944@dhcp22.suse.cz
Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Daniel Colascione <dancol@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/madvise.c~mm-do-not-allow-madv_pageout-for-cow-pages
+++ a/mm/madvise.c
@@ -335,12 +335,14 @@ static int madvise_cold_or_pageout_pte_r
 		}
 
 		page = pmd_page(orig_pmd);
+
+		/* Do not interfere with other mappings of this page */
+		if (page_mapcount(page) != 1)
+			goto huge_unlock;
+
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
-			if (page_mapcount(page) != 1)
-				goto huge_unlock;
-
 			get_page(page);
 			spin_unlock(ptl);
 			lock_page(page);
@@ -426,6 +428,10 @@ regular_page:
 			continue;
 		}
 
+		/* Do not interfere with other mappings of this page */
+		if (page_mapcount(page) != 1)
+			continue;
+
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		if (pte_young(ptent)) {
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-do-not-allow-madv_pageout-for-cow-pages.patch

