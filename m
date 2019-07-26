Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DD1774C9
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 01:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfGZXGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 19:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbfGZXGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 19:06:49 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1B5722BE8;
        Fri, 26 Jul 2019 23:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564182408;
        bh=JQp0zhQhWWleut2qZdQhAuiXnw0AFZ0ANS9dGZ97Wzs=;
        h=Date:From:To:Subject:From;
        b=HNAPei8w9xYN3ORd9kraPkOi5Rr2i+sxQ3mkf4saOhc6En3GtVWIBIDXezlnxlx6g
         WXwgWtW8Dlk70+sEAYoFoXGKqXusq00fYjq9ncIgwBw8HrN9ccCS2P3EE4hqfrNjDV
         oMgG9MCPNQVKCPIQ0fqFWSpoDDHSUHPXr76yQVDU=
Date:   Fri, 26 Jul 2019 16:06:47 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, henryburns@google.com, jwadams@google.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, vitaly.vul@sony.com, vitalywool@gmail.com
Subject:  + mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch
 added to -mm tree
Message-ID: <20190726230647.FVuHJq1NG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: fix z3fold_destroy_pool() race condition
has been added to the -mm tree.  Its filename is
     mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: fix z3fold_destroy_pool() race condition

The constraint from the zpool use of z3fold_destroy_pool() is there are no
outstanding handles to memory (so no active allocations), but it is
possible for there to be outstanding work on either of the two wqs in the
pool.

Calling z3fold_deregister_migration() before the workqueues are drained
means that there can be allocated pages referencing a freed inode, causing
any thread in compaction to be able to trip over the bad pointer in
PageMovable().

Link: http://lkml.kernel.org/r/20190726224810.79660-2-henryburns@google.com
Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
Signed-off-by: Henry Burns <henryburns@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3foldc-fix-z3fold_destroy_pool-race-condition
+++ a/mm/z3fold.c
@@ -817,16 +817,19 @@ out:
 static void z3fold_destroy_pool(struct z3fold_pool *pool)
 {
 	kmem_cache_destroy(pool->c_handle);
-	z3fold_unregister_migration(pool);
 
 	/*
 	 * We need to destroy pool->compact_wq before pool->release_wq,
 	 * as any pending work on pool->compact_wq will call
 	 * queue_work(pool->release_wq, &pool->work).
+	 *
+	 * There are still outstanding pages until both workqueues are drained,
+	 * so we cannot unregister migration until then.
 	 */
 
 	destroy_workqueue(pool->compact_wq);
 	destroy_workqueue(pool->release_wq);
+	z3fold_unregister_migration(pool);
 	kfree(pool);
 }
 
_

Patches currently in -mm which might be from henryburns@google.com are

mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch
mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch

