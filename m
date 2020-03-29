Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB4E196C42
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 11:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgC2Jz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 05:55:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52896 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgC2Jz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 05:55:58 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200329095555euoutp017b62f871c05e82a0204393e06d42b834~AvcyrxbPQ2679426794euoutp01G
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 09:55:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200329095555euoutp017b62f871c05e82a0204393e06d42b834~AvcyrxbPQ2679426794euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585475755;
        bh=ZE/8RPCzXsNKOub72kPPybyFco+1U8wUJ08oc7Pxotc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=bWBcgspMolpapA2FIPkBywqcySqyokj9lx2m1Ya71GO8I80yNVv2lvjwmS9CZaew5
         MQ9THwdjlTaLsP3iFEVWwjisXhlS/Y5+QYyOTDzs4Gn5pX3SUvD2AsaSGqQAjWDGHB
         9Hm2oOEFFqdaKlMtFZAiZHS0wKKTD2I2Vqz2EzLw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200329095555eucas1p2b56dc2cdb4c4e2a30541b88a186b6f5a~AvcyRlgA82895928959eucas1p21;
        Sun, 29 Mar 2020 09:55:55 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C2.1A.60698.AA0708E5; Sun, 29
        Mar 2020 10:55:55 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200329095554eucas1p2153edb2d11e85bb092aea8562a9357d5~AvcxlcMzH1913719137eucas1p2F;
        Sun, 29 Mar 2020 09:55:54 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200329095554eusmtrp14d379a191ac3af5df37b5a5e6c8ed976~AvcxkwYM82129621296eusmtrp14;
        Sun, 29 Mar 2020 09:55:54 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-6b-5e8070aa4035
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.A2.08375.AA0708E5; Sun, 29
        Mar 2020 10:55:54 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200329095553eusmtip2904d1afdb45fd775b0d195520eb39bae~Avcwz3tQu0515205152eusmtip2U;
        Sun, 29 Mar 2020 09:55:53 +0000 (GMT)
Subject: Re: [PATCH v2] drm/prime: fix extracting of the DMA addresses from
 a scatterlist
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Shane Francis <bigbeeshane@gmail.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <8a09916d-5413-f9a8-bafa-2d8f0b8f892f@samsung.com>
Date:   Sun, 29 Mar 2020 11:55:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfyyUcRzH+z7Pc889TqfH0XymUl1pY0uMrWdlytbaU39UVv+Eri6e0eLY
        naOrtsiPuJRkQ5eF2tCVMxzyIxuaI0VS+iWia/Irs8OWUN09/fDf5/39vD7vz+e9fSlcYha4
        UmcUcZxSIY+SkiKitv17z/YHsYky74lSxFzr7sSY3IFGAVOZXyFgkuqvY8zP2myceTU3TTJ9
        DQUkk9/TjDHFMzUE86LOk0nLKBEwRZUjiDFOZgv2itnUl0sk+3i+iGDrdR+F7L2mMYyt0meQ
        bN38JwF7pzOIHbpqwtjrRj1iq7susJYqtyP2wSL/cC7qTDyn3BFwShRpWRokYi1bz9Vo27BE
        dN9NiygKaD8o7knQIhElocsQFLZMCnkxi+DJQjLBCwuCpucVpBbZ2SZyk1JxvlGK4M2SFuPF
        NALDazNmpZzoEBhYMBDW2plOxmA485AVwulMHEZLBnFrg6R9QDultdmK6QDQpRTYBgjaHSxL
        1kPsqLV0KPS2ZQl4xhE6b5ltjB19DNqHDDYGpzdC3VQBztcu8N5caLsI6AwKjCWDGJ90H1zL
        2sFHcIJxk1HI1+uhKyeT4PlkBMPd5UJeZCLou5yPeGo3DHQvkFYjnPaAioY/RoFQ2TtD8v4O
        8HbKkb/BAW7W5uH8sxjS0yQ8vQ10JsO/tS0vXuI3kFS3IpluRRrdijS6/3uLEKFHLpxaFR3B
        qXwVXIKXSh6tUisivMJioqvQ77/XtWyae4SaF0+3IppC0tVib80lmUQgj1dpolsRULjUWUwe
        TpRJxOFyzXlOGXNSqY7iVK1oHUVIXcS+d8dOSOgIeRx3luNiOeXfLkbZuSaitI5G+HBr1xd9
        SNCaSM3Eu2ANGsPjNs+6u29oGq9OWf3ZmOUcFqNduHd7s8OzUaeaUO+nfdzhavXOEX/S45vX
        w+PfUuzD/cSyXjJn/4y6f0/U16yOKxe7k/aUHWjY5HkjfWJ/unC+YzrQeWQ5L/XCj1VNWxaV
        XeXB/e6TR4MUB3VJUkIVKffxxJUq+S+w4yurdwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t/xe7qrChriDH40iVj0njvJZDHtzm5W
        i40z1rNaNO7sY7L4v20is8WVr+/ZLC7vmsNmMeP8PiaLhR+3slhc2K5l0da5jNViwcZHjBZb
        3kxkdeD1aL30l81j77cFLB47Z91l91i85yWTx6ZVnWwe2789YPWYdzLQ4373cSaPvi2rGD02
        n672+LxJLoA7Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1
        SN8uQS/j8997LAWfVSq2dh1mamBcKdfFyMkhIWAiMa2xlbmLkYtDSGApo8SK922MEAkZiZPT
        GlghbGGJP9e62CCK3jJKzDt6kgkkISwQLbFu20qwbhGBZiaJgy+6WEEcZoE+Zok39ycwQbTc
        ZpTY1NoPNpdNwFCi6y3ILE4OXgE7iVktc1hAbBYBVYnPf9+wg9iiAjESP/d0sUDUCEqcnPkE
        zOYUCJE4dn8dWA2zgJnEvM0PmSFseYntb+dA2eISt57MZ5rAKDQLSfssJC2zkLTMQtKygJFl
        FaNIamlxbnpusaFecWJucWleul5yfu4mRmC0bzv2c/MOxksbgw8xCnAwKvHwGlTWxwmxJpYV
        V+YeYpTgYFYS4WXzb4gT4k1JrKxKLcqPLyrNSS0+xGgK9NxEZinR5HxgIsoriTc0NTS3sDQ0
        NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cDoHpG78GBamta32yVpmw1ePtp3KpbD
        R73/wKfDTjm2GfXHc6KkJ0177yz2Qlqt9mPZ/p+yzr0xq06/Ke6vspY6ea59llbV55a9Au0M
        bTsSDW0tVx8MmxHRvaTGQU5uR9a0P0fThdV239m9ptLakVm644jJ6SW3K88qLYhefXH5BgnT
        Wvlfk72UWIozEg21mIuKEwErd8d6DAMAAA==
