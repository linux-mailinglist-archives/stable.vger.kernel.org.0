Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DA2DD64A
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfJSDTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfJSDTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:19:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335E7222C2;
        Sat, 19 Oct 2019 03:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455157;
        bh=OEAIZ1PKxau5YvsqOA6tZGND2Xfq1vBQnB7VIx7SxoE=;
        h=Date:From:To:Subject:From;
        b=hzNv8r/7XP2wY8CSxOq2uf2SshJvoN9CF63h+l3kgpV+iHDwCE7/PZwlWwqnd4vTq
         1VWYMBTZCsDgukLTUhhtFtn660v3rk5JyiOQR0eSXEhhrXsmzQIfzrHLyUct9do2RZ
         cQzQREZxZRzo3w7FD+W9UwaR92+a+zpQWjKvAVh4=
Date:   Fri, 18 Oct 2019 20:19:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rafael@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 01/26] drivers/base/memory.c: don't access
 uninitialized memmaps in soft_offline_page_store()
Message-ID: <20191019031916.Ux-StDx4F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
