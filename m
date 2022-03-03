Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397524CBE28
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 13:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiCCMuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 07:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiCCMuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 07:50:20 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1DA184B5F;
        Thu,  3 Mar 2022 04:49:30 -0800 (PST)
X-UUID: b7cf26c6ff394763860ea75a05adee32-20220303
X-UUID: b7cf26c6ff394763860ea75a05adee32-20220303
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 862839539; Thu, 03 Mar 2022 20:49:26 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 3 Mar 2022 20:49:25 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Mar 2022 20:49:24 +0800
From:   <yf.wang@mediatek.com>
To:     <iommu@lists.linux-foundation.org>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <Yong.Wu@mediatek.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <miles.chen@mediatek.com>, <robin.murphy@arm.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>,
        "yf . wang @ mediatek . com" <yf.wang@medaitek.com>
Subject: Re: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning
Date:   Thu, 3 Mar 2022 20:43:23 +0800
Message-ID: <20220303124323.32114-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220302235238.13099-1-miles.chen@mediatek.com>
References: <20220302235238.13099-1-miles.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yf.wang@mediatek.com <yf.wang@medaitek.com>

On Thu, 2022-03-03 at 07:52 +0800, Miles Chen wrote:
> Thanks for your explanation.
> 
> YF showed me some numbers yesterday and maybe we can have a further
> discussion in that test case. (It looks like that some iovas are
> freed but
> their pfn_lo(s) are less than cached_iova->pfn_lo, so
> max32_alloc_size is not
> reset. So there are enought free iovas but the allocation still
> failed)
> 
> __cached_rbnode_delete_update(struct iova_domain *iovad, struct iova
> *free)
> {
>       struct iova *cached_iova;
> 
>       cached_iova = to_iova(iovad->cached32_node);
>       if (free == cached_iova ||
>               (free->pfn_hi < iovad->dma_32bit_pfn &&
>                free->pfn_lo >= cached_iova->pfn_lo)) {
>               iovad->cached32_node = rb_next(&free->node);
>               iovad->max32_alloc_size = iovad->dma_32bit_pfn;
>       }
>       ...
> }
> 
> Hi YF,
> Could your share your observation of the iova allocation failure you
> hit?
> 
> Thanks,
> Miles

Hi Miles & Robin,

The scenario we encountered in our actual test:
An iova domain with a 3GB iova region (0x4000_0000~0x1_0000_0000),
only alloc iova total size 614788KB), then alloc iova size=0x731f000
fail, and then the retry mechanism is free 300 cache iova at first,
and then retry still fail, the reason for fail is blocked by the
check condition (size >= iovad->max32_alloc_size) and goto iova32_full
directly.

Why is no reset max32_alloc_size in __cached_rbnode_delete_update?
Because of the pfn_lo of the freed cache iova is smaller than the
current cached32_node's pfn_lo (free->pfn_lo < cached_iova->pfn_lo),
so will not execute (iovad->max32_alloc_size = iovad->dma_32bit_pfn),
is blocked by the check condition (free->pfn_lo >= cached_iova-
>pfn_lo).

The issue observed during stress testing, when alloc fail reset
max32_alloc_size to retry can help to allocate iova to those lower
addresses.


The following is the actual stress test log dump: 
('pfn_lo', 'size' and 'pfn_hi' has iova_shift in dump log)
size:                 0x731f000
max32_alloc_size:     0x731f000
cached_iova:          0xffffff814751a1c0
cached_iova->pfn_lo:  0xf3500000
cached_iova->pfn_hi:  0xf35ff000

1.__alloc_and_insert_iova_range_fail
[name:iova&]__alloc_and_insert_iova_range_fail:
iovad:0xffffff80d5be2808
  {granule:0x1000, start_pfn:0x40000, dma_32bit_pfn:0x100000,
  max32_alloc_size:0x731f},size:0x731f

2.dump all iova nodes of rbtree, contain cached iova:
[name:iova&]dump_iova_rbtree start, iovad:0xffffff80d5be2808
  {rbroot:0xffffff814751a4c0, cached_node:0xffffff80d5be2860,
  cached32_node:0xffffff814751a1c0, granule:0x1000, start_pfn:0x40000,
  dma_32bit_pfn:0x100000, max32_alloc_size:0x731f}

