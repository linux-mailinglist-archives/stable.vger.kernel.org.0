Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC9D11BEE1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLKVNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfLKVNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 16:13:10 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6EC20637;
        Wed, 11 Dec 2019 21:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576098789;
        bh=ib5vA9CRPFJFj66/RpSWMU9MMKsBPvJO+K5BAvOMsjA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U6HtR+zXJLip2zooxlZrUVB1FTLdGM1KOnCXNWFROO+ithWEwDafO9JsLCEMBg3yQ
         kK+iIGwlQtpZb6BZMb5Zdg5onc5RBFwl7DDKV+GBopyrMEekoSb5XeWsN/epqQNNLs
         uj8ki86dk6xRaFT/MGI8iW4pZKvQiF8IUSVX0fLE=
Date:   Wed, 11 Dec 2019 13:13:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        bob.picco@oracle.com, dan.j.williams@intel.com,
        daniel.m.jordan@oracle.com, david@redhat.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        pasha.tatashin@oracle.com, sfr@canb.auug.org.au,
        stable@vger.kernel.org, steven.sistare@oracle.com
Subject:  +
 mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
 added to -mm tree
Message-ID: <20191211211308.SilQEQZCY%akpm@linux-foundation.org>
In-Reply-To: <20191206170123.cb3ad1f76af2b48505fabb33@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix uninitialized memmaps on a partially populated last section
has been added to the -mm tree.  Its filename is
     mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc.c: fix uninitialized memmaps on a partially populated last section

If max_pfn is not aligned to a section boundary, we can easily run into
BUGs.  This can e.g., be triggered on x86-64 under QEMU by specifying a
memory size that is not a multiple of 128MB (e.g., 4097MB, but also
4160MB).  I was told that on real HW, we can easily have this scenario
(esp., one of the main reasons sub-section hotadd of devmem was added).

The issue is, that we have a valid memmap (pfn_valid()) for the whole
section, and the whole section will be marked "online". 
pfn_to_online_page() will succeed, but the memmap contains garbage.

E.g., doing a "./page-types -r -a 0x144001" when QEMU was started with "-m
4160M" - (see tools/vm/page-types.c):

[  200.476376] BUG: unable to handle page fault for address: fffffffffffffffe
[  200.477500] #PF: supervisor read access in kernel mode
[  200.478334] #PF: error_code(0x0000) - not-present page
[  200.479076] PGD 59614067 P4D 59614067 PUD 59616067 PMD 0
[  200.479557] Oops: 0000 [#4] SMP NOPTI
[  200.479875] CPU: 0 PID: 603 Comm: page-types Tainted: G      D W         5.5.0-rc1-next-20191209 #93
[  200.480646] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
[  200.481648] RIP: 0010:stable_page_flags+0x4d/0x410
[  200.482061] Code: f3 ff 41 89 c0 48 b8 00 00 00 00 01 00 00 00 45 84 c0 0f 85 cd 02 00 00 48 8b 53 08 48 8b 2b 48f
[  200.483644] RSP: 0018:ffffb139401cbe60 EFLAGS: 00010202
[  200.484091] RAX: fffffffffffffffe RBX: fffffbeec5100040 RCX: 0000000000000000
[  200.484697] RDX: 0000000000000001 RSI: ffffffff9535c7cd RDI: 0000000000000246
[  200.485313] RBP: ffffffffffffffff R08: 0000000000000000 R09: 0000000000000000
[  200.485917] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000144001
[  200.486523] R13: 00007ffd6ba55f48 R14: 00007ffd6ba55f40 R15: ffffb139401cbf08
[  200.487130] FS:  00007f68df717580(0000) GS:ffff9ec77fa00000(0000) knlGS:0000000000000000
[  200.487804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  200.488295] CR2: fffffffffffffffe CR3: 0000000135d48000 CR4: 00000000000006f0
[  200.488897] Call Trace:
[  200.489115]  kpageflags_read+0xe9/0x140
[  200.489447]  proc_reg_read+0x3c/0x60
[  200.489755]  vfs_read+0xc2/0x170
[  200.490037]  ksys_pread64+0x65/0xa0
[  200.490352]  do_syscall_64+0x5c/0xa0
[  200.490665]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

But it can be triggered much easier via "cat /proc/kpageflags > /dev/null"
after cold/hot plugging a DIMM to such a system:

[root@localhost ~]# cat /proc/kpageflags > /dev/null
[  111.517275] BUG: unable to handle page fault for address: fffffffffffffffe
[  111.517907] #PF: supervisor read access in kernel mode
[  111.518333] #PF: error_code(0x0000) - not-present page
[  111.518771] PGD a240e067 P4D a240e067 PUD a2410067 PMD 0

This patch fixes that by at least zero-ing out that memmap (so e.g.,
page_to_pfn() will not crash).  Commit 907ec5fca3dc ("mm: zero remaining
unavailable struct pages") tried to fix a similar issue, but forgot to
consider this special case.

After this patch, there are still problems to solve.  E.g., not all of
these pages falling into a memory hole will actually get initialized later
and set PageReserved - they are only zeroed out - but at least the
immediate crashes are gone.  A follow-up patch will take care of this.

Link: http://lkml.kernel.org/r/20191211163201.17179-2-david@redhat.com
Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@vger.kernel.org>	[4.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section
+++ a/mm/page_alloc.c
@@ -6932,7 +6932,8 @@ static u64 zero_pfn_range(unsigned long
  * This function also addresses a similar issue where struct pages are left
  * uninitialized because the physical address range is not covered by
  * memblock.memory or memblock.reserved. That could happen when memblock
- * layout is manually configured via memmap=.
+ * layout is manually configured via memmap=, or when the highest physical
+ * address (max_pfn) does not end on a section boundary.
  */
 void __init zero_resv_unavail(void)
 {
@@ -6950,7 +6951,16 @@ void __init zero_resv_unavail(void)
 			pgcnt += zero_pfn_range(PFN_DOWN(next), PFN_UP(start));
 		next = end;
 	}
-	pgcnt += zero_pfn_range(PFN_DOWN(next), max_pfn);
+
+	/*
+	 * Early sections always have a fully populated memmap for the whole
+	 * section - see pfn_valid(). If the last section has holes at the
+	 * end and that section is marked "online", the memmap will be
+	 * considered initialized. Make sure that memmap has a well defined
+	 * state.
+	 */
+	pgcnt += zero_pfn_range(PFN_DOWN(next),
+				round_up(max_pfn, PAGES_PER_SECTION));
 
 	/*
 	 * Struct pages that do not have backing memory. This could be because
_

Patches currently in -mm which might be from david@redhat.com are

mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
mm-initialize-memmap-of-unavailable-memory-directly.patch
mm-memory_hotplug-shrink-zones-when-offlining-memory.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch

