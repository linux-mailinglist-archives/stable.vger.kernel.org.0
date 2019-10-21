Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E81DF6E5
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfJUUmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfJUUmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:42:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93B12067B;
        Mon, 21 Oct 2019 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690562;
        bh=ZYYHAnf+cQbvA6r1St0iHBkMnxvvvYQgMCXtGdvpSmw=;
        h=Date:From:To:Subject:From;
        b=UFl5g8umgDDXz9i8QvUC81KVJQ0FbboKmrztMOJ8C1aHyyiTH3sxEzNegz9dyf4S6
         vyF6Xb7GCV4GUfCWbnYeJn84jpNLM+hMU47x0G11mWaOPpS6thfuzdvaj2QmU55HJp
         3teFn3mSDgnwpilAmG7+UwzDVEviZXBsnqtBqjNs=
Date:   Mon, 21 Oct 2019 13:42:41 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rafael@kernel.org, stable@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?drivers-base-memoryc-dont-access-uninitialized-memmaps-in-s?=
 =?US-ASCII?Q?oft=5Foffline=5Fpage=5Fstore.patch?= removed from -mm tree
Message-ID: <20191021204241.Ee3KmnvEd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: drivers/base/memory.c: don't access uninitialized memmaps in soft_offline_page_store()
has been removed from the -mm tree.  Its filename was
     drivers-base-memoryc-dont-access-uninitialized-memmaps-in-soft_offline_page_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: don't access uninitialized memmaps in soft_offline_page_store()

Uninitialized memmaps contain garbage and in the worst case trigger kernel
BUGs, especially with CONFIG_PAGE_POISONING.  They should not get touched.

Right now, when trying to soft-offline a PFN that resides on a memory
block that was never onlined, one gets a misleading error with
CONFIG_PAGE_POISONING:

  :/# echo 5637144576 > /sys/devices/system/memory/soft_offline_page
  [   23.097167] soft offline: 0x150000 page already poisoned

But the actual result depends on the garbage in the memmap.

soft_offline_page() can only work with online pages, it returns -EIO in
case of ZONE_DEVICE.  Make sure to only forward pages that are online
(iow, managed by the buddy) and, therefore, have an initialized memmap.

Add a check against pfn_to_online_page() and similarly return -EIO.

Link: http://lkml.kernel.org/r/20191010141200.8985-1-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/memory.c~drivers-base-memoryc-dont-access-uninitialized-memmaps-in-soft_offline_page_store
+++ a/drivers/base/memory.c
@@ -540,6 +540,9 @@ static ssize_t soft_offline_page_store(s
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
+	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
+	if (!pfn_to_online_page(pfn))
+		return -EIO;
 	ret = soft_offline_page(pfn_to_page(pfn), 0);
 	return ret == 0 ? count : ret;
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory_hotplug-export-generic_online_page.patch
hv_balloon-use-generic_online_page.patch
mm-memory_hotplug-remove-__online_page_free-and-__online_page_increment_counters.patch
mm-memory_hotplug-dont-access-uninitialized-memmaps-in-shrink_zone_span.patch
mm-memory_hotplug-shrink-zones-when-offlining-memory.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch

