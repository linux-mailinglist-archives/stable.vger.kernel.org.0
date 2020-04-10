Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096E71A4B96
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 23:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDJVcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 17:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BABFD20936;
        Fri, 10 Apr 2020 21:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586554340;
        bh=0fIlDT5NiITLoRiD3U0UD6TiCwNXseNC8+Gt48gQQF0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A9BBea+d8vz8y4lEs15ToCBipFTySyPtWSV/9DZuNrjCJ6/dAsfs6csEfS+DK+Z6I
         UFHMpNFK9eXUcuc/A2pMbgEgJCaVC3RCqBpm05g4vlgHM1Z42C1f8KkV5T8HPpt+de
         nbfGP/toxJOUkmPb4mcZu0e8sFeKbIZvd9baDzOo=
Date:   Fri, 10 Apr 2020 14:32:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, kuba@kernel.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 02/35] mm, memcg: do not high throttle allocators
 based on wraparound
Message-ID: <20200410213219.Qt50SPoTu%akpm@linux-foundation.org>
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
