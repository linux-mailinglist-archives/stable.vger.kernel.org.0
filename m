Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251201E56FE
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 07:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgE1FsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 01:48:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53740 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgE1FsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 01:48:23 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200528054820euoutp0132e03c200ce2501128550812238a0afc~TGxwfK-sr2840928409euoutp01V
        for <stable@vger.kernel.org>; Thu, 28 May 2020 05:48:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200528054820euoutp0132e03c200ce2501128550812238a0afc~TGxwfK-sr2840928409euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590644901;
        bh=78X7uugzjo3ajXjuTCkqQ21KH/n1p0CM9o55Qz0W+jo=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=LupgRNS5aYGwtOXcqD34A7uB87jKMGjlbQUnWXBD11wafEPEaDpp5UsZ7goUG4MxM
         sWcNJ4lBiNO7Nae2jw6WKnPcj9n8rGoxkpj1pOIKPkY/Q56yWT3stxo5QV2lECxwWE
         /wb5Qp9CI3loFFmEeu38amPFAUfCjeqKEB+mF9jk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200528054820eucas1p135642804c96f7a3dbddfc5e0decf9461~TGxwG1TSa2257322573eucas1p1n;
        Thu, 28 May 2020 05:48:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C4.86.60698.4A05FCE5; Thu, 28
        May 2020 06:48:20 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200528054820eucas1p16ab6bc1dc0db7b4cff5698724329afeb~TGxvxD0dX2443224432eucas1p16;
        Thu, 28 May 2020 05:48:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528054820eusmtrp27f442029bed074ca16d7926eec6d86ac~TGxvwddo10571605716eusmtrp2C;
        Thu, 28 May 2020 05:48:20 +0000 (GMT)
X-AuditID: cbfec7f5-a29ff7000001ed1a-27-5ecf50a4c999
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CC.E5.07950.4A05FCE5; Thu, 28
        May 2020 06:48:20 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200528054819eusmtip2b1a5039cfe8ffd4ea5f1ffa327f7e9e1~TGxvYFCdr0579205792eusmtip2k;
        Thu, 28 May 2020 05:48:19 +0000 (GMT)
Subject: Re: [PATCHv2] media: videobuf2-dma-contig: fix bad kfree in
 vb2_dma_contig_clear_max_seg_size
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <8b53b12f-2971-8b92-9617-a73d0b9d312f@samsung.com>
Date:   Thu, 28 May 2020 07:48:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200527082334.20774-1-tomi.valkeinen@ti.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHeXa3u7vR1uNceZiiNbVISJNJDCyt6MOoiL4FkauVl01yUzZf
        g0AUQ4eKFlkNYWv5UtZ8meVbr450lKSZI+acmCaB2jC0TEsyrzfLb7/z///Pc86BhyIkNp6M
        SjNk0UaDJl1OCrntfcuDe2tPDar3NU6GKYe7a0hlWctjnrLeucJR2lonkbLZ6iOVbsfpQ6TK
        2VhKqvwfnpIqt7eDo1pwhp/inhEeSKXT03JoY1zSeaGuv+gOJ7MsIm9+tZdTgKplZiSgACeA
        tXCRYFiC7yF4MZpgRsI1/oZgdKyRzxYLCF6NtXI2OoqGx7ms0YCga6iEZIs5BHX3n5BMKhjr
        wNn7lWAMKe5EMFbahxiDwMmwODvNZ5jE8WAOmNcbRDgJWsq71piiuDgaflVqGXkbToGy8RmC
        jQTB69tTXIYFOBG87gaSfTICOgI1BMsh4Juycpi5gO18mPe/Idm1j8Jd+ycey8Ew437EZzkM
        Vrs2GooQTAw4+GxRhmC48BZiU4ngH/i5vh2B90BzdxwrH4bi6w0EIwMWgzcQxC4hhmvtN//K
        Iii5KmHTu8Dibvo3tufde6ISyS2bTrNsOsey6RzL/7k2xG1EIXS2Sa+lTQoDnRtr0uhN2QZt
        7MUMvROt/Zv+3+7vnej5ygUXwhSSbxGVHBtQS3iaHFO+3oWAIuRS0ZG3/WqJKFWTf5k2Zpwz
        ZqfTJhcKpbjyEJHCPp0iwVpNFn2JpjNp44bLoQSyAhQa+Ojz+HqTFdYH0h0xx5d9VS7e6ta6
        2r60BVXokl188kt7nrxO+5IMd2y3itWS/VlXomlF0wh5EN/wCnQ2xZyt3DOCPT+iIvPqBZ+t
        8+7cCttQfo94Ke5EW/nEw53FOLJiYnb22Vl/VG0K7Wj2J0zGVi1JZW3TtdWduz1yrkmniY8h
        jCbNHwjM73kzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xe7pLAs7HGWzby2VxedccNoueDVtZ
        LZZt+sNksWDjI0aL9fNvsVkcXxvuwOaxaVUnm8eda3vYPI7f2M7k8XmTXABLlJ5NUX5pSapC
        Rn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7G6eaFTAU98hWf/h9l
        amCcJtXFyMkhIWAi0Xz5PksXIxeHkMBSRon5F/8zQSRkJE5Oa2CFsIUl/lzrYoMoessocaXh
        LliRsECGxKajH5hBEiICuxglFt2+yAaSYBawl/j2+iU7REcfo8TOO5/BEmwChhJdb7vAbF4B
        O4kNvTuBbA4OFgFVid8T0kHCogKxEt2Lf7BDlAhKnJz5hAXE5hSwlrhxfDnUfDOJeZsfMkPY
        8hLb386BssUlbj2ZzzSBUWgWkvZZSFpmIWmZhaRlASPLKkaR1NLi3PTcYiO94sTc4tK8dL3k
        /NxNjMAI23bs55YdjF3vgg8xCnAwKvHwGnicixNiTSwrrsw9xCjBwawkwut09nScEG9KYmVV
        alF+fFFpTmrxIUZToN8mMkuJJucDoz+vJN7Q1NDcwtLQ3Njc2MxCSZy3Q+BgjJBAemJJanZq
        akFqEUwfEwenVANjXfziLRsk7CM/nv6stDHaJF9yZfI3I8ErtW7TmpKm+c/SW9o2M97gVICZ
        ttKPbWnxvAbv9d9LWr+KLI6qvD1PPfzE9Iz9XEsesH/c3DJXZE6zgGJ/9aljhZM/B062abN/
        /nH/r6e86SV6nzp6wjJ9K/tWVOjz6OsciDkX/Oj80d3Vjto3V7YosRRnJBpqMRcVJwIAjnmF
        TcYCAAA=
