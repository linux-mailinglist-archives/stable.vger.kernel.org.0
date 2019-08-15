Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450B08F548
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbfHOUCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731790AbfHOUCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:02:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F0C2171F;
        Thu, 15 Aug 2019 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899327;
        bh=0IExE9K15kTw0iIrGp7MJL4lTlBVLntcX6jVeV/DBJY=;
        h=Date:From:To:Subject:From;
        b=DQcgIFZLx7vb980T1g5MoPXyhDBBSO4lN76cYC8EIptclyR7sXRH2oSSvpy1dZuCQ
         Cb5qUVL9iJETYwW18UeUV324B0iGnhCMu9LWET9afUmzSAWLTCFjnf46Hf5iW4qYpq
         2h6/jf7a1+9r+W6VXgT2b/eiN0R/7K0GEN5JByVE=
Date:   Thu, 15 Aug 2019 13:02:06 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, henryburns@google.com,
        henrywolfeburns@gmail.com, jwadams@google.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, vitaly.vul@sony.com, vitalywool@gmail.com
Subject:  [merged]
 mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch removed from -mm
 tree
Message-ID: <20190815200206.uaNCzc3_Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: fix z3fold_destroy_pool() race condition
has been removed from the -mm tree.  Its filename was
     mm-z3foldc-fix-z3fold_destroy_pool-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: fix z3fold_destroy_pool() race condition

The constraint from the zpool use of z3fold_destroy_pool() is there are
no outstanding handles to memory (so no active allocations), but it is
possible for there to be outstanding work on either of the two wqs in
the pool.

Calling z3fold_deregister_migration() before the workqueues are drained
means that there can be allocated pages referencing a freed inode,
causing any thread in compaction to be able to trip over the bad
pointer in PageMovable().

Link: http://lkml.kernel.org/r/20190726224810.79660-2-henryburns@google.com
Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
Signed-off-by: Henry Burns <henryburns@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Jonathan Adams <jwadams@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Henry Burns <henrywolfeburns@gmail.com>
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

mm-z3foldc-fix-race-between-migration-and-destruction.patch

