Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7DE4CCCC8
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 06:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiCDFHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 00:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiCDFHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 00:07:36 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB28217DBAC;
        Thu,  3 Mar 2022 21:06:47 -0800 (PST)
X-UUID: cb14e59974f441dcaacf47b8544318de-20220304
X-UUID: cb14e59974f441dcaacf47b8544318de-20220304
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1056646400; Fri, 04 Mar 2022 13:06:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 4 Mar 2022 13:06:40 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Mar 2022 13:06:39 +0800
From:   <yf.wang@mediatek.com>
To:     <iommu@lists.linux-foundation.org>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>
Subject: Re: [PATCH] iommu/iova: Free all CPU rcache for retry when iova alloc failure
Date:   Fri, 4 Mar 2022 13:00:40 +0800
Message-ID: <20220304050040.4599-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220304044635.4273-1-yf.wang@mediatek.com>
References: <20220304044635.4273-1-yf.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-03-04 at 12:46 +0800, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> In alloc_iova_fast function, if an iova alloc request fail,
> it will free the iova ranges present in the percpu iova
> rcaches and free global iova rcache and then retry, but
> flushing CPU iova rcaches only for each online CPU, which
> will cause incomplete rcache cleaning, and iova rcaches of
> not online CPU cannot be flushed, because iova rcaches may
> also lead to fragmentation of iova space, so the next retry
> action may still be fail.
> 
> Based on the above, so need to flushing all iova rcaches
> for each possible CPU, use for_each_possible_cpu instead of
> for_each_online_cpu like in free_iova_rcaches function,
> so that all rcaches can be completely released to try
> replenishing IOVAs.
> 
> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.4.*
> ---
>  drivers/iommu/iova.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
> index b28c9435b898..5a0637cd7bc2 100644
> --- a/drivers/iommu/iova.c
> +++ b/drivers/iommu/iova.c
> @@ -460,7 +460,7 @@ alloc_iova_fast(struct iova_domain *iovad,
> unsigned long size,
>  
>  		/* Try replenishing IOVAs by flushing rcache. */
>  		flush_rcache = false;
> -		for_each_online_cpu(cpu)
> +		for_each_possible_cpu(cpu)
>  			free_cpu_cached_iovas(cpu, iovad);
>  		free_global_cached_iovas(iovad);
>  		goto retry;

The following is the actual stress test log dump: 
1. __alloc_and_insert_iova_range_fail
[name:iova&]__alloc_and_insert_iova_range_fail:  iovad:0xffffff80dc9e6008 {granule:0x1000, start_pfn:0x40000, dma_32bit_pfn:0x100000, max32_alloc_size:0x731f},size:0x731f

2. dump all iova nodes of rbtree, contain cached iova:
[name:iova&]dump_iova_rbtree start:
[name:iova&]index    iova            pfn_lo      size      pfn_hi
[name:iova&]   1 0xffffff80680f8f80  0x47000000  0x4c9000  0x474c8000
[name:iova&]   2 0xffffff813e69c140  0x47500000  0x100000  0x475ff000
  ...317 lines of log are omitted here...
[name:iova&] 319 0xffffff80c8cea540  0xffefc000  0x4000    0xffeff000
[name:iova&] 320 0xffffff80de3a14c0  0xfff00000  0x100000  0xfffff000
[name:iova&] 321 0xffffff80dc9e6060  0xfffffffffffff000 0x1000 0xfffffffffffff000
[name:iova&]dump_iova_rbtree done, iovad:0xffffff80dc9e6008, count:321, total_size:606964KB

3. for_each_possible_cpu dump all cached iovas by iova_magazine pfns:
cpu:*-1: online cpu, cpu:*-0: not online cpu
[name:iova&]dump_iova_list, for_each_possible_cpu iovad:0xffffff80dc9e6008

3.1 online cpu cached iovas:
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:0-1, cache:0, iova_size:0x1000
[name:iova&]mag    iova              pfn_lo      size    pfn_h
[name:iova&]0/2  0xffffff8089c93c40  0xb8aff000  0x1000  0xb8aff000
[name:iova&]1/2  0xffffff8072046c40  0x716cf000  0x1000  0x716cf000
... omit other online cpu cached iovas ...

3.2 not online cpu cached iovas
... omit other not online cpu cached iovas ...
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:7-0, cache:5, iova_size:0x20000
[name:iova&]mag    iova               pfn_lo      size    pfn_hi
[name:iova&]0/10  0xffffff82b728ea40  0xdfbe0000  0x20000  0xdfbff000
[name:iova&]1/10  0xffffff82b728e480  0xee1e0000  0x20000  0xee1ff000
[name:iova&]2/10  0xffffff81a9fc5440  0xf27c0000  0x20000  0xf27df000
[name:iova&]3/10  0xffffff816f213800  0xd7fe0000  0x20000  0xd7fff000
[name:iova&]4/10  0xffffff80aa3fbf00  0xdb0e0000  0x20000  0xdb0ff000
[name:iova&]5/10  0xffffff8109217b00  0x4a7e0000  0x20000  0x4a7ff000
[name:iova&]6/10  0xffffff8109217540  0xb55a0000  0x20000  0xb55bf000
[name:iova&]7/10  0xffffff82b728e580  0xf33c0000  0x20000  0xf33df000
[name:iova&]8/10  0xffffff8109217500  0x7b5e0000  0x20000  0x7b5ff000
[name:iova&]9/10  0xffffff81a9fc5a80  0xf2da0000  0x20000  0xf2dbf000
[name:iova&]dump_iova_list, done iovad:0xffffff80dc9e6008, cpu_mask:0xff(11111111), online_cpu_mask:(00111111)

4. alloc fail, flushing rcache and retry:
[name:iova&]alloc_iova_fast, flushing rcache and retry, iovad:0xffffff80dc9e6008, size:0x731f, limit_pfn:0xfffff

5. retry and alloc fail again.
[name:iova&]__alloc_and_insert_iova_range_fail, iovad:0xffffff80dc9e6008 {granule:0x1000, start_pfn:0x40000, dma_32bit_pfn:0x100000, max32_alloc_size:0x731f},size:0x731f

6. dump all iova nodes of rbtree, contain cached iova:
[name:iova&]dump_iova_rbtree start:
[name:iova&]index    iova                pfn_lo      size    pfn_hi
[name:iova&]   1 0xffffff80680f8f80 0x47000000 0x4c9000  0x474c8000    
[name:iova&]   2 0xffffff813e69c140 0x47500000 0x100000  0x475ff000    
... 215 lines of log are omitted here ...
[name:iova&] 217 0xffffff80c8cea540 0xffefc000 0x4000    0xffeff000    
[name:iova&] 218 0xffffff80de3a14c0 0xfff00000 0x100000  0xfffff000    
[name:iova&] 219 0xffffff80dc9e6060 0xfffffffffffff000 0x1000 0xfffffffffffff000
[name:iova&]dump_iova_rbtree done, iovad:0xffffff80dc9e6008, count:219, total_size:603640KB

7. for_each_possible_cpu dump all cached iovas by iova_magazine pfns:
cpu:*-1: online cpu, cpu:*-0: not online cpu
[name:iova&]dump_iova_list, for_each_possible_cpu iovad:0xffffff80dc9e6008

7.1 online cpu cached iovas empty
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:0-1, cache:0, iova_size:0x1000 empty
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:0-1, cache:1, iova_size:0x2000 empty
... omit other online cpus ...
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:5-1, cache:4, iova_size:0x10000 empty
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:5-1, cache:5, iova_size:0x20000 empty

7.1 not online cpu cached iovas still have cached iovas:
... omit other not online cpu cached iovas ...
[name:iova&]dump_cpu_cached_iovas, iovad:0xffffff80dc9e6008, cpu:7-0, cache:5, iova_size:0x20000
[name:iova&]mag    iova               pfn_lo      size    pfn_hi
[name:iova&]0/10  0xffffff82b728ea40  0xdfbe0000  0x20000  0xdfbff000
[name:iova&]1/10  0xffffff82b728e480  0xee1e0000  0x20000  0xee1ff000
[name:iova&]2/10  0xffffff81a9fc5440  0xf27c0000  0x20000  0xf27df000
[name:iova&]3/10  0xffffff816f213800  0xd7fe0000  0x20000  0xd7fff000
[name:iova&]4/10  0xffffff80aa3fbf00  0xdb0e0000  0x20000  0xdb0ff000
[name:iova&]5/10  0xffffff8109217b00  0x4a7e0000  0x20000  0x4a7ff000
[name:iova&]6/10  0xffffff8109217540  0xb55a0000  0x20000  0xb55bf000
[name:iova&]7/10  0xffffff82b728e580  0xf33c0000  0x20000  0xf33df000
[name:iova&]8/10  0xffffff8109217500  0x7b5e0000  0x20000  0x7b5ff000
[name:iova&]9/10  0xffffff81a9fc5a80  0xf2da0000  0x20000  0xf2dbf000
[name:iova&]dump_iova_list, done iovad:0xffffff80dc9e6008, cpu_mask:0xff(11111111), online_cpu_mask:0x3f(00111111)

Thanks,
Yunfei.
