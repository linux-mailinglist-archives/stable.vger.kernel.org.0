Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083A85146FE
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356614AbiD2Kqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357986AbiD2Kql (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:46:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1A8C8A83;
        Fri, 29 Apr 2022 03:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB68B83457;
        Fri, 29 Apr 2022 10:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907F1C385A7;
        Fri, 29 Apr 2022 10:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228964;
        bh=scbClq3bvSuUSn6OVTdOTqVruX5K+Ttq0QqFNqGeeu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSst96yGccGWQH5kJyQXH5GJtUN3I3tDTM1+MUxZnyVYBZDfRzPDd3oA91amBiLY9
         8kGYAaALrFSoUD4+HGcuYCYam+FXxVuwt5UbkQw5g04TEfDn0PHjFiS+l79abjbjVe
         jv0lt5ypbNr3MFhWcsylRm0VJwedjMOENnFCXPh0=
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
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 14/33] mm: kfence: fix objcgs vector allocation
Date:   Fri, 29 Apr 2022 12:42:01 +0200
Message-Id: <20220429104052.756801254@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
References: <20220429104052.345760505@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 8f0b36497303487d5a32c75789c77859cc2ee895 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c   |   11 ++++++++++-
 mm/kfence/kfence.h |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -528,6 +528,8 @@ static bool __init kfence_init_pool(void
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct page *page = &pages[i];
+
 		if (!i || (i % 2))
 			continue;
 
@@ -535,7 +537,11 @@ static bool __init kfence_init_pool(void
 		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
 			goto err;
 
-		__SetPageSlab(&pages[i]);
+		__SetPageSlab(page);
+#ifdef CONFIG_MEMCG
+		page->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
+				   MEMCG_DATA_OBJCGS;
+#endif
 	}
 
 	/*
@@ -911,6 +917,9 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
+#ifdef CONFIG_MEMCG
+	KFENCE_WARN_ON(meta->objcg);
+#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
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


