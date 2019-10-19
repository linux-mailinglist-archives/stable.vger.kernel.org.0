Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAABADD64D
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfJSDTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbfJSDTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:19:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55939222C6;
        Sat, 19 Oct 2019 03:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455170;
        bh=s/yh0AIUYJi4gyuvcVqSwVpzS8Pgscr05GFI1ZuFJWI=;
        h=Date:From:To:Subject:From;
        b=Wp8pz0PwmNwDlfZSu2mOGysypupW/yiS60YD8KnbQ7BlIKvahKum8xmCwpJqmiaG4
         Gg5Y381FacfoVuFM0JecYY2t/4aZ6x4ca22eyySWTeMe/PJvxsg6sUbcsOneZemnfb
         D2FVwyt52m6wmcp9N8Ssj50DllXZ4Q0Z18ug5DV8=
Date:   Fri, 18 Oct 2019 20:19:29 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cai@lca.pw, david@redhat.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, mhocko@suse.com,
        miles.chen@mediatek.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, rppt@linux.vnet.ibm.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 05/26] mm/page_owner: don't access uninitialized
 memmaps when reading /proc/pagetypeinfo
Message-ID: <20191019031929.gsyYP9_aM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Subject: mm/page_owner: don't access uninitialized memmaps when reading /proc/pagetypeinfo

Uninitialized memmaps contain garbage and in the worst case trigger kernel
BUGs, especially with CONFIG_PAGE_POISONING.  They should not get touched.

For example, when not onlining a memory block that is spanned by a zone
and reading /proc/pagetypeinfo with CONFIG_DEBUG_VM_PGFLAGS and
CONFIG_PAGE_POISONING, we can trigger a kernel BUG:

:/# echo 1 > /sys/devices/system/memory/memory40/online
:/# echo 1 > /sys/devices/system/memory/memory42/online
:/# cat /proc/pagetypeinfo > test.file
  [   42.489856] page:fffff2c585200000 is uninitialized and poisoned
  [   42.489861] raw: ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
  [   42.492235] raw: ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
  [   42.493501] page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
  [   42.494533] There is not page extension available.
  [   42.495358] ------------[ cut here ]------------
  [   42.496163] kernel BUG at include/linux/mm.h:1107!
  [   42.497069] invalid opcode: 0000 [#1] SMP NOPTI

Please note that this change does not affect ZONE_DEVICE, because
pagetypeinfo_showmixedcount_print() is called from
mm/vmstat.c:pagetypeinfo_showmixedcount() only for populated zones, and
ZONE_DEVICE is never populated (zone->present_pages always 0).

[david@redhat.com: move check to outer loop, add comment, rephrase description]
Link: http://lkml.kernel.org/r/20191011140638.8160-1-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online") # visible after d0dc12e86b319
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Miles Chen <miles.chen@mediatek.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-dont-access-uninitialized-memmaps-when-reading-proc-pagetypeinfo
+++ a/mm/page_owner.c
@@ -271,7 +271,8 @@ void pagetypeinfo_showmixedcount_print(s
 	 * not matter as the mixed block count will still be correct
 	 */
 	for (; pfn < end_pfn; ) {
-		if (!pfn_valid(pfn)) {
+		page = pfn_to_online_page(pfn);
+		if (!page) {
 			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
 			continue;
 		}
@@ -279,13 +280,13 @@ void pagetypeinfo_showmixedcount_print(s
 		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		page = pfn_to_page(pfn);
 		pageblock_mt = get_pageblock_migratetype(page);
 
 		for (; pfn < block_end_pfn; pfn++) {
 			if (!pfn_valid_within(pfn))
 				continue;
 
+			/* The pageblock is online, no need to recheck. */
 			page = pfn_to_page(pfn);
 
 			if (page_zone(page) != zone)
_
