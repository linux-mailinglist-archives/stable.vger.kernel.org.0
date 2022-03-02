Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88E4CB3B2
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 01:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiCBXxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 18:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiCBXxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 18:53:44 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C3D1987;
        Wed,  2 Mar 2022 15:52:53 -0800 (PST)
X-UUID: e55578293866465f8f422d077c288aa3-20220303
X-UUID: e55578293866465f8f422d077c288aa3-20220303
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 342637879; Thu, 03 Mar 2022 07:52:45 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 3 Mar 2022 07:52:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Mar 2022 07:52:43 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <robin.murphy@arm.com>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <miles.chen@mediatek.com>, <stable@vger.kernel.org>,
        <will@kernel.org>, <wsd_upstream@mediatek.com>,
        <yf.wang@mediatek.com>
Subject: Re: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning
Date:   Thu, 3 Mar 2022 07:52:38 +0800
Message-ID: <20220302235238.13099-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <ca208635-449b-2c94-7317-09ed8eb86a2c@arm.com>
References: <ca208635-449b-2c94-7317-09ed8eb86a2c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> If no cached iova is freed, resetting max32_alloc_size before
>> the retry allocation only give us a retry. Is it possible that
>> other users free their iovas during the additional retry?
>
> No, it's not possible, since everyone's serialised by iova_rbtree_lock. 
> If the caches were already empty and the retry gets the lock first, it 
> will still fail again - forcing a reset of max32_alloc_size only means 
> it has to take the slow path to that failure. If another caller *did* 
> manage to get in and free something between free_global_cached_iovas() 
> dropping the lock and alloc_iova() re-taking it, then that would have 
> legitimately reset max32_alloc_size anyway.

Thanks for your explanation.

YF showed me some numbers yesterday and maybe we can have a further
discussion in that test case. (It looks like that some iovas are freed but
their pfn_lo(s) are less than cached_iova->pfn_lo, so max32_alloc_size is not
reset. So there are enought free iovas but the allocation still failed)

__cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
{
	struct iova *cached_iova;

	cached_iova = to_iova(iovad->cached32_node);
	if (free == cached_iova ||
		(free->pfn_hi < iovad->dma_32bit_pfn &&
		 free->pfn_lo >= cached_iova->pfn_lo)) {
		iovad->cached32_node = rb_next(&free->node);
		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
	}
	...
}

Hi YF,
Could your share your observation of the iova allocation failure you hit?

Thanks,
Miles

