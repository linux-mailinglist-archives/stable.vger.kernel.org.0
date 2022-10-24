Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A7D60A3A5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiJXL6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiJXL5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:57:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC317B291;
        Mon, 24 Oct 2022 04:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B613F6127C;
        Mon, 24 Oct 2022 11:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEB9C433D6;
        Mon, 24 Oct 2022 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612009;
        bh=K/c6XQ+gFvyQ0ATbI42PrHcCDyBqGeoD3Q9VPyxm/AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOZSiTBWO+jsS6p27NZUk+k63TQC1TO2cXVRtq/irVcdiwhVbn4LkOCZo4wTOLtnj
         9fDEzhhDdxlvgcHWdOS8la2IlKPOvkn+/VFjmmajTYz4N9yJtCn17x5K+YhIEqzdUx
         +mhf6lmCfJxys3OuhVIaiN0OMPf2gJ5cJQnRov2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Patrick Daly <quic_pdaly@quicinc.com>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 007/210] mm/page_alloc: fix race condition between build_all_zonelists and page allocation
Date:   Mon, 24 Oct 2022 13:28:44 +0200
Message-Id: <20221024112957.107712342@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 3d36424b3b5850bd92f3e89b953a430d7cfc88ef upstream.

Patrick Daly reported the following problem;

	NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK] - before offline operation
	[0] - ZONE_MOVABLE
	[1] - ZONE_NORMAL
	[2] - NULL

	For a GFP_KERNEL allocation, alloc_pages_slowpath() will save the
	offset of ZONE_NORMAL in ac->preferred_zoneref. If a concurrent
	memory_offline operation removes the last page from ZONE_MOVABLE,
	build_all_zonelists() & build_zonerefs_node() will update
	node_zonelists as shown below. Only populated zones are added.

	NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK] - after offline operation
	[0] - ZONE_NORMAL
	[1] - NULL
	[2] - NULL

The race is simple -- page allocation could be in progress when a memory
hot-remove operation triggers a zonelist rebuild that removes zones.  The
allocation request will still have a valid ac->preferred_zoneref that is
now pointing to NULL and triggers an OOM kill.

This problem probably always existed but may be slightly easier to trigger
due to 6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones
with pages managed by the buddy allocator") which distinguishes between
zones that are completely unpopulated versus zones that have valid pages
not managed by the buddy allocator (e.g.  reserved, memblock, ballooning
etc).  Memory hotplug had multiple stages with timing considerations
around managed/present page updates, the zonelist rebuild and the zone
span updates.  As David Hildenbrand puts it

	memory offlining adjusts managed+present pages of the zone
	essentially in one go. If after the adjustments, the zone is no
	longer populated (present==0), we rebuild the zone lists.

	Once that's done, we try shrinking the zone (start+spanned
	pages) -- which results in zone_start_pfn == 0 if there are no
	more pages. That happens *after* rebuilding the zonelists via
	remove_pfn_range_from_zone().

The only requirement to fix the race is that a page allocation request
identifies when a zonelist rebuild has happened since the allocation
request started and no page has yet been allocated.  Use a seqlock_t to
track zonelist updates with a lockless read-side of the zonelist and
protecting the rebuild and update of the counter with a spinlock.

[akpm@linux-foundation.org: make zonelist_update_seq static]
Link: https://lkml.kernel.org/r/20220824110900.vh674ltxmzb3proq@techsingularity.net
Fixes: 6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones with pages managed by the buddy allocator")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Patrick Daly <quic_pdaly@quicinc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   53 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3567,6 +3567,30 @@ void fs_reclaim_release(gfp_t gfp_mask)
 EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
+/*
+ * Zonelists may change due to hotplug during allocation. Detect when zonelists
+ * have been rebuilt so allocation retries. Reader side does not lock and
+ * retries the allocation if zonelist changes. Writer side is protected by the
+ * embedded spin_lock.
+ */
+static DEFINE_SEQLOCK(zonelist_update_seq);
+
+static unsigned int zonelist_iter_begin(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqbegin(&zonelist_update_seq);
+
+	return 0;
+}
+
+static unsigned int check_retry_zonelist(unsigned int seq)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+		return read_seqretry(&zonelist_update_seq, seq);
+
+	return seq;
+}
+
 /* Perform direct synchronous page reclaim */
 static int
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -3870,6 +3894,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int compaction_retries;
 	int no_progress_loops;
 	unsigned int cpuset_mems_cookie;
+	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
 	/*
@@ -3880,11 +3905,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
 		gfp_mask &= ~__GFP_ATOMIC;
 
-retry_cpuset:
+restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
+	zonelist_iter_cookie = zonelist_iter_begin();
 
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
@@ -4032,9 +4058,13 @@ retry:
 		goto retry;
 
 
-	/* Deal with possible cpuset update races before we start OOM killing */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
@@ -4054,9 +4084,13 @@ retry:
 	}
 
 nopage:
-	/* Deal with possible cpuset update races before we fail */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac))
-		goto retry_cpuset;
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * a unnecessary OOM kill.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
 
 	/*
 	 * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
@@ -5167,9 +5201,8 @@ static void __build_all_zonelists(void *
 	int nid;
 	int __maybe_unused cpu;
 	pg_data_t *self = data;
-	static DEFINE_SPINLOCK(lock);
 
-	spin_lock(&lock);
+	write_seqlock(&zonelist_update_seq);
 
 #ifdef CONFIG_NUMA
 	memset(node_load, 0, sizeof(node_load));
@@ -5202,7 +5235,7 @@ static void __build_all_zonelists(void *
 #endif
 	}
 
-	spin_unlock(&lock);
+	write_sequnlock(&zonelist_update_seq);
 }
 
 static noinline void __init


