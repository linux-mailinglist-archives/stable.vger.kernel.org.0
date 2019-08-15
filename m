Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8E68F547
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfHOUCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731790AbfHOUCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:02:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B77BE2089E;
        Thu, 15 Aug 2019 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899324;
        bh=4paHtrX/MMrQpk3BqP7EsTCPmMDyE4HV9VnHnIRupxA=;
        h=Date:From:To:Subject:From;
        b=ksrAV5dGBkDU4lwN7sRbi7pAIArHT2NTu22I4gQpTyHjaNWn0OcPyzy+1qYPhkT20
         4GOdtB56D9MLIRZCVPWjlkFH+bI4NPYVzPVkwE4B2y8Sp0zwxKix77XBUeCZAiTVzF
         6BrP6cWK1DxS9IMEu4VASlqI13la8XUehlNIW83Y=
Date:   Thu, 15 Aug 2019 13:02:03 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, henryburns@google.com,
        henrywolfeburns@gmail.com, jwadams@google.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, vitaly.vul@sony.com, vitalywool@gmail.com
Subject:  [merged]
 mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch removed from -mm tree
Message-ID: <20190815200203.EdXb0UrPP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/z3fold.c: fix z3fold_destroy_pool() ordering
has been removed from the -mm tree.  Its filename was
     mm-z3foldc-fix-z3fold_destroy_pool-ordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henry Burns <henryburns@google.com>
Subject: mm/z3fold.c: fix z3fold_destroy_pool() ordering

The constraint from the zpool use of z3fold_destroy_pool() is there are
no outstanding handles to memory (so no active allocations), but it is
possible for there to be outstanding work on either of the two wqs in
the pool.

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
Reviewed-by: Jonathan Adams <jwadams@google.com>
Cc: Vitaly Vul <vitaly.vul@sony.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk
Cc: Henry Burns <henrywolfeburns@gmail.com>
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

mm-z3foldc-fix-race-between-migration-and-destruction.patch

