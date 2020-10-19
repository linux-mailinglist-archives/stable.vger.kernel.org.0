Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCF292DA3
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 20:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgJSSkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgJSSkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 14:40:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B30C0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 11:40:36 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p15so951848ioh.0
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 11:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M9iLeKVp3nEaJ65+HjYKGrEoohnZIpxfdaQ1MUWPtik=;
        b=XOBQwAqFu1fNKsYXa1rDfMAvWGF1Lyv0OQg5cOxKv+52V+dAgknCxWle4pmYrjrGWF
         Ts85Ms5oP6tqYqLt9H+yt61luBwVw95BSEQm72ffhTqpRZpe70TnSuNh4cRYXrgjeYuA
         bN0GgubH43uabNyI8ZkCxHp5uwVB4iA1vgoP4xX9dt2Lf70uanwld8k+VXgjHpCfSRId
         lodC4OX2UK8lCE/4VzHkUIdf6SAvANJCXC1mIH5ra19atDE6QEIHIminYcwT9CeeY85j
         zPhPCWFuRthLziVp6fgDOeBpDdfchlMM0OPFG+cALWf5Pf+cxKL5HsaBuMTDP3uAMhR2
         UsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M9iLeKVp3nEaJ65+HjYKGrEoohnZIpxfdaQ1MUWPtik=;
        b=Qsa0Q7DdqvEhG5Nk2VtkyNr6kCoVuLX9l3Z2+pxCM4yW7/Zss152RAepMhNx2AqQo5
         aZMjnmtaXQo/TdeXnT3hYUGJEFm84H5OEF1ENihOYyNnrDWZIs7cwK0ED7TJsi0g8Al9
         Nws97wJX+FSCpXEIupp08vRw4NlncJb1RsZQ1MAcj8KHvBf4h6fIjjQayDN2bJbwFuAG
         ybkEuOoFBvIjJRi1Of+ah6+NYdAt8SQBCs5nxmcX5snAdoFHpUBdrAB//W9hojNcSHdL
         j/3PRTqnjbv8HnQ0BCT7jHpTs7D8s7kTBFIxYor5tUtQ5GCLMx/q5IpYB19mTZI1vciQ
         ghTg==
X-Gm-Message-State: AOAM532J6KOdZ2ZKc38loac3zWzDOtTSgW2iBPLcZJLhUxlK8yu56h1k
        MpG+jJGwMfJmM2vCnmFCkhI4XA==
X-Google-Smtp-Source: ABdhPJwGuj/LaDCk9GYBi2KaN9NrA7sl8nQaLWLXCPHIlpaB0MoKs+G4iOZ2D9dgWP3hsGlstOygWg==
X-Received: by 2002:a6b:7942:: with SMTP id j2mr664217iop.73.1603132836151;
        Mon, 19 Oct 2020 11:40:36 -0700 (PDT)
Received: from maple.netwinder.org (rfs.netwinder.org. [206.248.184.2])
        by smtp.gmail.com with ESMTPSA id t26sm436320ioi.11.2020.10.19.11.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 11:40:35 -0700 (PDT)
From:   Ralph Siemsen <ralph.siemsen@linaro.org>
To:     akpm@linux-foundation.org
Cc:     charante@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        vinmenon@codeaurora.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ralph Siemsen <ralph.siemsen@linaro.org>
Subject: Re: [PATCH] mm, page_alloc: skip ->watermark_boost for atomic order-0 allocations-fix
Date:   Mon, 19 Oct 2020 14:40:17 -0400
Message-Id: <20201019184017.6340-1-ralph.siemsen@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617171518.96211e345de65c54b9343a3a@linux-foundation.org>
References: <20200617171518.96211e345de65c54b9343a3a@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the patch from this thread to 5.8.y:
commit f80b08fc44536a311a9f3182e50f318b79076425

The fix should also go into 5.4.y, however the patch needs some minor
adjustments due to surrounding context differences. Attached below is a
version I have tested against 5.4.71.

This solves a "page allocation failure" error that can be reproduced
both on physical hardware, and also under qemu-system-arm. The test
consists of repeatedly running md5sum on a large file. In my tests the
file contains 1GB of random data, while the system has only 256MB RAM. 
No other tasks are running or consuming significant memory. 

After some time (between 1 and 200 iterations) the kernel reports a page
allocation failure. Additional failures occur fairly quickly thereafter.
The md5sum is correctly computed in each case. The OOM is not invoked.
The backtrace shows a 0-order GFP_ATOMIC was requested, with quite a
bit of memory available, and yet the allocation fails.

Similar error also occurs when "md5sum" is replaced by "scp" or "nc".
The backtrace again shows a 0-order with GFP_ATOMIC that fails, with
plenty of memory available according to the Mem-Info dump.

The problem does not occur under 4.9.y or 4.19.y. Bisction has found
that the problem started to occur with 688fcbfc06e4 ("mm/vmalloc: modify
struct vmap_area to reduce its size") during the 5.4 dev cycle.

I can provide additional logs and details if interested.

Thanks,
Ralph

Below is the f80b08fc445 commit, tweaked to apply to 5.4.y.

From: Charan Teja Reddy <charante@codeaurora.org>
Subject: [PATCH] mm, page_alloc: skip ->waternark_boost for atomic order-0
 allocations

[upstream commit f80b08fc44536a311a9f3182e50f318b79076425
 with context adjusted to match linux-5.4.y]

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
---
 mm/page_alloc.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aff0bb4629bd..b0e9ea4c220e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3484,7 +3484,8 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 }
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
-		unsigned long mark, int classzone_idx, unsigned int alloc_flags)
+				unsigned long mark, int classzone_idx,
+				unsigned int alloc_flags, gfp_t gfp_mask)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 	long cma_pages = 0;
@@ -3505,8 +3506,23 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
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
@@ -3647,7 +3663,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac_classzone_idx(ac), alloc_flags)) {
+				       ac_classzone_idx(ac), alloc_flags,
+				       gfp_mask)) {
 			int ret;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-- 
2.17.1

