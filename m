Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691B21CBAC1
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgEHWc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 18:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgEHWc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 18:32:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5E72184D;
        Fri,  8 May 2020 22:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588977178;
        bh=ftXwnxgyqH4dsuqTpqnd8sA5u4+9ZzmbWu7v6k8247s=;
        h=Date:From:To:Subject:From;
        b=eHdp4j1GjB4myYUFBQ7/ICWvlvf7ImqqJIbboyaxBAoXTXFVNyIAVBrWhgvX94tGg
         XDoKt3cM/k4FFKYwj3KYWoDcKCClRu7xigojj5dbQ7VhqgCa0womqm2GfcgzRgRgWE
         CFy9F/8o4Bsx9/80+PulxTQrrtd1oS6eHXdMF9VM=
Date:   Fri, 08 May 2020 15:32:57 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, henry.willard@oracle.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged] mm-limit-boost_watermark-on-small-zones.patch
 removed from -mm tree
Message-ID: <20200508223257.HG_RRsUPm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: limit boost_watermark on small zones
has been removed from the -mm tree.  Its filename was
     mm-limit-boost_watermark-on-small-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Willard <henry.willard@oracle.com>
Subject: mm: limit boost_watermark on small zones

Commit 1c30844d2dfe ("mm: reclaim small amounts of memory when an external
fragmentation event occurs") adds a boost_watermark() function which
increases the min watermark in a zone by at least pageblock_nr_pages or
the number of pages in a page block. On Arm64, with 64K pages and 512M
huge pages, this is 8192 pages or 512M. It does this regardless of the
number of managed pages managed in the zone or the likelihood of success.
This can put the zone immediately under water in terms of allocating pages
from the zone, and can cause a small machine to fail immediately due to
OoM. Unlike set_recommended_min_free_kbytes(), which substantially
increases min_free_kbytes and is tied to THP, boost_watermark() can be
called even if THP is not active. The problem is most likely to appear
on architectures such as Arm64 where pageblock_nr_pages is very large.

It is desirable to run the kdump capture kernel in as small a space as
possible to avoid wasting memory. In some architectures, such as Arm64,
there are restrictions on where the capture kernel can run, and therefore,
the space available. A capture kernel running in 768M can fail due to OoM
immediately after boost_watermark() sets the min in zone DMA32, where
most of the memory is, to 512M. It fails even though there is over 500M of
free memory. With boost_watermark() suppressed, the capture kernel can run
successfully in 448M.

This patch limits boost_watermark() to boosting a zone's min watermark only
when there are enough pages that the boost will produce positive results.
In this case that is estimated to be four times as many pages as
pageblock_nr_pages.

Mel said:

: There is no harm in marking it stable.  Clearly it does not happen very
: often but it's not impossible.  32-bit x86 is a lot less common now
: which would previously have been vulnerable to triggering this easily. 
: ppc64 has a larger base page size but typically only has one zone. 
: arm64 is likely the most vulnerable, particularly when CMA is
: configured with a small movable zone.

Link: http://lkml.kernel.org/r/1588294148-6586-1-git-send-email-henry.willard@oracle.com
Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Signed-off-by: Henry Willard <henry.willard@oracle.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c~mm-limit-boost_watermark-on-small-zones
+++ a/mm/page_alloc.c
@@ -2401,6 +2401,14 @@ static inline void boost_watermark(struc
 
 	if (!watermark_boost_factor)
 		return;
+	/*
+	 * Don't bother in zones that are unlikely to produce results.
+	 * On small machines, including kdump capture kernels running
+	 * in a small area, boosting the watermark can cause an out of
+	 * memory situation immediately.
+	 */
+	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
+		return;
 
 	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
 			watermark_boost_factor, 10000);
_

Patches currently in -mm which might be from henry.willard@oracle.com are


