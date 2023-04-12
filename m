Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A3D6DEEAF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjDLIoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjDLIoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4922C8684
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE30F630B2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09889C433EF;
        Wed, 12 Apr 2023 08:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288990;
        bh=iZ9yxT2Xc3z9E5xZeb0E5BX1+xBQycOMYzMy+EJVKJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zxp/0dN8DETbG+tyxK+WU4+dmNpGiOcASIyhvn3YK289x0Ghw36p4tdVhOKNXQCZq
         iIZYc81Lf6U8JU51uMLq1vOW0oo3U2TcdUaMKjLxkTiWJCH3lyK2UD320B89j47wh3
         oPEQ0/D2ed+XWk9nyww05AVDeIbQPOaaqPbTGhts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Muchun Song <songmuchun@bytedance.com>,
        Marco Elver <elver@google.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jann Horn <jannh@google.com>, SeongJae Park <sjpark@amazon.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 095/164] mm: kfence: fix handling discontiguous page
Date:   Wed, 12 Apr 2023 10:33:37 +0200
Message-Id: <20230412082840.711859772@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit 1f2803b2660f4b04d48d065072c0ae0c9ca255fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -557,7 +557,7 @@ static unsigned long kfence_init_pool(vo
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;
@@ -603,7 +603,7 @@ static unsigned long kfence_init_pool(vo
 
 reset_slab:
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
-		struct slab *slab = page_slab(&pages[i]);
+		struct slab *slab = page_slab(nth_page(pages, i));
 
 		if (!i || (i % 2))
 			continue;


