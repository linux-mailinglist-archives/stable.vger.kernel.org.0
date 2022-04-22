Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8DA50BF76
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 20:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiDVS24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 14:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiDVS17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 14:27:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48933105231;
        Fri, 22 Apr 2022 11:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146D961820;
        Fri, 22 Apr 2022 18:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683BAC385A0;
        Fri, 22 Apr 2022 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651898;
        bh=r8MKl2pL4Spbnm26Y1THPv8vNAXf8hPy/gZl2qySPk4=;
        h=Date:To:From:Subject:From;
        b=mm0gGOEva8YX3WLA0jcrKkjRY4x0ftPa1ILrcjefOrxxqv3zK3ua+8dYSr2hDk0DA
         q3JNPYyMo7yM37x/C0P5L/mDwWRm49LWLGF8iK/UKwwzVVAzmFhnNhzUd9goQV28/S
         Maj9t2Vvj7tz2IVHrfcoemranX8IC39IvMIJNojI=
Date:   Fri, 22 Apr 2022 11:24:57 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, jgg@nvidia.com,
        christian.koenig@amd.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch removed from -mm tree
Message-Id: <20220422182458.683BAC385A0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

In some cases it is possible for mmu_interval_notifier_remove() to race
with mn_tree_inv_end() allowing it to return while the notifier data
structure is still in use.  Consider the following sequence:

CPU0 - mn_tree_inv_end()            CPU1 - mmu_interval_notifier_remove()
----------------------------------- ------------------------------------
                                    spin_lock(subscriptions->lock);
                                    seq = subscriptions->invalidate_seq;
spin_lock(subscriptions->lock);     spin_unlock(subscriptions->lock);
subscriptions->invalidate_seq++;
                                    wait_event(invalidate_seq != seq);
                                    return;
interval_tree_remove(interval_sub); kfree(interval_sub);
spin_unlock(subscriptions->lock);
wake_up_all();

As the wait_event() condition is true it will return immediately.  This
can lead to use-after-free type errors if the caller frees the data
structure containing the interval notifier subscription while it is still
on a deferred list.  Fix this by taking the appropriate lock when reading
invalidate_seq to ensure proper synchronisation.

I observed this whilst running stress testing during some development. 
You do have to be pretty unlucky, but it leads to the usual problems of
use-after-free (memory corruption, kernel crash, difficult to diagnose
WARN_ON, etc).

Link: https://lkml.kernel.org/r/20220420043734.476348-1-apopple@nvidia.com
Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove
+++ a/mm/mmu_notifier.c
@@ -1036,6 +1036,18 @@ int mmu_interval_notifier_insert_locked(
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked);
 
+static bool
+mmu_interval_seq_released(struct mmu_notifier_subscriptions *subscriptions,
+			  unsigned long seq)
+{
+	bool ret;
+
+	spin_lock(&subscriptions->lock);
+	ret = subscriptions->invalidate_seq != seq;
+	spin_unlock(&subscriptions->lock);
+	return ret;
+}
+
 /**
  * mmu_interval_notifier_remove - Remove a interval notifier
  * @interval_sub: Interval subscription to unregister
@@ -1083,7 +1095,7 @@ void mmu_interval_notifier_remove(struct
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 	if (seq)
 		wait_event(subscriptions->wq,
-			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+			   mmu_interval_seq_released(subscriptions, seq));
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-add-selftests-for-migration-entries.patch

