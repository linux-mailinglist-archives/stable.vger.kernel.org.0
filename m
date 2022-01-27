Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8549EDE8
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 23:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiA0WBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 17:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiA0WBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 17:01:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0979CC061714;
        Thu, 27 Jan 2022 14:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB22EB823B3;
        Thu, 27 Jan 2022 22:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E33C340E4;
        Thu, 27 Jan 2022 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643320887;
        bh=0z8p2yLCqEk/0Th5JJwZ5/UasvV/M8AHkxabuCmxRM0=;
        h=Date:From:To:Subject:From;
        b=jdOr4qnAe7YbZCl5WEXYZc772ZQQocCRDcjKDWChaY5buzQ41qpLct8KlMKlHBFey
         YIAfEK9+69lBNk5s3ligVS7nyCvuQe7lliaLNP/o6ljsf8RwJreKmuqLSoDZTNPs3i
         IpO9A5Nlh+Osc/wLpI4eNg5tTceQ3JThdFDLlEek=
Date:   Thu, 27 Jan 2022 14:01:26 -0800
From:   akpm@linux-foundation.org
To:     1vier1@web.de, arnd@arndb.de, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, dbueso@suse.de, manfred@colorfullife.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, shakeelb@google.com, stable@vger.kernel.org,
        unixbhaskar@gmail.com, urezki@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
Subject:  [alternative-merged]
 mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch removed
 from -mm tree
Message-ID: <20220127220126.zRE0qPjlu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/util.c: make kvfree() safe for calling while holding spinlocks
has been removed from the -mm tree.  Its filename was
     mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: mm/util.c: make kvfree() safe for calling while holding spinlocks

One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
Since vfree() can sleep this is a bug.

Previously, the code path used kfree(), and kfree() is safe to be called
while holding a spinlock.

Minghao proposed to fix this by updating find_alloc_undo().

Alternate proposal to fix this: Instead of changing find_alloc_undo(),
change kvfree() so that the same rules as for kfree() apply: Having
different rules for kfree() and kvfree() just asks for bugs.

Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.

Link: https://lkml.kernel.org/r/20211222194828.15320-1-manfred@colorfullife.com
Link: https://lore.kernel.org/all/20211222081026.484058-1-chi.minghao@zte.com.cn/
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <1vier1@web.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks
+++ a/mm/util.c
@@ -603,12 +603,12 @@ EXPORT_SYMBOL(kvmalloc_node);
  * It is slightly more efficient to use kfree() or vfree() if you are certain
  * that you know which one to use.
  *
- * Context: Either preemptible task context or not-NMI interrupt.
+ * Context: Any context except NMI interrupt.
  */
 void kvfree(const void *addr)
 {
 	if (is_vmalloc_addr(addr))
-		vfree(addr);
+		vfree_atomic(addr);
 	else
 		kfree(addr);
 }
_

Patches currently in -mm which might be from manfred@colorfullife.com are


