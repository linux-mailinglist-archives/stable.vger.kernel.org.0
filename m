Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28DA3428E8
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 23:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhCSWti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 18:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230476AbhCSWt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 18:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387D661974;
        Fri, 19 Mar 2021 22:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616194169;
        bh=FeoAUmhPxu4OSMniY1qNuGFf+N0hg5YHmVLIJJ/maxI=;
        h=Date:From:To:Subject:From;
        b=m+yNEdEvYWj+5vQ7h16ig+V5QaA6BDwf2Gcy0iIrrD9nAvC4w3U/eHvgZy9Dehk4v
         fmfjUqEPzUcbplTpxMI6AH+JZU63k9CZbu1j0IPk+pkYU4cew1eMjQs0ZRZ7YKHufx
         hXBlIQwqx6EzomgLbGgiMgZzp5AWKP6bzVpRKOUk=
Date:   Fri, 19 Mar 2021 15:49:28 -0700
From:   akpm@linux-foundation.org
To:     Chaitanya.Kulkarni@wdc.com, dsterba@suse.com, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject:  + mm-highmem-fix-config_debug_kmap_local_force_map.patch
 added to -mm tree
Message-ID: <20210319224928.0O2v9eM7L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/highmem: Fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
has been added to the -mm tree.  Its filename is
     mm-highmem-fix-config_debug_kmap_local_force_map.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-fix-config_debug_kmap_local_force_map.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-fix-config_debug_kmap_local_force_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ira.weiny@intel.com
Subject: mm/highmem: Fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP


The kernel test robot found that __kmap_local_sched_out() was not
correctly skipping the guard pages when
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP was set.[1]  This was due to
CONFIG_DEBUG_HIGHMEM check being used.

Change the configuration check to be correct.

[1] https://lore.kernel.org/lkml/20210304083825.GB17830@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20210318230657.1497881-1-ira.weiny@intel.com
Fixes: 0e91a0c6984c ("mm/highmem: Provide CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Sang <oliver.sang@intel.com>
Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: David Sterba <dsterba@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-highmem-fix-config_debug_kmap_local_force_map
+++ a/mm/highmem.c
@@ -618,7 +618,7 @@ void __kmap_local_sched_out(void)
 		int idx;
 
 		/* With debug all even slots are unmapped and act as guard */
-		if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !(i & 0x01)) {
+		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
 			WARN_ON_ONCE(!pte_none(pteval));
 			continue;
 		}
@@ -654,7 +654,7 @@ void __kmap_local_sched_in(void)
 		int idx;
 
 		/* With debug all even slots are unmapped and act as guard */
-		if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !(i & 0x01)) {
+		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
 			WARN_ON_ONCE(!pte_none(pteval));
 			continue;
 		}
_

Patches currently in -mm which might be from ira.weiny@intel.com are

mm-highmem-fix-config_debug_kmap_local_force_map.patch
iov_iter-lift-memzero_page-to-highmemh.patch
btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern.patch
mm-highmem-remove-deprecated-kmap_atomic.patch

