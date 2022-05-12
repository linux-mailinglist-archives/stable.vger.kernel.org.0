Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B37524529
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 07:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349992AbiELFvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 01:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241110AbiELFvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 01:51:24 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003E5506E8;
        Wed, 11 May 2022 22:51:18 -0700 (PDT)
X-UUID: bc075dd5dd7149c5a3d19c88f1121c7e-20220512
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:e210bcc1-f115-4f11-af59-f2692a195f82,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:9,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:14
X-CID-META: VersionHash:faefae9,CLOUDID:f4a128f6-13a6-4067-b017-3b2864319134,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:3,EDM:-3,File:nil,QS:0,BEC:nil
X-UUID: bc075dd5dd7149c5a3d19c88f1121c7e-20220512
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <yong.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 147289659; Thu, 12 May 2022 13:51:14 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 12 May 2022 13:51:12 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 12 May 2022 13:51:11 +0800
Message-ID: <2ff41b86a7f7c7ce73cf800a7c1ecb531b835786.camel@mediatek.com>
Subject: Re: [PATCH] iommu/dma: Fix iova map result check bug
From:   Yong Wu <yong.wu@mediatek.com>
To:     <yf.wang@mediatek.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Logan Gunthorpe" <logang@deltatee.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
CC:     <wsd_upstream@mediatek.com>, Libo Kang <Libo.Kang@mediatek.com>,
        Ning Li <Ning.Li@mediatek.com>, <stable@vger.kernel.org>
Date:   Thu, 12 May 2022 13:51:11 +0800
In-Reply-To: <20220507085204.16914-1-yf.wang@mediatek.com>
References: <20220507085204.16914-1-yf.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2022-05-07 at 16:52 +0800, yf.wang@mediatek.com wrote:
> From: Yunfei Wang <yf.wang@mediatek.com>
> 
> The data type of the return value of the iommu_map_sg_atomic
> is ssize_t, but the data type of iova size is size_t,
> e.g. one is int while the other is unsigned int.
> 
> When iommu_map_sg_atomic return value is compared with iova size,
> it will force the signed int to be converted to unsigned int, if
> iova map fails and iommu_map_sg_atomic return error code is less
> than 0, then (ret < iova_len) is false, which will to cause not
> do free iova, and the master can still successfully get the iova
> of map fail, which is not expected.
> 
> Therefore, we need to check the return value of iommu_map_sg_atomic
> in two cases according to whether it is less than 0.
> 
> Fixes: ad8f36e4b6b1 ("iommu: return full error code from
> iommu_map_sg[_atomic]()")
> Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
> Cc: <stable@vger.kernel.org> # 5.15.*
> ---
>  drivers/iommu/dma-iommu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 09f6e1c0f9c0..2932281e93fc 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -776,6 +776,7 @@ static struct page
> **__iommu_dma_alloc_noncontiguous(struct device *dev,
>  	unsigned int count, min_size, alloc_sizes = domain-
> >pgsize_bitmap;
>  	struct page **pages;
>  	dma_addr_t iova;
> +	ssize_t ret;
>  
>  	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
>  	    iommu_deferred_attach(dev, domain))
> @@ -813,8 +814,8 @@ static struct page
> **__iommu_dma_alloc_noncontiguous(struct device *dev,
>  			arch_dma_prep_coherent(sg_page(sg), sg-
> >length);
>  	}
>  
> -	if (iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt-
> >orig_nents, ioprot)
> -			< size)
> +	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt-
> >orig_nents, ioprot);
> +	if (ret < 0 || ret < size)

        if (IS_ERR_VALUE(ret) || ret < size) for readable?

>  		goto out_free_sg;
>  
>  	sgt->sgl->dma_address = iova;
> @@ -1209,7 +1210,7 @@ static int iommu_dma_map_sg(struct device *dev,
> struct scatterlist *sg,
>  	 * implementation - it knows better than we do.
>  	 */
>  	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
> -	if (ret < iova_len)
> +	if (ret < 0 || ret < iova_len)
>  		goto out_free_iova;
>  
>  	return __finalise_sg(dev, sg, nents, iova);

