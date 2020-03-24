Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64426191028
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgCXNZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgCXNZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:25:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3148D208C3;
        Tue, 24 Mar 2020 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056346;
        bh=+xpPjaMhoBadtcvnqh6t0mLef2amTpzfhjgOuazpDck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj4039sctKGa66VgQ2viA5vk3ZtXlRwwN6N6CqJU1sWnE8KmILP5DIF5UXA5idXTw
         wdqtYRnTJOBr3JtyKNNV4xqxPUSmk2SNZzavVzfolpl1Y4TD+soLvs8HoLqLwbPgck
         8I+XCxWkiQ6pC4CqMb2sHtFVX6cGUWlVtlyLQ9hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 096/119] mm: do not allow MADV_PAGEOUT for CoW pages
Date:   Tue, 24 Mar 2020 14:11:21 +0100
Message-Id: <20200324130817.757717214@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit 12e967fd8e4e6c3d275b4c69c890adc838891300 upstream.

Jann has brought up a very interesting point [1].  While shared pages
are excluded from MADV_PAGEOUT normally, CoW pages can be easily
reclaimed that way.  This can lead to all sorts of hard to debug
problems.  E.g.  performance problems outlined by Daniel [2].

There are runtime environments where there is a substantial memory
shared among security domains via CoW memory and a easy to reclaim way
of that memory, which MADV_{COLD,PAGEOUT} offers, can lead to either
performance degradation in for the parent process which might be more
privileged or even open side channel attacks.

The feasibility of the latter is not really clear to me TBH but there is
no real reason for exposure at this stage.  It seems there is no real
use case to depend on reclaiming CoW memory via madvise at this stage so
it is much easier to simply disallow it and this is what this patch
does.  Put it simply MADV_{PAGEOUT,COLD} can operate only on the
exclusively owned memory which is a straightforward semantic.

[1] http://lkml.kernel.org/r/CAG48ez0G3JkMq61gUmyQAaCq=_TwHbi1XKzWRooxZkv08PQKuw@mail.gmail.com
[2] http://lkml.kernel.org/r/CAKOZueua_v8jHCpmEtTB6f3i9e2YnmX4mqdYVWhV4E=Z-n+zRQ@mail.gmail.com

Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Daniel Colascione <dancol@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200312082248.GS23944@dhcp22.suse.cz
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/madvise.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
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


