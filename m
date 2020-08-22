Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE024E906
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgHVRaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 13:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbgHVRaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 13:30:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA40207DA;
        Sat, 22 Aug 2020 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117403;
        bh=voEyDAFYTJ6uqoDualDA6YYP9sXzI7NsD7ScdP2qQ7Q=;
        h=Date:From:To:Subject:From;
        b=PmoCI6sGxdgLVo1seIl3hf4pUNAMeLAbQ4z/S9jV0pPQ8kH7NhK1bcuezu4gFySnV
         tIZvEOCQIadZtpUZKeB16neKlWfQAJbFgIZXi0fdm+jbD9i2k6yf+STnGyHOyRvs0l
         W1dBnz6exJxcJCQsqcHOz5UzVAZ1u+ZdLR/brTCc=
Date:   Sat, 22 Aug 2020 10:30:03 -0700
From:   akpm@linux-foundation.org
To:     jbaron@akamai.com, kirill.shutemov@linux.intel.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, opendmb@gmail.com,
        rientjes@google.com, stable@vger.kernel.org
Subject:  [merged]
 mm-include-cma-pages-in-lowmem_reserve-at-boot.patch removed from -mm tree
Message-ID: <20200822173003.VLW90O_Mf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: include CMA pages in lowmem_reserve at boot
has been removed from the -mm tree.  Its filename was
     mm-include-cma-pages-in-lowmem_reserve-at-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Doug Berger <opendmb@gmail.com>
Subject: mm: include CMA pages in lowmem_reserve at boot

The lowmem_reserve arrays provide a means of applying pressure against
allocations from lower zones that were targeted at higher zones.  Its
values are a function of the number of pages managed by higher zones and
are assigned by a call to the setup_per_zone_lowmem_reserve() function.

The function is initially called at boot time by the function
init_per_zone_wmark_min() and may be called later by accesses of the
/proc/sys/vm/lowmem_reserve_ratio sysctl file.

The function init_per_zone_wmark_min() was moved up from a module_init to
a core_initcall to resolve a sequencing issue with khugepaged. 
Unfortunately this created a sequencing issue with CMA page accounting.

The CMA pages are added to the managed page count of a zone when
cma_init_reserved_areas() is called at boot also as a core_initcall.  This
makes it uncertain whether the CMA pages will be added to the managed page
counts of their zones before or after the call to
init_per_zone_wmark_min() as it becomes dependent on link order.  With the
current link order the pages are added to the managed count after the
lowmem_reserve arrays are initialized at boot.

This means the lowmem_reserve values at boot may be lower than the values
used later if /proc/sys/vm/lowmem_reserve_ratio is accessed even if the
ratio values are unchanged.

In many cases the difference is not significant, but for example
an ARM platform with 1GB of memory and the following memory layout
[    0.000000] cma: Reserved 256 MiB at 0x0000000030000000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x000000002fffffff]
[    0.000000]   Normal   empty
[    0.000000]   HighMem  [mem 0x0000000030000000-0x000000003fffffff]

would result in 0 lowmem_reserve for the DMA zone.  This would allow
userspace to deplete the DMA zone easily.  Funnily enough

$ cat /proc/sys/vm/lowmem_reserve_ratio

would fix up the situation because it forces setup_per_zone_lowmem_reserve
as a side effect.

This commit breaks the link order dependency by invoking
init_per_zone_wmark_min() as a postcore_initcall so that the CMA pages
have the chance to be properly accounted in their zone(s) and allowing the
lowmem_reserve arrays to receive consistent values.

Link: http://lkml.kernel.org/r/1597423766-27849-1-git-send-email-opendmb@gmail.com
Fixes: bc22af74f271 ("mm: update min_free_kbytes from khugepaged after core initialization")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-include-cma-pages-in-lowmem_reserve-at-boot
+++ a/mm/page_alloc.c
@@ -7888,7 +7888,7 @@ int __meminit init_per_zone_wmark_min(vo
 
 	return 0;
 }
-core_initcall(init_per_zone_wmark_min)
+postcore_initcall(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so
_

Patches currently in -mm which might be from opendmb@gmail.com are


