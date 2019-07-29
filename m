Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3367977A
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390813AbfG2UAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403754AbfG2Tws (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:52:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D9B21773;
        Mon, 29 Jul 2019 19:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429967;
        bh=7gI2jRdswUqOZikL5g6HJFqgYXJPBbm5N+9BTbWMDY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOZJBu4erYTGVEzWfZiOHHNnaGZPNxKRwS1YJphXCKeRdwArOrpQ/rl+fcVfeAp1d
         Kh5agMQjBeF966n+oOOYR3IrCiHkDqsEgqUD0FetlcWbSCjrXn1tZ0+raI6Egp5TEb
         xGal4d8uBAwcU0hmUZzAEsxV0TsrVfPmH/pWQSP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Jiang <dave.jiang@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 152/215] mm/mincore.c: fix race between swapoff and mincore
Date:   Mon, 29 Jul 2019 21:22:28 +0200
Message-Id: <20190729190806.168930852@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aeb309b81c6bada783c3695528a3e10748e97285 ]

Via commit 4b3ef9daa4fc ("mm/swap: split swap cache into 64MB trunks"),
after swapoff, the address_space associated with the swap device will be
freed.  So swap_address_space() users which touch the address_space need
some kind of mechanism to prevent the address_space from being freed
during accessing.

When mincore processes an unmapped range for swapped shmem pages, it
doesn't hold the lock to prevent swap device from being swapped off.  So
the following race is possible:

CPU1					CPU2
do_mincore()				swapoff()
  walk_page_range()
    mincore_unmapped_range()
      __mincore_unmapped_range
        mincore_page
	  as = swap_address_space()
          ...				  exit_swap_address_space()
          ...				    kvfree(spaces)
	  find_get_page(as)

The address space may be accessed after being freed.

To fix the race, get_swap_device()/put_swap_device() is used to enclose
find_get_page() to check whether the swap entry is valid and prevent the
swap device from being swapoff during accessing.

Link: http://lkml.kernel.org/r/20190611020510.28251-1-ying.huang@intel.com
Fixes: 4b3ef9daa4fc ("mm/swap: split swap cache into 64MB trunks")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrea Parri <andrea.parri@amarulasolutions.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mincore.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index c3f058bd0faf..4fe91d497436 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -68,8 +68,16 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (xa_is_value(page)) {
 			swp_entry_t swp = radix_to_swp_entry(page);
-			page = find_get_page(swap_address_space(swp),
-					     swp_offset(swp));
+			struct swap_info_struct *si;
+
+			/* Prevent swap device to being swapoff under us */
+			si = get_swap_device(swp);
+			if (si) {
+				page = find_get_page(swap_address_space(swp),
+						     swp_offset(swp));
+				put_swap_device(si);
+			} else
+				page = NULL;
 		}
 	} else
 		page = find_get_page(mapping, pgoff);
-- 
2.20.1



