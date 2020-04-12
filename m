Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD711A5D0D
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 08:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgDLGod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 02:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGod (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2450206B8;
        Sun, 12 Apr 2020 06:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586673871;
        bh=S8MuRBUHITKrhU0rIXWeZrK+yG9dp8SrDJ38kejDDKY=;
        h=Date:From:To:Subject:From;
        b=rDUnddySReKTKSLkp1Mmn7THmykVFnnvdY7F4dpyDT8pYKiOOBAzLmz7ph+RuhLnb
         2IQKfEs7qG8BbedqIIa/1UgoZOu3Yv7Z6prDktaK5f6pmtzSbC8IBR8GXm9Gh4qogw
         A9tV8I+kFAw/8f1HVYhmnreBOjkpNRkPppXqnC9E=
Date:   Sat, 11 Apr 2020 23:44:31 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, kuba@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch removed
 from -mm tree
Message-ID: <20200412064431.OGZxycsHz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memcg: do not high throttle allocators based on wraparound
has been removed from the -mm tree.  Its filename was
     mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jakub Kicinski <kuba@kernel.org>
Subject: mm, memcg: do not high throttle allocators based on wraparound

If a cgroup violates its memory.high constraints, we may end up unduly
penalising it.  For example, for the following hierarchy:

A:   max high, 20 usage
A/B: 9 high, 10 usage
A/C: max high, 10 usage

We would end up doing the following calculation below when calculating
high delay for A/B:

A/B: 10 - 9 = 1...
A:   20 - PAGE_COUNTER_MAX = 21, so set max_overage to 21.

This gets worse with higher disparities in usage in the parent.

I have no idea how this disappeared from the final version of the patch,
but it is certainly Not Good(tm).  This wasn't obvious in testing because,
for a simple cgroup hierarchy with only one child, the result is usually
roughly the same.  It's only in more complex hierarchies that things go
really awry (although still, the effects are limited to a maximum of 2
seconds in schedule_timeout_killable at a maximum).

[chris@chrisdown.name: changelog]
Link: http://lkml.kernel.org/r/20200331152424.GA1019937@chrisdown.name
Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[5.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-do-not-high-throttle-allocators-based-on-wraparound
+++ a/mm/memcontrol.c
@@ -2336,6 +2336,9 @@ static unsigned long calculate_high_dela
 		usage = page_counter_read(&memcg->memory);
 		high = READ_ONCE(memcg->high);
 
+		if (usage <= high)
+			continue;
+
 		/*
 		 * Prevent division by 0 in overage calculation by acting as if
 		 * it was a threshold of 1 page
_

Patches currently in -mm which might be from kuba@kernel.org are


