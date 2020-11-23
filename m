Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D964D2C079E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732563AbgKWMmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732598AbgKWMlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A9E12158C;
        Mon, 23 Nov 2020 12:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135263;
        bh=3ugDvJZN2qfOXCLJNPbVq0X1AObLKL2C7GE7kRxivEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sfz/z5fxn9sJHlsFGgJEvvylvq4G0BPsQFBGElss7oqb84RLyhVICYfIz0ZQUJhgk
         DFk0ID7GCSX8lDGUlcWShiAwlc+ZcifGfdf7IQr45ku97vuzqeRrA0VjUC+637APSC
         3UN8VQLskMhoSJ/lyWhFqyJTk/o+0cRsgRv8BlsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charan Teja Reddy <charante@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralph Siemsen <ralph.siemsen@linaro.org>
Subject: [PATCH 5.4 157/158] mm, page_alloc: skip ->waternark_boost for atomic order-0 allocations
Date:   Mon, 23 Nov 2020 13:23:05 +0100
Message-Id: <20201123121827.508841628@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <charante@codeaurora.org>

commit f80b08fc44536a311a9f3182e50f318b79076425 upstream.

When boosting is enabled, it is observed that rate of atomic order-0
allocation failures are high due to the fact that free levels in the
system are checked with ->watermark_boost offset.  This is not a problem
for sleepable allocations but for atomic allocations which looks like
regression.

This problem is seen frequently on system setup of Android kernel running
on Snapdragon hardware with 4GB RAM size.  When no extfrag event occurred
in the system, ->watermark_boost factor is zero, thus the watermark
configurations in the system are:

   _watermark = (
          [WMARK_MIN] = 1272, --> ~5MB
          [WMARK_LOW] = 9067, --> ~36MB
          [WMARK_HIGH] = 9385), --> ~38MB
   watermark_boost = 0

After launching some memory hungry applications in Android which can cause
extfrag events in the system to an extent that ->watermark_boost can be
set to max i.e.  default boost factor makes it to 150% of high watermark.

   _watermark = (
          [WMARK_MIN] = 1272, --> ~5MB
          [WMARK_LOW] = 9067, --> ~36MB
          [WMARK_HIGH] = 9385), --> ~38MB
   watermark_boost = 14077, -->~57MB

With default system configuration, for an atomic order-0 allocation to
succeed, having free memory of ~2MB will suffice.  But boosting makes the
min_wmark to ~61MB thus for an atomic order-0 allocation to be successful
system should have minimum of ~23MB of free memory(from calculations of
zone_watermark_ok(), min = 3/4(min/2)).  But failures are observed despite
system is having ~20MB of free memory.  In the testing, this is
reproducible as early as first 300secs since boot and with furtherlowram
configurations(<2GB) it is observed as early as first 150secs since boot.

These failures can be avoided by excluding the ->watermark_boost in
watermark caluculations for atomic order-0 allocations.

[akpm@linux-foundation.org: fix comment grammar, reflow comment]
[charante@codeaurora.org: fix suggested by Mel Gorman]
  Link: http://lkml.kernel.org/r/31556793-57b1-1c21-1a9d-22674d9bd938@codeaurora.org

Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Link: http://lkml.kernel.org/r/1589882284-21010-1-git-send-email-charante@codeaurora.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3484,7 +3484,8 @@ bool zone_watermark_ok(struct zone *z, u
 }
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
-		unsigned long mark, int classzone_idx, unsigned int alloc_flags)
+				unsigned long mark, int classzone_idx,
+				unsigned int alloc_flags, gfp_t gfp_mask)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 	long cma_pages = 0;
@@ -3505,8 +3506,23 @@ static inline bool zone_watermark_fast(s
 	if (!order && (free_pages - cma_pages) > mark + z->lowmem_reserve[classzone_idx])
 		return true;
 
-	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
-					free_pages);
+	if (__zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
+					free_pages))
+		return true;
+	/*
+	 * Ignore watermark boosting for GFP_ATOMIC order-0 allocations
+	 * when checking the min watermark. The min watermark is the
+	 * point where boosting is ignored so that kswapd is woken up
+	 * when below the low watermark.
+	 */
+	if (unlikely(!order && (gfp_mask & __GFP_ATOMIC) && z->watermark_boost
+		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
+		mark = z->_watermark[WMARK_MIN];
+		return __zone_watermark_ok(z, order, mark, classzone_idx,
+					alloc_flags, free_pages);
+	}
+
+	return false;
 }
 
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
@@ -3647,7 +3663,8 @@ retry:
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac_classzone_idx(ac), alloc_flags)) {
+				       ac_classzone_idx(ac), alloc_flags,
+				       gfp_mask)) {
 			int ret;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT


