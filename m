Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C2278855
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgIYMyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbgIYMyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAD1206DB;
        Fri, 25 Sep 2020 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038483;
        bh=8PR+7OGd/wvtWMCn9sP70IxmjSeqLsBEDbQSnvok9HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iI/iGr1ovgNHZlh8c5eOcAlrkvqCVCI0/TvRbE5Z+I3xCNhF4kz46GUHFO1QT9AB
         gPCAKaLKaTTeu6UKU5HhgVI0f4eqJOJylDbBwclUYpc1IJJrlN5niHNR7QI8cNjZ8O
         o+h7gQGPdNZzmiKjfgbIdmabT+0IramdVlDWU0kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Julius Hemanth Pitti <jpitti@cisco.com>
Subject: [PATCH 4.19 34/37] mm: memcg: fix memcg reclaim soft lockup
Date:   Fri, 25 Sep 2020 14:49:02 +0200
Message-Id: <20200925124726.085108517@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xunlei Pang <xlpang@linux.alibaba.com>

commit e3336cab2579012b1e72b5265adf98e2d6e244ad upstream.

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

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: http://lkml.kernel.org/r/1598495549-67324-1-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2708,6 +2708,14 @@ static bool shrink_node(pg_data_t *pgdat
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


