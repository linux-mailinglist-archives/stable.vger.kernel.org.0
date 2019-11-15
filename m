Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3ABFE8B1
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 00:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKOXgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 18:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbfKOXgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 18:36:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A88E2072B;
        Fri, 15 Nov 2019 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573860992;
        bh=ooluXuZOGODXe30fc2RSRKTbafG0UZBR01X58dJ+cuk=;
        h=Date:From:To:Subject:From;
        b=CgVYyyWNPyVoGG4yoA05XTPfFW/R13HHWZbVxF6iOq3Ml3pHUlPtEkn6Sa6HtUqPK
         M8x/kwlkuyFmI/06GzKLzTXOjQXaE0I9Jspgnf5A5+Z0L+MZkMhrV2Qd6nr6dg5OKH
         k+2IGenRAlsJhvu9TEAlXjWX2ZsGFSxOPpZEuNA0=
Date:   Fri, 15 Nov 2019 15:36:31 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dave.hansen@linux.intel.com, jroedel@suse.de,
        mm-commits@vger.kernel.org, shile.zhang@linux.alibaba.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject:  [alternative-merged]
 mm-vmalloc-fix-regression-caused-by-needless-vmalloc_sync_all.patch removed
 from -mm tree
Message-ID: <20191115233631.3HiuPKWKN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix performance regression caused by needless vmalloc_sync_all()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-regression-caused-by-needless-vmalloc_sync_all.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Shile Zhang <shile.zhang@linux.alibaba.com>
Subject: mm/vmalloc: fix performance regression caused by needless vmalloc_sync_all()

vmalloc_sync_all() was put in the common path in __purge_vmap_area_lazy(),
for one sync issue only happened on X86_32 with PTI enabled.  It is
needless for X86_64, which caused a big regression in UnixBench Shell8
testing on X86_64.  Similar regression also reported by 0-day kernel test
robot in reaim benchmarking:
https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/4D3JPPHBNOSPFK2KEPC6KGKS6J25AIDB/

Fix it by adding more conditions.

[akpm@linux-foundation.org: simplify config expression, use IS_ENABLED()]
[akpm@linux-foundation.org: build fix - go back to using an ifdef]
Link: http://lkml.kernel.org/r/20191113095530.228959-1-shile.zhang@linux.alibaba.com
Fixes: 3f8fd02b1bf1 ("mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()")
Signed-off-by: Shile Zhang <shile.zhang@linux.alibaba.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-regression-caused-by-needless-vmalloc_sync_all
+++ a/mm/vmalloc.c
@@ -1255,11 +1255,17 @@ static bool __purge_vmap_area_lazy(unsig
 	if (unlikely(valist == NULL))
 		return false;
 
+#ifdef CONFIG_X86_PAE
 	/*
-	 * First make sure the mappings are removed from all page-tables
-	 * before they are freed.
+	 * First make sure the mappings are removed from all pagetables before
+	 * they are freed.
+	 *
+	 * This is only needed on x86-32 with !SHARED_KERNEL_PMD, which is the
+	 * case on a PAE kernel with PTI enabled.
 	 */
-	vmalloc_sync_all();
+	if (!SHARED_KERNEL_PMD && boot_cpu_has(X86_FEATURE_PTI))
+		vmalloc_sync_all();
+#endif
 
 	/*
 	 * TODO: to calculate a flush range without looping.
_

Patches currently in -mm which might be from shile.zhang@linux.alibaba.com are


