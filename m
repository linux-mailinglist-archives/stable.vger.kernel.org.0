Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2824C1CA025
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHBg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgEHBg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 21:36:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6ABE208DB;
        Fri,  8 May 2020 01:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588901788;
        bh=g0pEyyb/gsTGB3SkdWVyxw/OBrmAQIsbGx8qcRgJoGs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GdEwiPj24EfE5S72ehXb90qsiV5hL36FVgCDWdXZXwFjLGRB2huzo9vqYe9r+FUGl
         7rwXl0Syquop2mR9IQe1RbYTOBWPd8amqQ02T3Zc1UBLkITNS1HZ9aco5WHxD97eQV
         X0U6K08aVSEe4OBFGmi8SqmyLF3PeG+KN/KJYXOY=
Date:   Thu, 07 May 2020 18:36:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        henry.willard@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 15/15] mm: limit boost_watermark on small zones
Message-ID: <20200508013627.uDh87VOZJ%akpm@linux-foundation.org>
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
