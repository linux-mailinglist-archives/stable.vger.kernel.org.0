Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B82D5A4AA8
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiH2LqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiH2Lpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086858605E;
        Mon, 29 Aug 2022 04:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B206122E;
        Mon, 29 Aug 2022 11:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C07CC433C1;
        Mon, 29 Aug 2022 11:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771963;
        bh=PzW5OzWOz9p821aITep6E6NYhopT2BIaxkYgtQcogvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5Bk2qgKmPyq3MXrhPl0gwLdphnP3wjlEiSvdqfHcKy//lemQEtW0eYAwj8log51J
         IJQcHRisZfNwyHg0ea+dk1vu1y3Zd+b8KEO8fqqRMaSOfnuCqoUkxsABuO0dZz7WF2
         FuS6QlDQIkVDk2pAqGi1FFSyijZJH+YMSk5y+f64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 122/158] Revert "memcg: cleanup racy sum avoidance code"
Date:   Mon, 29 Aug 2022 12:59:32 +0200
Message-Id: <20220829105814.236082185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit dbb16df6443c59e8a1ef21c2272fcf387d600ddf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -978,19 +978,30 @@ static inline void mod_memcg_page_state(
 
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


