Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A632C51387E
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiD1Pjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 11:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiD1Pji (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 11:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922DA4927C
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 08:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D10761FB1
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 15:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3104BC385A0;
        Thu, 28 Apr 2022 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651160182;
        bh=VgqA40mGVOkGHBljJ9uENThKYGgZ2dWXBdFpXFyUR80=;
        h=Subject:To:Cc:From:Date:From;
        b=CEMHMUg6chEu9fgVficyjZG0jzYWQkuO897n4RFCS8dzwEYjCPpEKfexjFiE/tSyB
         Drild3xy0OK8c6pePV9d2xptgMdN4bnGIurm8L+9dLwGaZ1Hl78d9IjRu8SJd4pE0s
         GEDDm6qNRhOchjKmIAmDLB/athtUZQKP6m18HFOM=
Subject: FAILED: patch "[PATCH] mm: kfence: fix objcgs vector allocation" failed to apply to 5.15-stable tree
To:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        duanxiongchun@bytedance.com, dvyukov@google.com, elver@google.com,
        glider@google.com, roman.gushchin@linux.dev,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 17:36:20 +0200
Message-ID: <165116018052255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8f0b36497303487d5a32c75789c77859cc2ee895 Mon Sep 17 00:00:00 2001
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 1 Apr 2022 11:28:36 -0700
Subject: [PATCH] mm: kfence: fix objcgs vector allocation

If the kfence object is allocated to be used for objects vector, then
this slot of the pool eventually being occupied permanently since the
vector is never freed.  The solutions could be (1) freeing vector when
the kfence object is freed or (2) allocating all vectors statically.

Since the memory consumption of object vectors is low, it is better to
chose (2) to fix the issue and it is also can reduce overhead of vectors
allocating in the future.

Link: https://lkml.kernel.org/r/20220328132843.16624-1-songmuchun@bytedance.com
Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 2f9fdfde1941..a203747ad2c0 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -566,6 +566,8 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct slab *slab = page_slab(&pages[i]);
+
 		if (!i || (i % 2))
 			continue;
 
@@ -573,7 +575,11 @@ static unsigned long kfence_init_pool(void)
 		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
 			return addr;
 
-		__SetPageSlab(&pages[i]);
+		__folio_set_slab(slab_folio(slab));
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
+				   MEMCG_DATA_OBJCGS;
+#endif
 	}
 
 	/*
@@ -1033,6 +1039,9 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
+#ifdef CONFIG_MEMCG
+	KFENCE_WARN_ON(meta->objcg);
+#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 2a2d5de9d379..9a6c4b1b12a8 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -89,6 +89,9 @@ struct kfence_metadata {
 	struct kfence_track free_track;
 	/* For updating alloc_covered on frees. */
 	u32 alloc_stack_hash;
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup *objcg;
+#endif
 };
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];

