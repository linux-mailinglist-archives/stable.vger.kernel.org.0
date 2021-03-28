Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B1534BD4B
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhC1Qmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 12:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhC1Qmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 12:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A4561968;
        Sun, 28 Mar 2021 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616949755;
        bh=eF3HTBuQwU9xqQ5IgwbMWjJH8gSTk8vEMl33GoZUnhM=;
        h=Date:From:To:Subject:From;
        b=EP9epRbsYm7GCEdLbkVn/z5fVBdXEoKFHpUhMpP3uEha4iOI1POWY6MvA/i2yr1Y0
         9Ii2aXLd+SpQWOwayBkX7mZdRbKayM7QnKmlQIhc6+6s7fXx3wzpryeQ73dggN14Dq
         xtwahYP3RLjLZLR49id81fT5ZlMhJwNDtDZTmp7g=
Date:   Sun, 28 Mar 2021 09:42:35 -0700
From:   akpm@linux-foundation.org
To:     Chaitanya.Kulkarni@wdc.com, dsterba@suse.com, ira.weiny@intel.com,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject:  [merged]
 mm-highmem-fix-config_debug_kmap_local_force_map.patch removed from -mm
 tree
Message-ID: <20210328164235.udPStFdQP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
has been removed from the -mm tree.  Its filename was
     mm-highmem-fix-config_debug_kmap_local_force_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

The kernel test robot found that __kmap_local_sched_out() was not
correctly skipping the guard pages when CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
was set.[1] This was due to CONFIG_DEBUG_HIGHMEM check being used.

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

iov_iter-lift-memzero_page-to-highmemh.patch
btrfs-use-memzero_page-instead-of-open-coded-kmap-pattern.patch
mm-highmem-remove-deprecated-kmap_atomic.patch

