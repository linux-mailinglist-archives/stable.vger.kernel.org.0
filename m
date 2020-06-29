Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F89720E680
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404257AbgF2VsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5E4247BA;
        Mon, 29 Jun 2020 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444130;
        bh=0E9DWn2s9pN3O11fMKizrHqQ0PCsnPYcWAjxaZ9Z10w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTwhXmkoWIJhzanLucnx7STRiDkrVHFWBpPx9ZhGyZplf8FWpWhAZfUAgBlTFaCS6
         UanXjET+zS0sS4aez2XoqGizHZA4rN6ir0FMFwDCtVQ02Wiae0c/id2yYjXJ61VxlI
         NR4WkFMgBTQ7jzqwbS5ePqq12jrZ+KF7YZRJdBOU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Widawsky <ben.widawsky@intel.com>,
        "Scargall, Steve" <steve.scargall@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 237/265] mm/memory_hotplug.c: fix false softlockup during pfn range removal
Date:   Mon, 29 Jun 2020 11:17:50 -0400
Message-Id: <20200629151818.2493727-238-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Widawsky <ben.widawsky@intel.com>

commit b7e3debdd0408c0dca5d4750371afa5003f792dc upstream.

When working with very large nodes, poisoning the struct pages (for which
there will be very many) can take a very long time.  If the system is
using voluntary preemptions, the software watchdog will not be able to
detect forward progress.  This patch addresses this issue by offering to
give up time like __remove_pages() does.  This behavior was introduced in
v5.6 with: commit d33695b16a9f ("mm/memory_hotplug: poison memmap in
remove_pfn_range_from_zone()")

Alternately, init_page_poison could do this cond_resched(), but it seems
to me that the caller of init_page_poison() is what actually knows whether
or not it should relax its own priority.

Based on Dan's notes, I think this is perfectly safe: commit f931ab479dd2
("mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}")

Aside from fixing the lockup, it is also a friendlier thing to do on lower
core systems that might wipe out large chunks of hotplug memory (probably
not a very common case).

Fixes this kind of splat:

  watchdog: BUG: soft lockup - CPU#46 stuck for 22s! [daxctl:9922]
  irq event stamp: 138450
  hardirqs last  enabled at (138449): [<ffffffffa1001f26>] trace_hardirqs_on_thunk+0x1a/0x1c
  hardirqs last disabled at (138450): [<ffffffffa1001f42>] trace_hardirqs_off_thunk+0x1a/0x1c
  softirqs last  enabled at (138448): [<ffffffffa1e00347>] __do_softirq+0x347/0x456
  softirqs last disabled at (138443): [<ffffffffa10c416d>] irq_exit+0x7d/0xb0
  CPU: 46 PID: 9922 Comm: daxctl Not tainted 5.7.0-BEN-14238-g373c6049b336 #30
  Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYXCRB1.86B.0578.D07.1902280810 02/28/2019
  RIP: 0010:memset_erms+0x9/0x10
  Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
  Call Trace:
   remove_pfn_range_from_zone+0x3a/0x380
   memunmap_pages+0x17f/0x280
   release_nodes+0x22a/0x260
   __device_release_driver+0x172/0x220
   device_driver_detach+0x3e/0xa0
   unbind_store+0x113/0x130
   kernfs_fop_write+0xdc/0x1c0
   vfs_write+0xde/0x1d0
   ksys_write+0x58/0xd0
   do_syscall_64+0x5a/0x120
   entry_SYSCALL_64_after_hwframe+0x49/0xb3
  Built 2 zonelists, mobility grouping on.  Total pages: 49050381
  Policy zone: Normal
  Built 3 zonelists, mobility grouping on.  Total pages: 49312525
  Policy zone: Normal

David said: "It really only is an issue for devmem.  Ordinary
hotplugged system memory is not affected (onlined/offlined in memory
block granularity)."

Link: http://lkml.kernel.org/r/20200619231213.1160351-1-ben.widawsky@intel.com
Fixes: commit d33695b16a9f ("mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()")
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reported-by: "Scargall, Steve" <steve.scargall@intel.com>
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index fc0aad0bc1f54..744a3ea284b78 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -468,11 +468,20 @@ void __ref remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
 {
+	const unsigned long end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	unsigned long flags;
+	unsigned long pfn, cur_nr_pages, flags;
 
 	/* Poison struct pages because they are now uninitialized again. */
-	page_init_poison(pfn_to_page(start_pfn), sizeof(struct page) * nr_pages);
+	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
+		cond_resched();
+
+		/* Select all remaining pages up to the next section boundary */
+		cur_nr_pages =
+			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
+		page_init_poison(pfn_to_page(pfn),
+				 sizeof(struct page) * cur_nr_pages);
+	}
 
 #ifdef CONFIG_ZONE_DEVICE
 	/*
-- 
2.25.1

