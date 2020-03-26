Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94498194658
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 19:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgCZSQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 14:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbgCZSQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 14:16:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CECD2073E;
        Thu, 26 Mar 2020 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585246562;
        bh=JeqDLdQ9svri9J3EgtQc0BLe7pbnq00I1V8RvRH2Uk8=;
        h=Date:From:To:Subject:From;
        b=GET51wPVHRfr3tnLy8zZ4+46UaSsxhOs0O9TQf5aO4QMh3kvoQAzWPz31QktHpUdi
         QB18qKFyO7oRx9JTFkDYJhLilhxYqwQTryhLPk2yeyUD2snRHwCF6QBbXXcnGhEOGS
         4RAXvc7SQHh9ks7EIKPC3IEmjE9u1y8/NRd2/JOs=
Date:   Thu, 26 Mar 2020 11:16:02 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, stable@vger.kernel.org, tj@kernel.org
Subject:  [merged]
 mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
 removed from -mm tree
Message-ID: <20200326181602.7yLEsvDFG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix corruption on 64-bit divisor in memory.high throttling
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: fix corruption on 64-bit divisor in memory.high throttling

0e4b01df8659 had a bunch of fixups to use the right division method. 
However, it seems that after all that it still wasn't right -- div_u64
takes a 32-bit divisor.

The headroom is still large (2^32 pages), so on mundane systems you won't
hit this, but this should definitely be fixed.

Link: http://lkml.kernel.org/r/80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name
Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Signed-off-by: Chris Down <chris@chrisdown.name>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling
+++ a/mm/memcontrol.c
@@ -2339,7 +2339,7 @@ void mem_cgroup_handle_over_high(void)
 	 */
 	clamped_high = max(high, 1UL);
 
-	overage = div_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
+	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
 			  clamped_high);
 
 	penalty_jiffies = ((u64)overage * overage * HZ)
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-prevent-memoryhigh-load-store-tearing.patch
mm-memcg-prevent-memorymax-load-tearing.patch
mm-memcg-prevent-memorylow-load-store-tearing.patch
mm-memcg-prevent-memorymin-load-store-tearing.patch
mm-memcg-prevent-memoryswapmax-load-tearing.patch
mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
mm-memcg-bypass-high-reclaim-iteration-for-cgroup-hierarchy-root.patch

