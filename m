Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A209F6DD8AF
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjDKLCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDKLCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:02:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7C919AD
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2BD76240E
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15B7C433D2;
        Tue, 11 Apr 2023 11:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210916;
        bh=cnVanJReD9LW5WE1ACFMvBpnxAA57Mx6a61oPhkZ/t4=;
        h=Subject:To:Cc:From:Date:From;
        b=onNkGrMnknuv/ikSHi0elXkjSGSd+8MwyMajanAN6eZ0Xdi0girZnvMm5kgw1bydF
         Axqvg7aM0tzWRUD/eW/6ROx7EwJCFUvzWmpCQMhHArE64TPyNgdz6gwc9okrKyaFok
         S2AUX/Lq1eZOTcGSopK4Z5qz15OG0inPUI16vTMo=
Subject: FAILED: patch "[PATCH] mm: kfence: fix handling discontiguous page" failed to apply to 5.15-stable tree
To:     muchun.song@linux.dev, akpm@linux-foundation.org,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, sjpark@amazon.de, songmuchun@bytedance.com,
        stable@vger.kernel.org, wangkefeng.wang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:01:53 +0200
Message-ID: <2023041153-figment-fanfare-e9c7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 1f2803b2660f4b04d48d065072c0ae0c9ca255fd
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041153-figment-fanfare-e9c7@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

1f2803b2660f ("mm: kfence: fix handling discontiguous page")
3ee2d7471fa4 ("mm: kfence: fix PG_slab and memcg_data clearing")
8f0b36497303 ("mm: kfence: fix objcgs vector allocation")
b33f778bba5e ("kfence: alloc kfence_pool after system startup")
698361bca2d5 ("kfence: allow re-enabling KFENCE after system startup")
07e8481d3c38 ("kfence: always use static branches to guard kfence_alloc()")
08f6b10630f2 ("kfence: limit currently covered allocations when pool nearly full")
a9ab52bbcb52 ("kfence: move saving stack trace of allocations into __kfence_alloc()")
9a19aeb56650 ("kfence: count unexpectedly skipped allocations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1f2803b2660f4b04d48d065072c0ae0c9ca255fd Mon Sep 17 00:00:00 2001
From: Muchun Song <muchun.song@linux.dev>
Date: Thu, 23 Mar 2023 10:50:03 +0800
Subject: [PATCH] mm: kfence: fix handling discontiguous page

The struct pages could be discontiguous when the kfence pool is allocated
via alloc_contig_pages() with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.

This may result in setting PG_slab and memcg_data to a arbitrary
address (may be not used as a struct page), which in the worst case
might corrupt the kernel.

So the iteration should use nth_page().

Link: https://lkml.kernel.org/r/20230323025003.94447-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index d66092dd187c..1065e0568d05 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -556,7 +556,7 @@ static unsigned long kfence_init_pool(void)
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;
@@ -602,7 +602,7 @@ static unsigned long kfence_init_pool(void)
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;