X-CMS-MailID: 20200528054820eucas1p16ab6bc1dc0db7b4cff5698724329afeb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200527082349eucas1p1ecf28f85e6b57f5eb30f8de419cf8a0a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200527082349eucas1p1ecf28f85e6b57f5eb30f8de419cf8a0a
References: <CGME20200527082349eucas1p1ecf28f85e6b57f5eb30f8de419cf8a0a@eucas1p1.samsung.com>
        <20200527082334.20774-1-tomi.valkeinen@ti.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.05.2020 10:23, Tomi Valkeinen wrote:
> Commit 9495b7e92f716ab2bd6814fab5e97ab4a39adfdd ("driver core: platform:
> Initialize dma_parms for platform devices") in v5.7-rc5 causes
> vb2_dma_contig_clear_max_seg_size() to kfree memory that was not
> allocated by vb2_dma_contig_set_max_seg_size().
>
> The assumption in vb2_dma_contig_set_max_seg_size() seems to be that
> dev->dma_parms is always NULL when the driver is probed, and the case
> where dev->dma_parms has bee initialized by someone else than the driver
> (by calling vb2_dma_contig_set_max_seg_size) will cause a failure.
>
> All the current users of these functions are platform devices, which now
> always have dma_parms set by the driver core. To fix the issue for v5.7,
> make vb2_dma_contig_set_max_seg_size() return an error if dma_parms is
> NULL to be on the safe side, and remove the kfree code from
> vb2_dma_contig_clear_max_seg_size().
>
> For v5.8 we should remove the two functions and move the
> dma_set_max_seg_size() calls into the drivers.
>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Fixes: 9495b7e92f71 ("driver core: platform: Initialize dma_parms for platform devices")
> Cc: stable@vger.kernel.org
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>
> Changes in v2:
> * vb2_dma_contig_clear_max_seg_size to empty static inline
> * Added cc: stable and fixes tag
>
>   .../common/videobuf2/videobuf2-dma-contig.c   | 20 ++-----------------
>   include/media/videobuf2-dma-contig.h          |  2 +-
>   2 files changed, 3 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index d3a3ee5b597b..f4b4a7c135eb 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -726,9 +726,8 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>   int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
>   {
>   	if (!dev->dma_parms) {
> -		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
> -		if (!dev->dma_parms)
> -			return -ENOMEM;
> +		dev_err(dev, "Failed to set max_seg_size: dma_parms is NULL\n");
> +		return -ENODEV;
>   	}
>   	if (dma_get_max_seg_size(dev) < size)
>   		return dma_set_max_seg_size(dev, size);
> @@ -737,21 +736,6 @@ int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
>   }
>   EXPORT_SYMBOL_GPL(vb2_dma_contig_set_max_seg_size);
>   
> -/*
> - * vb2_dma_contig_clear_max_seg_size() - release resources for DMA parameters
> - * @dev:	device for configuring DMA parameters
> - *
> - * This function releases resources allocated to configure DMA parameters
> - * (see vb2_dma_contig_set_max_seg_size() function). It should be called from
> - * device drivers on driver remove.
> - */
> -void vb2_dma_contig_clear_max_seg_size(struct device *dev)
> -{
> -	kfree(dev->dma_parms);
> -	dev->dma_parms = NULL;
> -}
> -EXPORT_SYMBOL_GPL(vb2_dma_contig_clear_max_seg_size);
> -
>   MODULE_DESCRIPTION("DMA-contig memory handling routines for videobuf2");
>   MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>");
>   MODULE_LICENSE("GPL");
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index 5604818d137e..5be313cbf7d7 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -25,7 +25,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>   }
>   
>   int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size);
> -void vb2_dma_contig_clear_max_seg_size(struct device *dev);
> +static inline void vb2_dma_contig_clear_max_seg_size(struct device *dev) { }
>   
>   extern const struct vb2_mem_ops vb2_dma_contig_memops;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

