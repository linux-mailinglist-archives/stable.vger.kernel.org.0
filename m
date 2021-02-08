Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9626A313765
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhBHPYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhBHPRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCBA64EE1;
        Mon,  8 Feb 2021 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797126;
        bh=FcRLTV92hDDizMMyrmm6ePyVSC5ysfWszMFF5A0drqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhEg6TV1ze9f3Ji9bjRuYVd8NTG/oVzyyWDyZIlTtilYHuDQR9vuwvcXk35exINoo
         NWaWJq2GtEmQ4eln7+Lie1qjNuCAjOpTIop8D7orhbxVahz+k3qKLUSaobV8WUs1OD
         WUd0/DlgLGWIlzDNYGeooXuLVsQHWtV5c90wT42Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rokudo Yan <wu-yan@tcl.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 52/65] mm, compaction: move high_pfn to the for loop scope
Date:   Mon,  8 Feb 2021 16:01:24 +0100
Message-Id: <20210208145812.227257840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rokudo Yan <wu-yan@tcl.com>

commit 74e21484e40bb8ce0f9828bbfe1c9fc9b04249c6 upstream.

In fast_isolate_freepages, high_pfn will be used if a prefered one (ie
PFN >= low_fn) not found.

But the high_pfn is not reset before searching an free area, so when it
was used as freepage, it may from another free area searched before.  As
a result move_freelist_head(freelist, freepage) will have unexpected
behavior (eg corrupt the MOVABLE freelist)

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

The issue was reported on an smart phone product with 6GB ram and 3GB
zram as swap device.

This patch fixes the issue by reset high_pfn before searching each free
area, which ensure freepage and freelist match when call
move_freelist_head in fast_isolate_freepages().

Link: http://lkml.kernel.org/r/20190118175136.31341-12-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210112094720.1238444-1-wu-yan@tcl.com
Fixes: 5a811889de10f1eb ("mm, compaction: use free lists to quickly locate a migration target")
Signed-off-by: Rokudo Yan <wu-yan@tcl.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1276,7 +1276,7 @@ fast_isolate_freepages(struct compact_co
 {
 	unsigned int limit = min(1U, freelist_scan_limit(cc) >> 1);
 	unsigned int nr_scanned = 0;
-	unsigned long low_pfn, min_pfn, high_pfn = 0, highest = 0;
+	unsigned long low_pfn, min_pfn, highest = 0;
 	unsigned long nr_isolated = 0;
 	unsigned long distance;
 	struct page *page = NULL;
@@ -1321,6 +1321,7 @@ fast_isolate_freepages(struct compact_co
 		struct page *freepage;
 		unsigned long flags;
 		unsigned int order_scanned = 0;
+		unsigned long high_pfn = 0;
 
 		if (!area->nr_free)
 			continue;