X-CMS-MailID: 20200329095554eucas1p2153edb2d11e85bb092aea8562a9357d5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
        <20200327162126.29705-1-m.szyprowski@samsung.com>
        <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Michael,

On 2020-03-27 19:31, Ruhl, Michael J wrote:
>> -----Original Message-----
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>> Sent: Friday, March 27, 2020 12:21 PM
>> To: dri-devel@lists.freedesktop.org; linux-samsung-soc@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>;
>> stable@vger.kernel.org; Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com>; Maarten Lankhorst
>> <maarten.lankhorst@linux.intel.com>; Maxime Ripard
>> <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>;
>> David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Alex Deucher
>> <alexander.deucher@amd.com>; Shane Francis <bigbeeshane@gmail.com>;
>> Ruhl, Michael J <michael.j.ruhl@intel.com>
>> Subject: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a
>> scatterlist
>>
>> Scatterlist elements contains both pages and DMA addresses, but one
>> should not assume 1:1 relation between them. The sg->length is the size
>> of the physical memory chunk described by the sg->page, while
>> sg_dma_len(sg) is the size of the DMA (IO virtual) chunk described by
>> the sg_dma_address(sg).
>>
>> The proper way of extracting both: pages and DMA addresses of the whole
>> buffer described by a scatterlist it to iterate independently over the
>> sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.
>>
>> Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>> ---
>> drivers/gpu/drm/drm_prime.c | 37 +++++++++++++++++++++++++-----------
>> -
>> 1 file changed, 25 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>> index 1de2cde2277c..282774e469ac 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -962,27 +962,40 @@ int drm_prime_sg_to_page_addr_arrays(struct
>> sg_table *sgt, struct page **pages,
>> 	unsigned count;
>> 	struct scatterlist *sg;
>> 	struct page *page;
>> -	u32 len, index;
>> +	u32 page_len, page_index;
>> 	dma_addr_t addr;
>> +	u32 dma_len, dma_index;
>>
>> -	index = 0;
>> +	/*
>> +	 * Scatterlist elements contains both pages and DMA addresses, but
>> +	 * one shoud not assume 1:1 relation between them. The sg->length
>> is
>> +	 * the size of the physical memory chunk described by the sg->page,
>> +	 * while sg_dma_len(sg) is the size of the DMA (IO virtual) chunk
>> +	 * described by the sg_dma_address(sg).
>> +	 */
> Is there an example of what the scatterlist would look like in this case?

DMA framework or IOMMU is allowed to join consecutive chunks while 
mapping if such operation is supported by the hw. Here is the example:

Lets assume that we have a scatterlist with 4 4KiB pages of the physical 
addresses: 0x12000000, 0x13011000, 0x13012000, 0x11011000. The total 
size of the buffer is 16KiB. After mapping this scatterlist to a device 
behind an IOMMU it may end up as a contiguous buffer in the DMA (IOVA) 
address space. at 0xf0010000. The scatterlist will look like this:

sg[0].page = 0x12000000
sg[0].len = 4096
sg[0].dma_addr = 0xf0010000
sg[0].dma_len = 16384
sg[1].page = 0x13011000
sg[1].len = 4096
sg[1].dma_addr = 0
sg[1].dma_len = 0
sg[2].page = 0x13012000
sg[2].len = 4096
sg[2].dma_addr = 0
sg[2].dma_len = 0
sg[3].page = 0x11011000
sg[3].len = 4096
sg[3].dma_addr = 0
sg[3].dma_len = 0

(I've intentionally wrote page as physical address to make it easier to 
understand, in real SGs it is stored a struct page pointer).

> Does each SG entry always have the page and dma info? or could you have
> entries that have page information only, and entries that have dma info only?
When SG is not mapped yet it contains only the ->pages and ->len 
entries. I'm not aware of the SGs with the DMA information only, but in 
theory it might be possible to have such.
> If the same entry has different size info (page_len = PAGE_SIZE,
> dma_len = 4 * PAGE_SIZE?), are we guaranteed that the arrays (page and addrs) have
> been sized correctly?

There are always no more DMA related entries than the phys pages. If 
there is 1:1 mapping between physical memory and DMA (IOVA) space, then 
each SG entry will have len == dma_len, and dma_addr will be describing 
the same as page entry. DMA mapping framework is allowed only to join 
entries while mapping to DMA (IOVA).

> Just trying to get my head wrapped around this.

Sure, I hope my explanation helps a bit.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

