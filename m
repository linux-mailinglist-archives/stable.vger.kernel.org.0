Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B84FD434
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356083AbiDLHeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351770AbiDLH14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9556A4EDF2;
        Tue, 12 Apr 2022 00:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E582B81B4E;
        Tue, 12 Apr 2022 07:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A56C385A1;
        Tue, 12 Apr 2022 07:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747275;
        bh=HPAQBXuqTfOzc6IvGtBWcF+pFVDLWJ32autnf6dHJeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxZERUlxojdDtdtxtbvjQQ/EEZWgLqRpYDY3RRzVNxpiQwTK/cOlPaRYw5BFV/0Tf
         kYVdopPtK8OQhyBehBITfOdMfcB9T57kByC1YP7uMzWD4MnSnz2T1SaAKnd1j1pUff
         9jNsl0HTvOfNw/8md7+vC0gwkH5imvcQp1AiqwY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Marco Elver <elver@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 005/343] mm: kfence: fix objcgs vector allocation
Date:   Tue, 12 Apr 2022 08:27:03 +0200
Message-Id: <20220412062951.256840405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 8f0b36497303487d5a32c75789c77859cc2ee895 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kfence/core.c   | 11 ++++++++++-
 mm/kfence/kfence.h |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 13128fa13062..d4c7978cd75e 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -555,6 +555,8 @@ static bool __init kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct slab *slab = page_slab(&pages[i]);
+
 		if (!i || (i % 2))
 			continue;
 
@@ -562,7 +564,11 @@ static bool __init kfence_init_pool(void)
 		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
 			goto err;
 
-		__SetPageSlab(&pages[i]);
+		__folio_set_slab(slab_folio(slab));
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
+				   MEMCG_DATA_OBJCGS;
+#endif
 	}
 
 	/*
@@ -938,6 +944,9 @@ void __kfence_free(void *addr)
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
-- 
2.35.1



