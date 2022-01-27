Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92949D88A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiA0Czo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 21:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA0Czo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 21:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC2AC06161C;
        Wed, 26 Jan 2022 18:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 151AB615CA;
        Thu, 27 Jan 2022 02:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BF9C340E7;
        Thu, 27 Jan 2022 02:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643252143;
        bh=7VT4F78pieYXk3mgorT2C63j+TveepT8ZgpGu3rr5XM=;
        h=Date:From:To:Subject:From;
        b=izKtxtJCezIbYbXdDPwF58Dqkbb8mweNSNpOPTh+ggFzSx4bUk8Wx50DMyvEuK2yw
         lv8oRvgGgBL6lwYxDIXuMGsYysaf049BNA0PISm0IqZIT9OpBf12lBW6VH7lLyG33y
         BdL7ZVP0jMxaBOzgm/OvL8KLWym8QGsDy5VhQc0A=
Date:   Wed, 26 Jan 2022 18:55:42 -0800
From:   akpm@linux-foundation.org
To:     1vier1@web.de, arnd@arndb.de, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, dbueso@suse.de, manfred@colorfullife.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, shakeelb@google.com, stable@vger.kernel.org,
        unixbhaskar@gmail.com, urezki@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
Subject:  +
 mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch added
 to -mm tree
Message-ID: <20220127025542.F0GTnQlNA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/util.c: make kvfree() safe for calling while holding spinlocks
has been added to the -mm tree.  Its filename is
     mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch

