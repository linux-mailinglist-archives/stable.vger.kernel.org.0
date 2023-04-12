Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3E06DEF7D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjDLIvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjDLIvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D181D6E9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6149D63161
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72691C433EF;
        Wed, 12 Apr 2023 08:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289446;
        bh=aTTqA+XOj83cKvg/wZDbl4r8ZWFkET6Y17yNK5tD+Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FixqAMZo2e87hItfJMoG64JxL/FbXweBB127bkJi6HmzHsvBamODxzz7snpTmAEV4
         jSp/7PTepof1uuZMH5N886VPrAIfS/Qp2DI+tGjIZ0tLBB432WDfmz7YR03YrdU7Dl
         uvrId1ENQ0cAks72ODBq2fgrzioEc9QjsfUBU2mE=
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
Subject: [PATCH 6.2 103/173] mm: kfence: fix handling discontiguous page
Date:   Wed, 12 Apr 2023 10:33:49 +0200
Message-Id: <20230412082842.234831696@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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


