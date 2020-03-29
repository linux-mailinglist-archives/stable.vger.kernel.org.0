Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6731A196A9A
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 04:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgC2CRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 22:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgC2CRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 22:17:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6465D2071B;
        Sun, 29 Mar 2020 02:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585448240;
        bh=tRVsOAbOCbtHbQCO+U+9vXHkW9wblZ3fYRMFIzNbHHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rJz4TDimY6sVs+S6jMWra39mLJtK2j7/dzGnmVd9JNTeGVROYLUFmcLcVkKBwKyHD
         tAygmdI4ees3bIJDmEBMEcoXQvoX6RZOKpE9OQgu57+fnFDh/UXnOTnwsyiTOkRtgY
         iLdQ8s3N2IccFikp+SY93ONy64PUYYJPQmXYamFw=
Date:   Sat, 28 Mar 2020 19:17:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org,
        heiko.carstens@de.ibm.com, kzak@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        ndfont@gmail.com, pbadari@us.ibm.com, rafael@kernel.org,
        rcj@linux.vnet.ibm.com, stable@vger.kernel.org,
        steve.scargall@intel.com, torvalds@linux-foundation.org
Subject:  [patch 2/5] drivers/base/memory.c: indicate all memory
 blocks as removable
Message-ID: <20200329021719.MBKzW0xSl%akpm@linux-foundation.org>
In-Reply-To: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/memory.c: indicate all memory blocks as removable

We see multiple issues with the implementation/interface to compute
whether a memory block can be offlined (exposed via
/sys/devices/system/memory/memoryX/removable) and would like to simplify
it (remove the implementation).

1. It runs basically lockless. While this might be good for performance,
   we see possible races with memory offlining that will require at least
   some sort of locking to fix.

2. Nowadays, more false positives are possible. No arch-specific checks
   are performed that validate if memory offlining will not be denied
   right away (and such check will require locking). For example, arm64
   won't allow to offline any memory block that was added during boot -
   which will imply a very high error rate. Other archs have other
   constraints.

3. The interface is inherently racy. E.g., if a memory block is
   detected to be removable (and was not a false positive at that time),
   there is still no guarantee that offlining will actually succeed. So
   any caller already has to deal with false positives.

4. It is unclear which performance benefit this interface actually
   provides. The introducing commit 5c755e9fd813 ("memory-hotplug: add
   sysfs removable attribute for hotplug memory remove") mentioned
	"A user-level agent must be able to identify which sections of
	 memory are likely to be removable before attempting the
	 potentially expensive operation."
   However, no actual performance comparison was included.

Known users:
- lsmem: Will group memory blocks based on the "removable" property. [1]
- chmem: Indirect user. It has a RANGE mode where one can specify
	 removable ranges identified via lsmem to be offlined. However, it
	 also has a "SIZE" mode, which allows a sysadmin to skip the manual
	 "identify removable blocks" step. [2]
- powerpc-utils: Uses the "removable" attribute to skip some memory
		 blocks right away when trying to find some to
		 offline+remove. However, with ballooning enabled, it
		 already skips this information completely (because it
		 once resulted in many false negatives). Therefore, the
		 implementation can deal with false positives properly
		 already. [3]

According to Nathan Fontenot, DLPAR on powerpc is nowadays no longer
driven from userspace via the drmgr command (powerpc-utils). Nowadays
it's managed in the kernel - including onlining/offlining of memory
blocks - triggered by drmgr writing to /sys/kernel/dlpar. So the
affected legacy userspace handling is only active on old kernels. Only ve=
ry
old versions of drmgr on a new kernel (unlikely) might execute slower -
totally acceptable.

With CONFIG_MEMORY_HOTREMOVE, always indicating "removable" should not
break any user space tool. We implement a very bad heuristic now.  Withou=
t
CONFIG_MEMORY_HOTREMOVE we cannot offline anything, so report
"not removable" as before.

Original discussion can be found in [4] ("[PATCH RFC v1] mm:
is_mem_section_removable() overhaul").

Other users of is_mem_section_removable() will be removed next, so that
we can remove is_mem_section_removable() completely.

[1] http://man7.org/linux/man-pages/man1/lsmem.1.html
[2] http://man7.org/linux/man-pages/man8/chmem.8.html
[3] https://github.com/ibm-power-utilities/powerpc-utils
[4] https://lkml.kernel.org/r/20200117105759.27905-1-david@redhat.com

Also, this patch probably fixes a crash reported by Steve. 
http://lkml.kernel.org/r/CAPcyv4jpdaNvJ67SkjyUJLBnBnXXQv686BiVW042g03FUmWLXw@mail.gmail.com

Link: http://lkml.kernel.org/r/20200128093542.6908-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Nathan Fontenot <ndfont@gmail.com>
Reported-by: "Scargall, Steve" <steve.scargall@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memoryc-indicate-all-memory-blocks-as-removable
+++ a/drivers/base/memory.c
@@ -97,30 +97,13 @@ static ssize_t phys_index_show(struct de
 }
 
 /*
- * Show whether the memory block is likely to be offlineable (or is already
- * offline). Once offline, the memory block could be removed. The return
- * value does, however, not indicate that there is a way to remove the
- * memory block.
+ * Legacy interface that we cannot remove. Always indicate "removable"
+ * with CONFIG_MEMORY_HOTREMOVE - bad heuristic.
  */
 static ssize_t removable_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
-	struct memory_block *mem = to_memory_block(dev);
-	unsigned long pfn;
-	int ret = 1, i;
-
-	if (mem->state != MEM_ONLINE)
-		goto out;
-
-	for (i = 0; i < sections_per_block; i++) {
-		if (!present_section_nr(mem->start_section_nr + i))
-			continue;
-		pfn = section_nr_to_pfn(mem->start_section_nr + i);
-		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
-	}
-
-out:
-	return sprintf(buf, "%d\n", ret);
+	return sprintf(buf, "%d\n", (int)IS_ENABLED(CONFIG_MEMORY_HOTREMOVE));
 }
 
 /*
_
