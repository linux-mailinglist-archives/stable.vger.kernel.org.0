Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F393F273170
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgIUSFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:05:22 -0400
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:17335 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUSFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2779; q=dns/txt; s=iport;
  t=1600711521; x=1601921121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=55OSFt5kaSEbClnnpjCew/8FmYUswx3xHzShH3i3E8s=;
  b=EiNz9yIXnvORF69Rd5WrayIhB5E7zBychkC155+ODFSfeVqcEjnllCRs
   vCUP5K1Pk5laZhp54/14OFRiFZIlWFdcsFAKCuONcR5CHBlbdu7Bxvllj
   9WhRIwK7g2bf9oyokGGoXtnYbaZ+5Ad9tzW/+7wPObKgjvbGbJVxn79zm
   4=;
X-IronPort-AV: E=Sophos;i="5.77,287,1596499200"; 
   d="scan'208";a="736845470"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Sep 2020 18:05:21 +0000
Received: from sjc-ads-9087.cisco.com (sjc-ads-9087.cisco.com [10.30.208.97])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTP id 08LI5Kmu015951;
        Mon, 21 Sep 2020 18:05:21 GMT
Received: by sjc-ads-9087.cisco.com (Postfix, from userid 396877)
        id A404EBAE; Mon, 21 Sep 2020 11:05:20 -0700 (PDT)
From:   Julius Hemanth Pitti <jpitti@cisco.com>
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        xlpang@linux.alibaba.com, mhocko@suse.com, vdavydov.dev@gmail.com,
        ktkhai@virtuozzo.com, hannes@cmpxchg.org
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Julius Hemanth Pitti <jpitti@cisco.com>
Subject: [PATCH stable v5.4] mm: memcg: fix memcg reclaim soft lockup
Date:   Mon, 21 Sep 2020 11:05:08 -0700
Message-Id: <20200921180508.61905-1-jpitti@cisco.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.30.208.97, sjc-ads-9087.cisco.com
X-Outbound-Node: alln-core-11.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>

commit e3336cab2579012b1e72b5265adf98e2d6e244ad upstream

We've met softlockup with "CONFIG_PREEMPT_NONE=y", when the target memcg
doesn't have any reclaimable memory.

It can be easily reproduced as below:

  watchdog: BUG: soft lockup - CPU#0 stuck for 111s![memcg_test:2204]
  CPU: 0 PID: 2204 Comm: memcg_test Not tainted 5.9.0-rc2+ #12
  Call Trace:
    shrink_lruvec+0x49f/0x640
    shrink_node+0x2a6/0x6f0
    do_try_to_free_pages+0xe9/0x3e0
    try_to_free_mem_cgroup_pages+0xef/0x1f0
    try_charge+0x2c1/0x750
    mem_cgroup_charge+0xd7/0x240
    __add_to_page_cache_locked+0x2fd/0x370
    add_to_page_cache_lru+0x4a/0xc0
    pagecache_get_page+0x10b/0x2f0
    filemap_fault+0x661/0xad0
    ext4_filemap_fault+0x2c/0x40
    __do_fault+0x4d/0xf9
    handle_mm_fault+0x1080/0x1790

It only happens on our 1-vcpu instances, because there's no chance for
oom reaper to run to reclaim the to-be-killed process.

Add a cond_resched() at the upper shrink_node_memcgs() to solve this
issue, this will mean that we will get a scheduling point for each memcg
in the reclaimed hierarchy without any dependency on the reclaimable
memory in that memcg thus making it more predictable.

[jpitti@cisco.com:
   - backported to v5.4.y
   - Upstream patch applies fix in shrink_node_memcgs(), which
     is not present to v5.4.y. Appled to shrink_node()]

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: http://lkml.kernel.org/r/1598495549-67324-1-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
Cc: stable@vger.kernel.org
Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
---
 mm/vmscan.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7fde5f904c8d..6db9176d8c63 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2775,6 +2775,14 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			unsigned long reclaimed;
 			unsigned long scanned;
 
+			/*
+			 * This loop can become CPU-bound when target memcgs
+			 * aren't eligible for reclaim - either because they
+			 * don't have any reclaimable pages, or because their
+			 * memory is explicitly protected. Avoid soft lockups.
+			 */
+			cond_resched();
+
 			switch (mem_cgroup_protected(root, memcg)) {
 			case MEMCG_PROT_MIN:
 				/*
-- 
2.17.1

