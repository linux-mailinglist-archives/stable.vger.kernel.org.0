Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9090599EBA
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349805AbiHSPja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349732AbiHSPj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54999D5981;
        Fri, 19 Aug 2022 08:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8378615E9;
        Fri, 19 Aug 2022 15:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1786C433C1;
        Fri, 19 Aug 2022 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923567;
        bh=08d/XJQRZjUU/QpAUPmqkFgDX+UBU86QCC66R/1vyNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fyl2Z2fdKCyKS4yvdYvGumRWeodBwlusZJgN9rd/K7YYrKd8TlMGJuxZBXPtmxXKa
         nPxntxTEynTJl0s3HR0olMGiauKNQD4D5BC3aDxFuEEgv0nf1BYGckJHCAE5Mk6PDp
         ykNAkpKwyXjTtG44TsVWapTuPM5xzF/Wvkw2a8Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Schulze <max.schulze@online.de>,
        Marco Elver <elver@google.com>
Subject: [PATCH 5.19 1/7] Revert "mm: kfence: apply kmemleak_ignore_phys on early allocated pool"
Date:   Fri, 19 Aug 2022 17:39:17 +0200
Message-Id: <20220819153711.621086880@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
References: <20220819153711.552247994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

This reverts commit 07313a2b29ed1079eaa7722624544b97b3ead84b.

Commit 0c24e061196c21d5 ("mm: kmemleak: add rbtree and store physical
address for objects allocated with PA") is not yet in 5.19 (but appears
in 6.0). Without 0c24e061196c21d5, kmemleak still stores phys objects
and non-phys objects in the same tree, and ignoring (instead of freeing)
will cause insertions into the kmemleak object tree by the slab
post-alloc hook to conflict with the pool object (see comment).

Reports such as the following would appear on boot, and effectively
disable kmemleak:

 | kmemleak: Cannot insert 0xffffff806e24f000 into the object search tree (overlaps existing)
 | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-v8-0815+ #5
 | Hardware name: Raspberry Pi Compute Module 4 Rev 1.0 (DT)
 | Call trace:
 |  dump_backtrace.part.0+0x1dc/0x1ec
 |  show_stack+0x24/0x80
 |  dump_stack_lvl+0x8c/0xb8
 |  dump_stack+0x1c/0x38
 |  create_object.isra.0+0x490/0x4b0
 |  kmemleak_alloc+0x3c/0x50
 |  kmem_cache_alloc+0x2f8/0x450
 |  __proc_create+0x18c/0x400
 |  proc_create_reg+0x54/0xd0
 |  proc_create_seq_private+0x94/0x120
 |  init_mm_internals+0x1d8/0x248
 |  kernel_init_freeable+0x188/0x388
 |  kernel_init+0x30/0x150
 |  ret_from_fork+0x10/0x20
 | kmemleak: Kernel memory leak detector disabled
 | kmemleak: Object 0xffffff806e24d000 (size 2097152):
 | kmemleak:   comm "swapper", pid 0, jiffies 4294892296
 | kmemleak:   min_count = -1
 | kmemleak:   count = 0
 | kmemleak:   flags = 0x5
 | kmemleak:   checksum = 0
 | kmemleak:   backtrace:
 |      kmemleak_alloc_phys+0x94/0xb0
 |      memblock_alloc_range_nid+0x1c0/0x20c
 |      memblock_alloc_internal+0x88/0x100
 |      memblock_alloc_try_nid+0x148/0x1ac
 |      kfence_alloc_pool+0x44/0x6c
 |      mm_init+0x28/0x98
 |      start_kernel+0x178/0x3e8
 |      __primary_switched+0xc4/0xcc

Reported-by: Max Schulze <max.schulze@online.de>
Signed-off-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/all/b33b33bc-2d06-1bcd-2df7-43678962b728@online.de/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -603,6 +603,14 @@ static unsigned long kfence_init_pool(vo
 		addr += 2 * PAGE_SIZE;
 	}
 
+	/*
+	 * The pool is live and will never be deallocated from this point on.
+	 * Remove the pool object from the kmemleak object tree, as it would
+	 * otherwise overlap with allocations returned by kfence_alloc(), which
+	 * are registered with kmemleak through the slab post-alloc hook.
+	 */
+	kmemleak_free(__kfence_pool);
+
 	return 0;
 }
 
@@ -615,16 +623,8 @@ static bool __init kfence_init_pool_earl
 
 	addr = kfence_init_pool();
 
-	if (!addr) {
-		/*
-		 * The pool is live and will never be deallocated from this point on.
-		 * Ignore the pool object from the kmemleak phys object tree, as it would
-		 * otherwise overlap with allocations returned by kfence_alloc(), which
-		 * are registered with kmemleak through the slab post-alloc hook.
-		 */
-		kmemleak_ignore_phys(__pa(__kfence_pool));
+	if (!addr)
 		return true;
-	}
 
 	/*
 	 * Only release unprotected pages, and do not try to go back and change


