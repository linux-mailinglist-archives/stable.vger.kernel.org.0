Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7108198FFD
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgCaJID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731116AbgCaJH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70BB6208E0;
        Tue, 31 Mar 2020 09:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645677;
        bh=Lv7nxzimjNgk53yfuPokPVQ0E1KBKMsOch6WH/viC2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkZpxZOv2vHa9nouNyBxXcO14mMpL82/luYk9O95Kcmj5omHKUoBeHo8z3jECf4pw
         nrLQKDD/nsOJxmSUob2vtyxYWNWbtjzzTUbtNxUxI1pZrmTjgW6qFcyFK2n6RFBgpx
         GQzVw0dyycIeh0uVwsUPQejkwhTApK/rd6cVeyuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Scargall, Steve" <steve.scargall@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Fontenot <ndfont@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Karel Zak <kzak@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 112/170] drivers/base/memory.c: indicate all memory blocks as removable
Date:   Tue, 31 Mar 2020 10:58:46 +0200
Message-Id: <20200331085436.087249164@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 53cdc1cb29e87ce5a61de5bb393eb08925d14ede upstream.

We see multiple issues with the implementation/interface to compute
whether a memory block can be offlined (exposed via
/sys/devices/system/memory/memoryX/removable) and would like to simplify
it (remove the implementation).

1. It runs basically lockless. While this might be good for performance,
   we see possible races with memory offlining that will require at
   least some sort of locking to fix.

2. Nowadays, more false positives are possible. No arch-specific checks
   are performed that validate if memory offlining will not be denied
   right away (and such check will require locking). For example, arm64
   won't allow to offline any memory block that was added during boot -
   which will imply a very high error rate. Other archs have other
   constraints.

3. The interface is inherently racy. E.g., if a memory block is detected
   to be removable (and was not a false positive at that time), there is
   still no guarantee that offlining will actually succeed. So any
   caller already has to deal with false positives.

4. It is unclear which performance benefit this interface actually
   provides. The introducing commit 5c755e9fd813 ("memory-hotplug: add
   sysfs removable attribute for hotplug memory remove") mentioned

	"A user-level agent must be able to identify which sections
	 of memory are likely to be removable before attempting the
	 potentially expensive operation."

   However, no actual performance comparison was included.

Known users:

 - lsmem: Will group memory blocks based on the "removable" property. [1]

 - chmem: Indirect user. It has a RANGE mode where one can specify
          removable ranges identified via lsmem to be offlined. However,
          it also has a "SIZE" mode, which allows a sysadmin to skip the
          manual "identify removable blocks" step. [2]

 - powerpc-utils: Uses the "removable" attribute to skip some memory
          blocks right away when trying to find some to offline+remove.
          However, with ballooning enabled, it already skips this
          information completely (because it once resulted in many false
          negatives). Therefore, the implementation can deal with false
          positives properly already. [3]

According to Nathan Fontenot, DLPAR on powerpc is nowadays no longer
driven from userspace via the drmgr command (powerpc-utils).  Nowadays
it's managed in the kernel - including onlining/offlining of memory
blocks - triggered by drmgr writing to /sys/kernel/dlpar.  So the
affected legacy userspace handling is only active on old kernels.  Only
very old versions of drmgr on a new kernel (unlikely) might execute
slower - totally acceptable.

With CONFIG_MEMORY_HOTREMOVE, always indicating "removable" should not
break any user space tool.  We implement a very bad heuristic now.
Without CONFIG_MEMORY_HOTREMOVE we cannot offline anything, so report
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

Reported-by: "Scargall, Steve" <steve.scargall@intel.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Nathan Fontenot <ndfont@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200128093542.6908-1-david@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/memory.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -111,30 +111,13 @@ static ssize_t phys_index_show(struct de
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


