Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3BA2F3F95
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbhALW2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 17:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393152AbhALW2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 17:28:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D963C2312E;
        Tue, 12 Jan 2021 22:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610490446;
        bh=LD2De/8Cv30EnmDeMrMimhErOSc4FsKTgEp/E78081w=;
        h=Date:From:To:Subject:From;
        b=gga0bl1TYEJb5b2yd7Y40NA681A9mV4NHYNW0jv025vcrM4l6tyxHbJtRUj9JcQEN
         GAW6Pk/od59yzX1fTJeXC2a0tuhOQ+Dpit3lQ/XZM5cUj8qzw5rzmcRNhdu6Q/lU4s
         rIq0eiy4vWKP7SR3YghWFUyMdn7GI2j4LCugVZEI=
Date:   Tue, 12 Jan 2021 14:27:25 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz, wu-yan@tcl.com
Subject:  + mm-compaction-move-high_pfn-to-the-for-loop-scope.patch
 added to -mm tree
Message-ID: <20210112222725.GdMhWf999%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, compaction: move high_pfn to the for loop scope
has been added to the -mm tree.  Its filename is
     mm-compaction-move-high_pfn-to-the-for-loop-scope.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-move-high_pfn-to-the-for-loop-scope.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-move-high_pfn-to-the-for-loop-scope.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rokudo Yan <wu-yan@tcl.com>
Subject: mm, compaction: move high_pfn to the for loop scope

In fast_isolate_freepages, high_pfn will be used if a prefered one(PFN >=
low_fn) not found.  But the high_pfn is not reset before searching an free
area, so when it was used as freepage, it may from another free area
searched before.  And move_freelist_head(freelist, freepage) will have
unexpected behavior(eg.  corrupt the MOVABLE freelist)

Unable to handle kernel paging request at virtual address dead000000000200
Mem abort info:
  ESR = 0x96000044
  Exception class = DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000044
  CM = 0, WnR = 1
[dead000000000200] address between user and kernel address ranges

-000|list_cut_before(inline)
-000|move_freelist_head(inline)
-000|fast_isolate_freepages(inline)
-000|isolate_freepages(inline)
-000|compaction_alloc(?, ?)
-001|unmap_and_move(inline)
-001|migrate_pages([NSD:0xFFFFFF80088CBBD0] from = 0xFFFFFF80088CBD88, [NSD:0xFFFFFF80088CBBC8] get_new_p
-002|__read_once_size(inline)
-002|static_key_count(inline)
-002|static_key_false(inline)
-002|trace_mm_compaction_migratepages(inline)
-002|compact_zone(?, [NSD:0xFFFFFF80088CBCB0] capc = 0x0)
-003|kcompactd_do_work(inline)
-003|kcompactd([X19] p = 0xFFFFFF93227FBC40)
-004|kthread([X20] _create = 0xFFFFFFE1AFB26380)
-005|ret_from_fork(asm)
---|end of frame

The issue was reported on an smart phone product with 6GB ram and 3GB zram
as swap device.

This patch fixes the issue by reset high_pfn before searching each free
area, which ensure freepage and freelist match when call
move_freelist_head in fast_isolate_freepages().

Link: http://lkml.kernel.org/r/20190118175136.31341-12-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210112094720.1238444-1-wu-yan@tcl.com
Fixes: 5a811889de10f1eb ("mm, compaction: use free lists to quickly locate a migration target")
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-move-high_pfn-to-the-for-loop-scope
+++ a/mm/compaction.c
@@ -1342,7 +1342,7 @@ fast_isolate_freepages(struct compact_co
 {
 	unsigned int limit = min(1U, freelist_scan_limit(cc) >> 1);
 	unsigned int nr_scanned = 0;
-	unsigned long low_pfn, min_pfn, high_pfn = 0, highest = 0;
+	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
 	unsigned long distance;
 	struct page *page = NULL;
@@ -1387,6 +1387,7 @@ fast_isolate_freepages(struct compact_co
 		struct page *freepage;
 		unsigned long flags;
 		unsigned int order_scanned = 0;
+		unsigned long high_pfn = 0;
 
 		if (!area->nr_free)
 			continue;
_

Patches currently in -mm which might be from wu-yan@tcl.com are

mm-compaction-move-high_pfn-to-the-for-loop-scope.patch

