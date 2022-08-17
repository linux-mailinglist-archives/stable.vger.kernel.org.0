Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E076597535
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 19:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbiHQRkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiHQRke (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 13:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259EEA1D60;
        Wed, 17 Aug 2022 10:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B25806130D;
        Wed, 17 Aug 2022 17:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB374C433D6;
        Wed, 17 Aug 2022 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660758033;
        bh=7feCmyYjJaa/OtpqAtKKC4+5+SYOgtoU8HfXb+Sqpxw=;
        h=Date:To:From:Subject:From;
        b=G5fNu0atUa8fNf6CWQU3zK+UEUWj6hpprbH7AwLO8QkEmUqumEiBXRPP7NAyfIbrs
         RLtYVSET51IoQD0jhq7jwiNqNNQ+hSJ75m9/kkxJXRKUHScdP70nUBknqlXkIQt38f
         0bIdW6gGKxYviR/TCQcvkMQoq8Ms9L32ZNoPXy6I=
Date:   Wed, 17 Aug 2022 10:40:32 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-memcg-cleanup-racy-sum-avoidance-code.patch added to mm-hotfixes-unstable branch
Message-Id: <20220817174032.EB374C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Revert "memcg: cleanup racy sum avoidance code"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-memcg-cleanup-racy-sum-avoidance-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-memcg-cleanup-racy-sum-avoidance-code.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: Revert "memcg: cleanup racy sum avoidance code"
Date: Wed, 17 Aug 2022 17:21:39 +0000

This reverts commit 96e51ccf1af33e82f429a0d6baebba29c6448d0f.

Recently we started running the kernel with rstat infrastructure on
production traffic and begin to see negative memcg stats values. 
Particularly the 'sock' stat is the one which we observed having negative
value.

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 18446744073708724224

Re-run after couple of seconds

$ grep "sock " /mnt/memory/job/memory.stat
sock 253952
total_sock 53248

For now we are only seeing this issue on large machines (256 CPUs) and
only with 'sock' stat.  I think the networking stack increase the stat on
one cpu and decrease it on another cpu much more often.  So, this negative
sock is due to rstat flusher flushing the stats on the CPU that has seen
the decrement of sock but missed the CPU that has increments.  A typical
race condition.

For easy stable backport, revert is the most simple solution.  For long
term solution, I am thinking of two directions.  First is just reduce the
race window by optimizing the rstat flusher.  Second is if the reader sees
a negative stat value, force flush and restart the stat collection. 
Basically retry but limited.

Link: https://lkml.kernel.org/r/20220817172139.3141101-1-shakeelb@google.com
Fixes: 96e51ccf1af33e8 ("memcg: cleanup racy sum avoidance code")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>	[5.15]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~revert-memcg-cleanup-racy-sum-avoidance-code
+++ a/include/linux/memcontrol.h
@@ -987,19 +987,30 @@ static inline void mod_memcg_page_state(
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	return READ_ONCE(memcg->vmstats.state[idx]);
+	long x = READ_ONCE(memcg->vmstats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
+	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(pn->lruvec_stats.state[idx]);
+	x = READ_ONCE(pn->lruvec_stats.state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-memcg-cleanup-racy-sum-avoidance-code.patch