('pfn_lo', 'size' and 'pfn_hi' has iova_shift in dump log)
[name:iova&]index    iova_object       pfn_lo     size       pfn_hi
[name:iova&]  1 0xffffff814751ae00  0x40800000  0x4c9000     0x40cc8000
[name:iova&]  2 0xffffff807c960880  0x40d00000  0xc4000      0x40dc3000
  ...322 lines of log are omitted here...
[name:iova&]325 0xffffff814751a1c0  0xf3500000  0x100000     0xf35ff000
[name:iova&]326 0xffffff8004552080  0xf3600000  0x100000     0xf36ff000
[name:iova&]327 0xffffff80045524c0  0xf3700000  0xbc000      0xf37bb000
[name:iova&]328 0xffffff814751a700  0xf3800000  0x265000     0xf3a64000
[name:iova&]329 0xffffff8004552180  0xf3c00000  0xa13000     0xf4612000
[name:iova&]330 0xffffff80c1b3eb40  0xf4800000  0xb400000    0xffbff000
[name:iova&]331 0xffffff80d6e0b580  0xffcff000  0x1000       0xffcff000
[name:iova&]332 0xffffff80c8395140  0xffd00000  0x80000      0xffd7f000
[name:iova&]333 0xffffff80c8395000  0xffde0000  0x20000      0xffdff000
[name:iova&]334 0xffffff80c8395380  0xffe00000  0x80000      0xffe7f000
[name:iova&]335 0xffffff80c8395880  0xffec0000  0x20000      0xffedf000
[name:iova&]336 0xffffff80c83957c0  0xffef9000  0x1000       0xffef9000
[name:iova&]337 0xffffff80c83956c0  0xffefa000  0x1000       0xffefa000
[name:iova&]338 0xffffff80c8395f40  0xffefb000  0x1000       0xffefb000
[name:iova&]339 0xffffff80c8395a80  0xffefc000  0x4000       0xffeff000
[name:iova&]340 0xffffff80c1b3e840  0xfff00000  0x100000     0xfffff000
[name:iova&]341 0xffffff80d5be2860  0xfffffffffffff000 0x1000
0xfffffffffffff000
[name:iova&]dump_iova_rbtree done, iovad:0xffffff80d5be2808,
  count:341, total_size:625876KB

3.alloc fail, flushing rcache and retry.
[name:iova&]alloc_iova_fast, flushing rcache and retry,
  iovad:0xffffff80d5be2808, size:0x731f, limit_pfn:0xfffff

4.retry is executed into the __alloc_and_insert_iova_range function:
[name:iova&]__alloc_and_insert_iova_range fail goto iova32_full,
  iovad:0xffffff80d5be2808 {granule:0x1000, start_pfn:0x40000,
  dma_32bit_pfn:0x100000, max32_alloc_size:0x731f},size:0x731f

5.dump all iova nodes of rbtree, current caches is already empty:
[name:iova&]dump_iova_rbtree start, iovad:0xffffff80d5be2808
  {rbroot:0xffffff80fe76da80, cached_node:0xffffff80d5be2860,
  cached32_node:0xffffff814751a1c0, granule:0x1000, start_pfn:0x40000,
  dma_32bit_pfn:0x100000, max32_alloc_size:0x731f}

