Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848356CCD35
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 00:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjC1WZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 18:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjC1WZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 18:25:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F8C1BD8;
        Tue, 28 Mar 2023 15:25:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00837619AF;
        Tue, 28 Mar 2023 22:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A57C433D2;
        Tue, 28 Mar 2023 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680042316;
        bh=AsoZC2mFmBqaLdeqMsy+MD53PPN2ig75TB6RX4ciBP0=;
        h=Date:To:From:Subject:From;
        b=DFnJw9fT4PaU9ufjoMx/TJjcOaHc3v2+Ch3N/q2VrSdC3r5S/6+K4CAuEFYQ1J4V7
         IhnP8viqeDOY+ek35WjNU55az1tBm4rsFHjgNb7lzuTsiXjM45sHkGIQadkxH+lbj6
         KqKcriKvWoTPAzomSHHkTi8+3xnuiSOLLxVCeG2U=
Date:   Tue, 28 Mar 2023 15:25:15 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, sjpark@amazon.de, jannh@google.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kfence-fix-handling-discontiguous-page.patch removed from -mm tree
Message-Id: <20230328222516.54A57C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: fix handling discontiguous page
has been removed from the -mm tree.  Its filename was
     mm-kfence-fix-handling-discontiguous-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kfence: fix handling discontiguous page
Date: Thu, 23 Mar 2023 10:50:03 +0800

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
---

 mm/kfence/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-fix-handling-discontiguous-page
+++ a/mm/kfence/core.c
@@ -556,7 +556,7 @@ static unsigned long kfence_init_pool(vo
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;
@@ -602,7 +602,7 @@ static unsigned long kfence_init_pool(vo
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-simplify-hugetlb_vmemmap_init-a-bit.patch

