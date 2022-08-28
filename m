Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C697B5A3FC8
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiH1VDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 17:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiH1VDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 17:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22A931239;
        Sun, 28 Aug 2022 14:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C8A1B80BA0;
        Sun, 28 Aug 2022 21:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154EEC433B5;
        Sun, 28 Aug 2022 21:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720610;
        bh=T39xIhfHyNG5cIqo0MXPecY9QIWHNzWf7zBXm7y0I3Q=;
        h=Date:To:From:Subject:From;
        b=EnVzk3vUXmLuP+xk2exhcuJ7nBlEcHo5ztHqVwuk6iQGK+Tnv/Lr5pq9NG0HRuNNG
         /f9j8ywIzbO/CnPYZA89uCDvPRc/qIQUHw6QheyQQTx4ybBtbpVi+a/EVrbTWyVIGo
         D5TgzTN26Scrb9AGT3kSgQhcHMbqCLX7gs7lhsiM=
Date:   Sun, 28 Aug 2022 14:03:29 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-memcg-cleanup-racy-sum-avoidance-code.patch removed from -mm tree
Message-Id: <20220828210330.154EEC433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: Revert "memcg: cleanup racy sum avoidance code"
has been removed from the -mm tree.  Its filename was
     revert-memcg-cleanup-racy-sum-avoidance-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch
mm-deduplicate-cacheline-padding-code.patch

