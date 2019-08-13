Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73D8C459
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 00:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHMWh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 18:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfHMWh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 18:37:26 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643AC20840;
        Tue, 13 Aug 2019 22:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565735845;
        bh=ocOqb5D5uA+3innKdt6JRxlGR/WL0MkvQF8oh7B7TMk=;
        h=Date:From:To:Subject:From;
        b=sap6GZjm/VxfXejxRpud/v7fL9eqS4ujKTjhg0O+E2jCA+0LxT2mg2L/9n28qaTvP
         kGmq1I4ZkZ2+ZuUiWV/Hbx5aJG+eUpo6hwhU2rqFUhlkHgCPMf3dThsyqtb8MSCUNz
         rQ4PJrkQdjuM46N7K6d1F/QOfC1VAbiM2eazDfMw=
Date:   Tue, 13 Aug 2019 15:37:25 -0700
From:   akpm@linux-foundation.org
To:     vitalywool@gmail.com, vitaly.vul@sony.com, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, stable@vger.kernel.org, shakeelb@google.com,
        jwadams@google.com, henrywolfeburns@gmail.com, dhowells@redhat.com,
        henryburns@google.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 07/18] mm/z3fold.c: fix z3fold_destroy_pool() race
 condition
Message-ID: <20190813223725.JAgkm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
