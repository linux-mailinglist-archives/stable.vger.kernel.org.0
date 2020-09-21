Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC86E272EFB
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgIUQx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgIUQr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A900220874;
        Mon, 21 Sep 2020 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706848;
        bh=7qjXt93LqJLtIYJoIL/cVsDmkkZU509KBhIGTT13k6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPHbx9PnYJvQerDca+fNsqK9z26k3l8xwVyoUSiJjFl3tu8aXXGyPt1QX1boabonC
         5aFGi/YsuqpGOzz+c47VmmoOzmg2rbZF0QXm/qy5VQYQUM28crEhQoyHs2GKYkBGQf
         z9gdE4zl9wNc/iq69VZl08BeyX0a4hFc6lHJbTck=
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
Subject: [PATCH 5.8 117/118] mm: memcg: fix memcg reclaim soft lockup
Date:   Mon, 21 Sep 2020 18:28:49 +0200
Message-Id: <20200921162041.829915522@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
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
Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
Cc: stable@vger.kernel.org
Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2619,6 +2619,14 @@ static void shrink_node_memcgs(pg_data_t
 		unsigned long reclaimed;
 		unsigned long scanned;
 
+		/*
+		 * This loop can become CPU-bound when target memcgs
+		 * aren't eligible for reclaim - either because they
+		 * don't have any reclaimable pages, or because their
+		 * memory is explicitly protected. Avoid soft lockups.
+		 */
+		cond_resched();
+
 		switch (mem_cgroup_protected(target_memcg, memcg)) {
 		case MEMCG_PROT_MIN:
 			/*


