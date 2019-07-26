Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D367A774C8
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 01:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfGZXGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 19:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbfGZXGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 19:06:46 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0984D21994;
        Fri, 26 Jul 2019 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564182405;
        bh=1aESHqzNMc9UBeyjHzQ5UfpvZJbcDg117VFqAq4GxzM=;
        h=Date:From:To:Subject:From;
        b=qXKsoi1fY3Suf3SanWcBEbFCzN9m9KGtt4iGzTrXGbfMnw1XK6/3Wf9WlwNiHZpY5
         +KHDC/kZM5w+fBcf6WGGy1s2c7Rk19NC/YPi2J4ZVaXismn3/lvEb5tsGqUbjNSUV/
         pTYGKd1ILifTL6mvWER4TY7I6rPFMyNNMt43rL98=
Date:   Fri, 26 Jul 2019 16:06:44 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, henryburns@google.com, jwadams@google.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, vitaly.vul@sony.com, vitalywool@gmail.com
Subject:  + mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch added
 to -mm tree
Message-ID: <20190726230644.wxY_zeShM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: fix z3fold_destroy_pool() ordering
has been added to the -mm tree.  Its filename is
     mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch

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
Subject: mm/z3fold.c: fix z3fold_destroy_pool() ordering

The constraint from the zpool use of z3fold_destroy_pool() is there are no
outstanding handles to memory (so no active allocations), but it is
possible for there to be outstanding work on either of the two wqs in the
pool.

If there is work queued on pool->compact_workqueue when it is called,
z3fold_destroy_pool() will do:

   z3fold_destroy_pool()
     destroy_workqueue(pool->release_wq)
     destroy_workqueue(pool->compact_wq)
       drain_workqueue(pool->compact_wq)
         do_compact_page(zhdr)
           kref_put(&zhdr->refcount)
             __release_z3fold_page(zhdr, ...)
               queue_work_on(pool->release_wq, &pool->work) *BOOM*

So compact_wq needs to be destroyed before release_wq.

Link: http://lkml.kernel.org/r/20190726224810.79660-1-henryburns@google.com
Fixes: 5d03a6613957 ("mm/z3fold.c: use kref to prevent page free/compact race")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Jonathan Adams <jwadams@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3foldc-fix-z3fold_destroy_pool-ordering
+++ a/mm/z3fold.c
@@ -818,8 +818,15 @@ static void z3fold_destroy_pool(struct z
 {
 	kmem_cache_destroy(pool->c_handle);
 	z3fold_unregister_migration(pool);
-	destroy_workqueue(pool->release_wq);
+
+	/*
+	 * We need to destroy pool->compact_wq before pool->release_wq,
+	 * as any pending work on pool->compact_wq will call
+	 * queue_work(pool->release_wq, &pool->work).
+	 */
+
 	destroy_workqueue(pool->compact_wq);
+	destroy_workqueue(pool->release_wq);
 	kfree(pool);
 }
 
_

Patches currently in -mm which might be from henryburns@google.com are

mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch
mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch

