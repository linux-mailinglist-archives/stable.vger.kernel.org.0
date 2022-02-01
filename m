Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1878C4A544D
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 01:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiBAAwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 19:52:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiBAAwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 19:52:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D73DB82CA2;
        Tue,  1 Feb 2022 00:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C129CC340E8;
        Tue,  1 Feb 2022 00:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643676727;
        bh=QOi8H3QAK1EPbB/Xm/Ov9s81bm+RTRA6MdtBDdjQxt4=;
        h=Date:To:From:Subject:From;
        b=HeaqmVmZgE1tfS8Mm9ZUwg2XcWpCNg1zzWWOk0Ot/5gIzFUfyxxX2/PGEG84oTKMI
         N3POAQd+D3sE/LYtcgD6C/2d5LgB404pYIXYP6SVY9TbMARSr+07oRsG89Km2Dt8j5
         aCpw5GbFtrIgZWiBEFynI/gGwhIT8DqsUvxwZvEc=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 16:52:05 -0800
Date:   Mon, 31 Jan 2022 16:52:05 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, david@redhat.com, catalin.marinas@arm.com,
        lang.yu@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-avoid-scanning-potential-huge-holes.patch added to -mm tree
Message-Id: <20220201005205.C129CC340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: avoid scanning potential huge holes
has been added to the -mm tree.  Its filename is
     mm-kmemleak-avoid-scanning-potential-huge-holes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-avoid-scanning-potential-huge-holes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-avoid-scanning-potential-huge-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lang Yu <lang.yu@amd.com>
Subject: mm/kmemleak: avoid scanning potential huge holes

When using devm_request_free_mem_region() and devm_memremap_pages() to add
ZONE_DEVICE memory, if requested free mem region's end pfn were huge(e.g.,
0x400000000), the node_end_pfn() will be also huge (see
move_pfn_range_to_zone()).  Thus it creates a huge hole between
node_start_pfn() and node_end_pfn().

We found on some AMD APUs, amdkfd requested such a free mem region and
created a huge hole.  In such a case, following code snippet was just
doing busy test_bit() looping on the huge hole.

for (pfn = start_pfn; pfn < end_pfn; pfn++) {
	struct page *page = pfn_to_online_page(pfn);
		if (!page)
			continue;
	...
}

So we got a soft lockup:

watchdog: BUG: soft lockup - CPU#6 stuck for 26s! [bash:1221]
CPU: 6 PID: 1221 Comm: bash Not tainted 5.15.0-custom #1
RIP: 0010:pfn_to_online_page+0x5/0xd0
Call Trace:
  ? kmemleak_scan+0x16a/0x440
  kmemleak_write+0x306/0x3a0
  ? common_file_perm+0x72/0x170
  full_proxy_write+0x5c/0x90
  vfs_write+0xb9/0x260
  ksys_write+0x67/0xe0
  __x64_sys_write+0x1a/0x20
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

I did some tests with the patch.

(1) amdgpu module unloaded

before the patch:

real    0m0.976s
user    0m0.000s
sys     0m0.968s

after the patch:

real    0m0.981s
user    0m0.000s
sys     0m0.973s

(2) amdgpu module loaded

before the patch:

real    0m35.365s
user    0m0.000s
sys     0m35.354s

after the patch:

real    0m1.049s
user    0m0.000s
sys     0m1.042s

Link: https://lkml.kernel.org/r/20211108140029.721144-1-lang.yu@amd.com
Signed-off-by: Lang Yu <lang.yu@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-avoid-scanning-potential-huge-holes
+++ a/mm/kmemleak.c
@@ -1410,7 +1410,8 @@ static void kmemleak_scan(void)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
-	int i;
+	struct zone *zone;
+	int __maybe_unused i;
 	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
@@ -1450,9 +1451,9 @@ static void kmemleak_scan(void)
 	 * Struct page scanning for each node.
 	 */
 	get_online_mems();
-	for_each_online_node(i) {
-		unsigned long start_pfn = node_start_pfn(i);
-		unsigned long end_pfn = node_end_pfn(i);
+	for_each_populated_zone(zone) {
+		unsigned long start_pfn = zone->zone_start_pfn;
+		unsigned long end_pfn = zone_end_pfn(zone);
 		unsigned long pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -1461,8 +1462,8 @@ static void kmemleak_scan(void)
 			if (!page)
 				continue;
 
-			/* only scan pages belonging to this node */
-			if (page_to_nid(page) != i)
+			/* only scan pages belonging to this zone */
+			if (page_zone(page) != zone)
 				continue;
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
_

Patches currently in -mm which might be from lang.yu@amd.com are

mm-kmemleak-avoid-scanning-potential-huge-holes.patch

