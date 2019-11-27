Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3510BCD7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfK0VCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbfK0VCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4742215A5;
        Wed, 27 Nov 2019 21:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888562;
        bh=ogrjsBVNJ8JMmbQWh6mnwRs1djxIQYaYeCb4jx1Tyu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WV848oDFexYCgj9R9CBFEN96l6zHXTG1Zsiow1WSQR0C1PmRuHpQwFcB0INpqMzx9
         BVBZCf48TaakuQgPK6n+myEZzCsEthzogrcsmCU828gruvjWCEwPxQuRSz0DdEZiW2
         zRnJg/WFXXvzb73IskbWWZqBT4cHRX2qO8v3kVzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Rashmica Gupta <rashmica.g@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Michael Neuling <mikey@neuling.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>,
        Mathieu Malaterre <malat@debian.org>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/306] mm/memory_hotplug: fix online/offline_pages called w.o. mem_hotplug_lock
Date:   Wed, 27 Nov 2019 21:30:31 +0100
Message-Id: <20191127203128.538002154@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 381eab4a6ee81266f8dddc62e57376c7e584e5b8 ]

There seem to be some problems as result of 30467e0b3be ("mm, hotplug:
fix concurrent memory hot-add deadlock"), which tried to fix a possible
lock inversion reported and discussed in [1] due to the two locks
	a) device_lock()
	b) mem_hotplug_lock

While add_memory() first takes b), followed by a) during
bus_probe_device(), onlining of memory from user space first took a),
followed by b), exposing a possible deadlock.

In [1], and it was decided to not make use of device_hotplug_lock, but
rather to enforce a locking order.

The problems I spotted related to this:

1. Memory block device attributes: While .state first calls
   mem_hotplug_begin() and the calls device_online() - which takes
   device_lock() - .online does no longer call mem_hotplug_begin(), so
   effectively calls online_pages() without mem_hotplug_lock.

2. device_online() should be called under device_hotplug_lock, however
   onlining memory during add_memory() does not take care of that.

In addition, I think there is also something wrong about the locking in

3. arch/powerpc/platforms/powernv/memtrace.c calls offline_pages()
   without locks. This was introduced after 30467e0b3be. And skimming over
   the code, I assume it could need some more care in regards to locking
   (e.g. device_online() called without device_hotplug_lock. This will
   be addressed in the following patches.

Now that we hold the device_hotplug_lock when
- adding memory (e.g. via add_memory()/add_memory_resource())
- removing memory (e.g. via remove_memory())
- device_online()/device_offline()

We can move mem_hotplug_lock usage back into
online_pages()/offline_pages().

Why is mem_hotplug_lock still needed? Essentially to make
get_online_mems()/put_online_mems() be very fast (relying on
device_hotplug_lock would be very slow), and to serialize against
addition of memory that does not create memory block devices (hmm).

[1] http://driverdev.linuxdriverproject.org/pipermail/ driverdev-devel/
    2015-February/065324.html

This patch is partly based on a patch by Vitaly Kuznetsov.

Link: http://lkml.kernel.org/r/20180925091457.28651-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
Reviewed-by: Rashmica Gupta <rashmica.g@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Rashmica Gupta <rashmica.g@gmail.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: John Allen <jallen@linux.vnet.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c | 13 +------------
 mm/memory_hotplug.c   | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 07901cacfec63..0f8e77f78cc80 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -228,7 +228,6 @@ static bool pages_correctly_probed(unsigned long start_pfn)
 /*
  * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
  * OK to have direct references to sparsemem variables in here.
- * Must already be protected by mem_hotplug_begin().
  */
 static int
 memory_block_action(unsigned long phys_index, unsigned long action, int online_type)
@@ -294,7 +293,6 @@ static int memory_subsys_online(struct device *dev)
 	if (mem->online_type < 0)
 		mem->online_type = MMOP_ONLINE_KEEP;
 
-	/* Already under protection of mem_hotplug_begin() */
 	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
 
 	/* clear online_type */
@@ -341,19 +339,11 @@ store_mem_state(struct device *dev,
 		goto err;
 	}
 
-	/*
-	 * Memory hotplug needs to hold mem_hotplug_begin() for probe to find
-	 * the correct memory block to online before doing device_online(dev),
-	 * which will take dev->mutex.  Take the lock early to prevent an
-	 * inversion, memory_subsys_online() callbacks will be implemented by
-	 * assuming it's already protected.
-	 */
-	mem_hotplug_begin();
-
 	switch (online_type) {
 	case MMOP_ONLINE_KERNEL:
 	case MMOP_ONLINE_MOVABLE:
 	case MMOP_ONLINE_KEEP:
+		/* mem->online_type is protected by device_hotplug_lock */
 		mem->online_type = online_type;
 		ret = device_online(&mem->dev);
 		break;
@@ -364,7 +354,6 @@ store_mem_state(struct device *dev,
 		ret = -EINVAL; /* should never happen */
 	}
 
-	mem_hotplug_done();
 err:
 	unlock_device_hotplug();
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0db85bffa3892..3a0a87e7c40ad 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -846,7 +846,6 @@ static struct zone * __meminit move_pfn_range(int online_type, int nid,
 	return zone;
 }
 
-/* Must be protected by mem_hotplug_begin() or a device_lock */
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
 {
 	unsigned long flags;
@@ -858,6 +857,8 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 	struct memory_notify arg;
 	struct memory_block *mem;
 
+	mem_hotplug_begin();
+
 	/*
 	 * We can't use pfn_to_nid() because nid might be stored in struct page
 	 * which is not yet initialized. Instead, we find nid from memory block.
@@ -923,6 +924,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
+	mem_hotplug_done();
 	return 0;
 
 failed_addition:
@@ -930,6 +932,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 		 (unsigned long long) pfn << PAGE_SHIFT,
 		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	mem_hotplug_done();
 	return ret;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
@@ -1134,20 +1137,20 @@ int __ref add_memory_resource(int nid, struct resource *res, bool online)
 	/* create new memmap entry */
 	firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	/* device_online() will take the lock when calling online_pages() */
+	mem_hotplug_done();
+
 	/* online pages if requested */
 	if (online)
 		walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1),
 				  NULL, online_memory_block);
 
-	goto out;
-
+	return ret;
 error:
 	/* rollback pgdat allocation and others */
 	if (new_node)
 		rollback_node_hotadd(nid);
 	memblock_remove(start, size);
-
-out:
 	mem_hotplug_done();
 	return ret;
 }
@@ -1614,10 +1617,16 @@ static int __ref __offline_pages(unsigned long start_pfn,
 		return -EINVAL;
 	if (!IS_ALIGNED(end_pfn, pageblock_nr_pages))
 		return -EINVAL;
+
+	mem_hotplug_begin();
+
 	/* This makes hotplug much easier...and readable.
 	   we assume this for now. .*/
-	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start, &valid_end))
+	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start,
+				  &valid_end)) {
+		mem_hotplug_done();
 		return -EINVAL;
+	}
 
 	zone = page_zone(pfn_to_page(valid_start));
 	node = zone_to_nid(zone);
@@ -1626,8 +1635,10 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE, true);
-	if (ret)
+	if (ret) {
+		mem_hotplug_done();
 		return ret;
+	}
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
@@ -1698,6 +1709,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
+	mem_hotplug_done();
 	return 0;
 
 failed_removal:
@@ -1707,10 +1719,10 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	mem_hotplug_done();
 	return ret;
 }
 
-/* Must be protected by mem_hotplug_begin() or a device_lock */
 int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
 	return __offline_pages(start_pfn, start_pfn + nr_pages);
-- 
2.20.1



