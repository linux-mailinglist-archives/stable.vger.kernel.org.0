Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF3450F6D8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbiDZI5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346040AbiDZIoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2601606BF;
        Tue, 26 Apr 2022 01:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2FC4B81D0B;
        Tue, 26 Apr 2022 08:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43817C385AF;
        Tue, 26 Apr 2022 08:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962044;
        bh=MloYW9hWeVoGLvgwUKtBkfZ0MZsDwu3/pbcTqCOAJVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0RjSi8+qBJwVM1gDY6yFh/v8z8zfLorNfd3qkgkKgd5ihbZUmpwbFj0vP3DuuO1+
         QXOhryNWb1Qq7j6o5E6oSVairOHLWX2hNbFjuHuUdcmNdnC0DUrR1LAuLKnq1G3CkN
         PhEpdTQWLI+JNe2uXwUHmFjciHGURDlaL+o6Sr7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 54/86] mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()
Date:   Tue, 26 Apr 2022 10:21:22 +0200
Message-Id: <20220426081742.764495905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit 319561669a59d8e9206ab311ae5433ef92fd79d1 upstream.

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
structure containing the interval notifier subscription while it is
still on a deferred list.  Fix this by taking the appropriate lock when
reading invalidate_seq to ensure proper synchronisation.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmu_notifier.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -1043,6 +1043,18 @@ int mmu_interval_notifier_insert_locked(
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
@@ -1090,7 +1102,7 @@ void mmu_interval_notifier_remove(struct
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 	if (seq)
 		wait_event(subscriptions->wq,
-			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+			   mmu_interval_seq_released(subscriptions, seq));
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);