('pfn_lo', 'size' and 'pfn_hi' has iova_shift in dump log)
[name:iova&]index    iova_object       pfn_lo     size       pfn_hi
[name:iova&]  1 0xffffff814751ae00  0x40800000  0x4c9000     0x40cc8000
[name:iova&]  2 0xffffff807c960880  0x40d00000  0xc4000      0x40dc3000
[name:iova&]  3 0xffffff81487ce840  0x40e00000  0x37a000     0x41179000
[name:iova&]  4 0xffffff80fe76d600  0x41200000  0x2400000    0x435ff000
[name:iova&]  5 0xffffff8004552000  0x46800000  0x47e2000    0x4afe1000
[name:iova&]  6 0xffffff807c960a40  0x50200000  0x400000     0x505ff000
[name:iova&]  7 0xffffff818cdb5780  0x50600000  0x265000     0x50864000
[name:iova&]  8 0xffffff814751a440  0x50a00000  0x2ae000     0x50cad000
[name:iova&]  9 0xffffff818cdb5d40  0x50e00000  0x4c9000     0x512c8000
[name:iova&] 10 0xffffff81487cef40  0x51400000  0x1a25000    0x52e24000
[name:iova&] 11 0xffffff818cdb5140  0x53c00000  0x400000     0x53fff000
[name:iova&] 12 0xffffff814751a7c0  0x54000000  0x400000     0x543ff000
[name:iova&] 13 0xffffff80fe76d2c0  0x54500000  0xbc000      0x545bb000
[name:iova&] 14 0xffffff81487ce0c0  0x54600000  0x400000     0x549ff000
[name:iova&] 15 0xffffff80fe76d740  0x54a00000  0xbc000      0x54abb000
[name:iova&] 16 0xffffff8004552440  0x54b00000  0xbc000      0x54bbb000
[name:iova&] 17 0xffffff80fe76db80  0x54c00000  0x47e2000    0x593e1000
[name:iova&] 18 0xffffff818cdb5440  0x65000000  0x400000     0x653ff000
[name:iova&] 19 0xffffff8004552880  0x65400000  0x47e2000    0x69be1000
[name:iova&] 20 0xffffff814751acc0  0x6c7e0000  0x20000      0x6c7ff000
[name:iova&] 21 0xffffff80fe76d700  0x6c800000  0x47e2000    0x70fe1000
//0x70fe1000 - 0xebc00000 = 0x7ac1f000:This free range is large enough
[name:iova&] 22 0xffffff80fe76da80  0xebc00000  0x400000     0xebfff000
[name:iova&] 23 0xffffff80045523c0  0xec000000  0x400000     0xec3ff000
[name:iova&] 24 0xffffff8004552780  0xec400000  0x400000     0xec7ff000
[name:iova&] 25 0xffffff814751a1c0  0xf3500000  0x100000     0xf35ff000
[name:iova&] 26 0xffffff8004552080  0xf3600000  0x100000     0xf36ff000
[name:iova&] 27 0xffffff80045524c0  0xf3700000  0xbc000      0xf37bb000
[name:iova&] 28 0xffffff814751a700  0xf3800000  0x265000     0xf3a64000
[name:iova&] 29 0xffffff8004552180  0xf3c00000  0xa13000     0xf4612000
[name:iova&] 30 0xffffff80c1b3eb40  0xf4800000  0xb400000    0xffbff000
[name:iova&] 31 0xffffff80d6e0b580  0xffcff000  0x1000       0xffcff000
[name:iova&] 32 0xffffff80c8395140  0xffd00000  0x80000      0xffd7f000
[name:iova&] 33 0xffffff80c8395000  0xffde0000  0x20000      0xffdff000
[name:iova&] 34 0xffffff80c8395380  0xffe00000  0x80000      0xffe7f000
[name:iova&] 35 0xffffff80c8395880  0xffec0000  0x20000      0xffedf000
[name:iova&] 36 0xffffff80c83957c0  0xffef9000  0x1000       0xffef9000
[name:iova&] 37 0xffffff80c83956c0  0xffefa000  0x1000       0xffefa000
[name:iova&] 38 0xffffff80c8395f40  0xffefb000  0x1000       0xffefb000
[name:iova&] 39 0xffffff80c8395a80  0xffefc000  0x4000       0xffeff000
[name:iova&] 40 0xffffff80c1b3e840  0xfff00000  0x100000     0xfffff000
[name:iova&] 41 0xffffff80d5be2860  0xfffffffffffff000 0x1000
0xfffffffffffff000
[name:iova&]dump_iova_rbtree done, iovad:0xffffff80d5be2808,
count:41, total_size:614788KB

Thanks,
Yunfei.
