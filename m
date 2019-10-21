Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE56DF6E6
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfJUUmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfJUUmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:42:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09DD2086D;
        Mon, 21 Oct 2019 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690565;
        bh=qu/rflEwybDgAwbRjlLBWY9smCJcfGbNDdgk96hZ5xA=;
        h=Date:From:To:Subject:From;
        b=GdLOu/DLZvl9UxrkWK87jcLIWQ7eXoo5qAvxfYeZzo/z+2tuI3ps/jUVfAPxlkgWE
         maVvmKlWO6xWBXI7UTLcwlo4MZ+WX/cfP9nxDCbwIbVSuqGSIw95YReqioTUNzoRo4
         qFRY6cQ4yrSEA7+b7/vhMa0Poc1cR6eFd0k4uGyI=
Date:   Mon, 21 Oct 2019 13:42:44 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, aneesh.kumar@linux.ibm.com,
        anthony.yznaga@oracle.com, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        pagupta@redhat.com, rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au,
        stable@vger.kernel.org, t-fukasawa@vx.jp.nec.com
Subject:  [merged]
 mm-dont-access-uninitialized-memmaps-in-fs-proc-pagec.patch removed from
 -mm tree
Message-ID: <20191021204244.sZQPCmGYv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c
has been removed from the -mm tree.  Its filename was
     mm-dont-access-uninitialized-memmaps-in-fs-proc-pagec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c

There are three places where we access uninitialized memmaps, namely:
- /proc/kpagecount
- /proc/kpageflags
- /proc/kpagecgroup

We have initialized memmaps either when the section is online or when the
page was initialized to the ZONE_DEVICE.  Uninitialized memmaps contain
garbage and in the worst case trigger kernel BUGs, especially with
CONFIG_PAGE_POISONING.

For example, not onlining a DIMM during boot and calling /proc/kpagecount
with CONFIG_PAGE_POISONING:
:/# cat /proc/kpagecount > tmp.test
[   95.600592] BUG: unable to handle page fault for address: fffffffffffffffe
[   95.601238] #PF: supervisor read access in kernel mode
[   95.601675] #PF: error_code(0x0000) - not-present page
[   95.602116] PGD 114616067 P4D 114616067 PUD 114618067 PMD 0
[   95.602596] Oops: 0000 [#1] SMP NOPTI
[   95.602920] CPU: 0 PID: 469 Comm: cat Not tainted 5.4.0-rc1-next-20191004+ #11
[   95.603547] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.4
[   95.604521] RIP: 0010:kpagecount_read+0xce/0x1e0
[   95.604917] Code: e8 09 83 e0 3f 48 0f a3 02 73 2d 4c 89 e7 48 c1 e7 06 48 03 3d ab 51 01 01 74 1d 48 8b 57 08 480
[   95.606450] RSP: 0018:ffffa14e409b7e78 EFLAGS: 00010202
[   95.606904] RAX: fffffffffffffffe RBX: 0000000000020000 RCX: 0000000000000000
[   95.607519] RDX: 0000000000000001 RSI: 00007f76b5595000 RDI: fffff35645000000
[   95.608128] RBP: 00007f76b5595000 R08: 0000000000000001 R09: 0000000000000000
[   95.608731] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000140000
[   95.609327] R13: 0000000000020000 R14: 00007f76b5595000 R15: ffffa14e409b7f08
[   95.609924] FS:  00007f76b577d580(0000) GS:ffff8f41bd400000(0000) knlGS:0000000000000000
[   95.610599] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.611083] CR2: fffffffffffffffe CR3: 0000000078960000 CR4: 00000000000006f0
[   95.611686] Call Trace:
[   95.611906]  proc_reg_read+0x3c/0x60
[   95.612228]  vfs_read+0xc5/0x180
[   95.612505]  ksys_read+0x68/0xe0
[   95.612785]  do_syscall_64+0x5c/0xa0
[   95.613092]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

For now, let's drop support for ZONE_DEVICE from the three pseudo files in
order to fix this.  To distinguish offline memory (with garbage memmap)
from ZONE_DEVICE memory with properly initialized memmaps, we would have
to check get_dev_pagemap() and pfn_zone_device_reserved() right now.  The
usage of both (especially, special casing devmem) is frowned upon and
needs to be reworked.  The fundamental issue we have is:

	if (pfn_to_online_page(pfn)) {
		/* memmap initialized */
	} else if (pfn_valid(pfn)) {
		/*
		 * ???
		 * a) offline memory. memmap garbage.
		 * b) devmem: memmap initialized to ZONE_DEVICE.
		 * c) devmem: reserved for driver. memmap garbage.
		 * (d) devmem: memmap currently initializing - garbage)
		 */
	}

We'll leave the pfn_zone_device_reserved() check in stable_page_flags() in
place as that function is also used from memory failure.  We now no longer
dump information about pages that are not in use anymore - offline.

Link: http://lkml.kernel.org/r/20191009142435.3975-2-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc: Pankaj gupta <pagupta@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/fs/proc/page.c~mm-dont-access-uninitialized-memmaps-in-fs-proc-pagec
+++ a/fs/proc/page.c
@@ -42,10 +42,12 @@ static ssize_t kpagecount_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
+
 		if (!ppage || PageSlab(ppage) || page_has_type(ppage))
 			pcount = 0;
 		else
@@ -218,10 +220,11 @@ static ssize_t kpageflags_read(struct fi
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
 
 		if (put_user(stable_page_flags(ppage), out)) {
 			ret = -EFAULT;
@@ -263,10 +266,11 @@ static ssize_t kpagecgroup_read(struct f
 		return -EINVAL;
 
 	while (count > 0) {
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		else
-			ppage = NULL;
+		/*
+		 * TODO: ZONE_DEVICE support requires to identify
+		 * memmaps that were actually initialized.
+		 */
+		ppage = pfn_to_online_page(pfn);
 
 		if (ppage)
 			ino = page_cgroup_ino(ppage);
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory_hotplug-export-generic_online_page.patch
hv_balloon-use-generic_online_page.patch
mm-memory_hotplug-remove-__online_page_free-and-__online_page_increment_counters.patch
mm-memory_hotplug-dont-access-uninitialized-memmaps-in-shrink_zone_span.patch
mm-memory_hotplug-shrink-zones-when-offlining-memory.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch

