Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA418E5C6
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 02:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgCVBW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 21:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB9E20757;
        Sun, 22 Mar 2020 01:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584840148;
        bh=GPIJXAU8IdYJRQY6I34QACgs/PHeLhjUhfPVGA19puk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sIgkxHmIyg5bf/bNSgO7qViDIKy9HuWF7IIlhuaPb1m8jG+rAtrzuBSJnD578Y6fJ
         Ejne412lZYBQF153iO3yl0FGXeUvusqkVOvSu1gkAdvPcKGsviMNEXKv0Xu8wPufd+
         Fq6/xCgKkS6NxaT8yDMn+s4cOL/b+ksa+qgfpnQU=
Date:   Sat, 21 Mar 2020 18:22:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dancol@google.com,
        dave.hansen@intel.com, jannh@google.com, joel@joelfernandes.org,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 06/10] mm: do not allow MADV_PAGEOUT for CoW pages
Message-ID: <20200322012226.yY5JKgG__%akpm@linux-foundation.org>
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
