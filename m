Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F5E183C97
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCLWfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgCLWfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:35:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127EF20637;
        Thu, 12 Mar 2020 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584052551;
        bh=SfqP7PEMaKf+gRsPXn7apmeBBbzuIezfP5hhZsmY+hU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RKQs2VugEHice05kzDYI/9udOzWQKjQ4MNbDU8VjC27BLdR66A2anhgKgPtZ7Bq9g
         k/EvdF3S/NJUOzzxVOr0CgN3z5NXhfXOgFhshSrMCVMe+kMW6/cI7GqZT2g/RB7BZB
         nMoE18ookwiQHryxF6UHen4zFv8zr896t4B81av8=
Date:   Thu, 12 Mar 2020 15:35:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, stable@vger.kernel.org, tj@kernel.org
Subject:  +
 mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
 added to -mm tree
Message-ID: <20200312223550.r2GLIpLEX%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix corruption on 64-bit divisor in memory.high throttling
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2350,7 +2350,7 @@ void mem_cgroup_handle_over_high(void)
 	 */
 	clamped_high = max(high, 1UL);
 
-	overage = div_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
+	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
 			  clamped_high);
 
 	penalty_jiffies = ((u64)overage * overage * HZ)
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh.patch

