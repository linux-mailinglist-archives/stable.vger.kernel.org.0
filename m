Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E579719B7FC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 23:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgDAV5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 17:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732527AbgDAV5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 17:57:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD8CF2054F;
        Wed,  1 Apr 2020 21:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585778223;
        bh=/YyxLCzFdEXtW2VuPeIeEIvL8UNJ9V1HIkiV7d88PYY=;
        h=Date:From:To:Subject:From;
        b=IYVnM2c6rcG3DB3v2Sx9yE4vYVYChu8eakL5k2S5Bivb3YZh14HlabDbkQ8hqbq+8
         Hi8ugPdBDJ3b7B7PvZlCg/Cf1lyhOAQGHJ+d+zl//gZneaATX8koHgEKL9cJ7CLgXz
         CWb5v1p1UZm7cNv2fWBPw+o2a0Bz6SIyFlx/Fcfk=
Date:   Wed, 01 Apr 2020 14:57:02 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, kuba@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch added to
 -mm tree
Message-ID: <20200401215702.N700c1Mno%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, memcg: Do not high throttle allocators based on wraparound
has been added to the -mm tree.  Its filename is
     mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jakub Kicinski <kuba@kernel.org>
Subject: mm, memcg: Do not high throttle allocators based on wraparound

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
@@ -2324,6 +2324,9 @@ static unsigned long calculate_high_dela
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

mm-memcg-do-not-high-throttle-allocators-based-on-wraparound.patch

