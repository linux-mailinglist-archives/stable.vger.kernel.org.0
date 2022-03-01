Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047DD4C9954
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 00:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiCAXat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 18:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiCAXas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 18:30:48 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783375B3D9;
        Tue,  1 Mar 2022 15:30:02 -0800 (PST)
X-UUID: bbcaa81436984a8397dd5bbe6dff26f7-20220302
X-UUID: bbcaa81436984a8397dd5bbe6dff26f7-20220302
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 118112189; Wed, 02 Mar 2022 07:29:55 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 2 Mar 2022 07:29:53 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Mar 2022 07:29:53 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <stable@vger.kernel.org>, <will@kernel.org>,
        <wsd_upstream@mediatek.com>, <yf.wang@mediatek.com>
Subject: Re: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning
Date:   Wed, 2 Mar 2022 07:29:53 +0800
Message-ID: <20220301232953.17331-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <b10031aa-8e49-70b3-b498-8aa6b7021fbb@arm.com>
References: <b10031aa-8e49-70b3-b498-8aa6b7021fbb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Yunfei,

>> Since __alloc_and_insert_iova_range fail will set the current alloc
>> iova size to max32_alloc_size (iovad->max32_alloc_size = size),
>> when the retry is executed into the __alloc_and_insert_iova_range
>> function, the retry action will be blocked by the check condition
>> (size >= iovad->max32_alloc_size) and goto iova32_full directly,
>> causes the action of retry regular alloc iova in
>> __alloc_and_insert_iova_range to not actually be executed.
>> 
>> Based on the above, so need reset max32_alloc_size before retry alloc
>> iova when alloc iova fail, that is set the initial dma_32bit_pfn value
>> of iovad to max32_alloc_size, so that the action of retry alloc iova
>> in __alloc_and_insert_iova_range can be executed.
>
> Have you observed this making any difference in practice?
> 
> Given that both free_cpu_cached_iovas() and free_global_cached_iovas() 
> call iova_magazine_free_pfns(), which calls remove_iova(), which calls 
> __cached_rbnode_delete_update(), I'm thinking no...
> 
> Robin.
>

Like Robin pointed out, if some cached iovas are freed by
free_global_cached_iovas()/free_cpu_cached_iovas(), 
the max32_alloc_size should be reset to iovad->dma_32bit_pfn.

If no cached iova is freed, resetting max32_alloc_size before
the retry allocation only give us a retry. Is it possible that
other users free their iovas during the additional retry?

alloc_iova_fast()
  retry:
    alloc_iova() // failed, iovad->max32_alloc_size = size
    free_cpu_cached_iovas()
      iova_magazine_free_pfns()
        remove_iova()
	  __cached_rbnode_delete_update()
	    iovad->max32_alloc_size = iovad->dma_32bit_pfn // reset
    free_global_cached_iovas()
      iova_magazine_free_pfns()
        remove_iova()
	  __cached_rbnode_delete_update()
	    iovad->max32_alloc_size = iovad->dma_32bit_pfn // reset
    goto retry;

thanks,
Miles
