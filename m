Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2DE67B7
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfJ0VXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbfJ0VXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:40 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C757C20717;
        Sun, 27 Oct 2019 21:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211419;
        bh=bm6SBd9KSkotabOnfPkgf/B5SunoLXDIwjWNJjcpgZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3TDF5UxQPTSFBgiuW6tU09qnj8OLlSnGjkoMYZZqDDM+Vv9+Br1Qaxg39CYSjC1v
         QloO/Wc1S2bkt1Z9ExMFJxl8O/sbNGbuQCS1vklwTHmAKZLuVpuHf1hOHJTlLySdQp
         yZ5BhNKBM76NQtieTeKEc+MYTT8B551CvVW5yp+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miles Chen <miles.chen@mediatek.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 146/197] mm/page_owner: dont access uninitialized memmaps when reading /proc/pagetypeinfo
Date:   Sun, 27 Oct 2019 22:01:04 +0100
Message-Id: <20191027203359.574805998@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit a26ee565b6cd8dc2bf15ff6aa70bbb28f928b773 upstream.

Uninitialized memmaps contain garbage and in the worst case trigger
kernel BUGs, especially with CONFIG_PAGE_POISONING.  They should not get
touched.

For example, when not onlining a memory block that is spanned by a zone
and reading /proc/pagetypeinfo with CONFIG_DEBUG_VM_PGFLAGS and
CONFIG_PAGE_POISONING, we can trigger a kernel BUG:

  :/# echo 1 > /sys/devices/system/memory/memory40/online
  :/# echo 1 > /sys/devices/system/memory/memory42/online
  :/# cat /proc/pagetypeinfo > test.file
   page:fffff2c585200000 is uninitialized and poisoned
   raw: ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
   raw: ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
   page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
   There is not page extension available.
   ------------[ cut here ]------------
   kernel BUG at include/linux/mm.h:1107!
   invalid opcode: 0000 [#1] SMP NOPTI

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_owner.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -258,7 +258,8 @@ void pagetypeinfo_showmixedcount_print(s
 	 * not matter as the mixed block count will still be correct
 	 */
 	for (; pfn < end_pfn; ) {
-		if (!pfn_valid(pfn)) {
+		page = pfn_to_online_page(pfn);
+		if (!page) {
 			pfn = ALIGN(pfn + 1, MAX_ORDER_NR_PAGES);
 			continue;
 		}
@@ -266,13 +267,13 @@ void pagetypeinfo_showmixedcount_print(s
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


