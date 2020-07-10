Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68021C03C
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 01:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGJXAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 19:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgGJXAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 19:00:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340D0206E2;
        Fri, 10 Jul 2020 23:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594422044;
        bh=hznCTRT2EaDYyetihaEb7fSrAxoChbRxFBnrbOiSEgY=;
        h=Date:From:To:Subject:From;
        b=Cbt9fKpCW4MkX6s0d9pcvSrn3g7/mLxVBed9bb9zYr5Ci1dp95gTkDeczyJJk6xz2
         MCd7NS85NAjAFclhhdkfSG8XNR/Au7VmRJZ5Ua0GLe2V5b16QHFeKnhkQzH9MQtkUo
         hQUyvZQSrQidfKjEIbLZynOBk0Jj1VEJJj+qnSAE=
Date:   Fri, 10 Jul 2020 16:00:42 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, fenghua.yu@intel.com, hpa@zytor.com,
        hslester96@gmail.com, Jonathan.Cameron@Huawei.com,
        justin.he@arm.com, Kaly.Xin@arm.com, logang@deltatee.com,
        luto@kernel.org, masahiroy@kernel.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rppt@linux.ibm.com, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vishal.l.verma@intel.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  +
 mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done.patch added to -mm
 tree
Message-ID: <20200710230042.qAxWzJap3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: fix unpaired mem_hotplug_begin/done
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jia He <justin.he@arm.com>
Subject: mm/memory_hotplug: fix unpaired mem_hotplug_begin/done

When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
online at that time), mem_hotplug_begin/done is unpaired in such case.

Therefore a warning:
 Call Trace:
  percpu_up_write+0x33/0x40
  try_remove_memory+0x66/0x120
  ? _cond_resched+0x19/0x30
  remove_memory+0x2b/0x40
  dev_dax_kmem_remove+0x36/0x72 [kmem]
  device_release_driver_internal+0xf0/0x1c0
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x17b/0x3e0
  unregister_dev_dax+0x29/0x60
  devm_action_release+0x15/0x20
  release_nodes+0x19a/0x1e0
  devres_release_all+0x3f/0x50
  device_release_driver_internal+0x100/0x1c0
  driver_detach+0x4c/0x8f
  bus_remove_driver+0x5c/0xd0
  driver_unregister+0x31/0x50
  dax_pmem_exit+0x10/0xfe0 [dax_pmem]

Link: http://lkml.kernel.org/r/20200710031619.18762-3-justin.he@arm.com
Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
Signed-off-by: Jia He <justin.he@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chuhong Yuan <hslester96@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kaly Xin <Kaly.Xin@arm.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done
+++ a/mm/memory_hotplug.c
@@ -1756,7 +1756,7 @@ static int __ref try_remove_memory(int n
 	 */
 	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
 	if (rc)
-		goto done;
+		return rc;
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
@@ -1780,9 +1780,8 @@ static int __ref try_remove_memory(int n
 
 	try_offline_node(nid);
 
-done:
 	mem_hotplug_done();
-	return rc;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from justin.he@arm.com are

mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid.patch
mm-memory_hotplug-fix-unpaired-mem_hotplug_begin-done.patch

