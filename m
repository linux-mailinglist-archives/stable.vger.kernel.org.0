Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FCB197C81
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgC3NKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:10:18 -0400
Received: from foss.arm.com ([217.140.110.172]:53246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgC3NKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:10:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FF9A30E;
        Mon, 30 Mar 2020 06:10:17 -0700 (PDT)
Received: from [10.57.60.204] (unknown [10.57.60.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96CE83F71E;
        Mon, 30 Mar 2020 06:10:15 -0700 (PDT)
Subject: Re: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a
 scatterlist
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Airlie <airlied@linux.ie>,
        Shane Francis <bigbeeshane@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
References: <CGME20200327162330eucas1p1b0413e0e9887aa76d3048f86d2166dcd@eucas1p1.samsung.com>
 <20200327162126.29705-1-m.szyprowski@samsung.com>
 <14063C7AD467DE4B82DEDB5C278E8663FFFBFCE1@fmsmsx107.amr.corp.intel.com>
 <8a09916d-5413-f9a8-bafa-2d8f0b8f892f@samsung.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <95fe655b-e68e-bea4-e8ea-3c4abc3021e7@arm.com>
Date:   Mon, 30 Mar 2020 14:10:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <8a09916d-5413-f9a8-bafa-2d8f0b8f892f@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-03-29 10:55 am, Marek Szyprowski wrote:
> Hi Michael,
> 
> On 2020-03-27 19:31, Ruhl, Michael J wrote:
>>> -----Original Message-----
>>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Sent: Friday, March 27, 2020 12:21 PM
>>> To: dri-devel@lists.freedesktop.org; linux-samsung-soc@vger.kernel.org;
>>> linux-kernel@vger.kernel.org
>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>;
>>> stable@vger.kernel.org; Bartlomiej Zolnierkiewicz
>>> <b.zolnierkie@samsung.com>; Maarten Lankhorst
>>> <maarten.lankhorst@linux.intel.com>; Maxime Ripard
>>> <mripard@kernel.org>; Thomas Zimmermann <tzimmermann@suse.de>;
>>> David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Alex Deucher
>>> <alexander.deucher@amd.com>; Shane Francis <bigbeeshane@gmail.com>;
>>> Ruhl, Michael J <michael.j.ruhl@intel.com>
>>> Subject: [PATCH v2] drm/prime: fix extracting of the DMA addresses from a
>>> scatterlist
>>>
>>> Scatterlist elements contains both pages and DMA addresses, but one
>>> should not assume 1:1 relation between them. The sg->length is the size
>>> of the physical memory chunk described by the sg->page, while
>>> sg_dma_len(sg) is the size of the DMA (IO virtual) chunk described by
>>> the sg_dma_address(sg).
>>>
>>> The proper way of extracting both: pages and DMA addresses of the whole
>>> buffer described by a scatterlist it to iterate independently over the
>>> sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.
>>>
>>> Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>>> ---
>>> drivers/gpu/drm/drm_prime.c | 37 +++++++++++++++++++++++++-----------
>>> -
>>> 1 file changed, 25 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>>> index 1de2cde2277c..282774e469ac 100644
>>> --- a/drivers/gpu/drm/drm_prime.c
>>> +++ b/drivers/gpu/drm/drm_prime.c
>>> @@ -962,27 +962,40 @@ int drm_prime_sg_to_page_addr_arrays(struct
>>> sg_table *sgt, struct page **pages,
>>> 	unsigned count;
>>> 	struct scatterlist *sg;
>>> 	struct page *page;
>>> -	u32 len, index;
>>> +	u32 page_len, page_index;
>>> 	dma_addr_t addr;
>>> +	u32 dma_len, dma_index;
>>>
>>> -	index = 0;
>>> +	/*
>>> +	 * Scatterlist elements contains both pages and DMA addresses, but
>>> +	 * one shoud not assume 1:1 relation between them. The sg->length
>>> is
>>> +	 * the size of the physical memory chunk described by the sg->page,
>>> +	 * while sg_dma_len(sg) is the size of the DMA (IO virtual) chunk
>>> +	 * described by the sg_dma_address(sg).
>>> +	 */
>> Is there an example of what the scatterlist would look like in this case?
> 
> DMA framework or IOMMU is allowed to join consecutive chunks while
> mapping if such operation is supported by the hw. Here is the example:
> 
> Lets assume that we have a scatterlist with 4 4KiB pages of the physical
> addresses: 0x12000000, 0x13011000, 0x13012000, 0x11011000. The total
> size of the buffer is 16KiB. After mapping this scatterlist to a device
> behind an IOMMU it may end up as a contiguous buffer in the DMA (IOVA)
> address space. at 0xf0010000. The scatterlist will look like this:
> 
> sg[0].page = 0x12000000
> sg[0].len = 4096
> sg[0].dma_addr = 0xf0010000
> sg[0].dma_len = 16384
> sg[1].page = 0x13011000
> sg[1].len = 4096
> sg[1].dma_addr = 0
> sg[1].dma_len = 0
> sg[2].page = 0x13012000
> sg[2].len = 4096
> sg[2].dma_addr = 0
> sg[2].dma_len = 0
> sg[3].page = 0x11011000
> sg[3].len = 4096
> sg[3].dma_addr = 0
> sg[3].dma_len = 0
> 
> (I've intentionally wrote page as physical address to make it easier to
> understand, in real SGs it is stored a struct page pointer).
> 
>> Does each SG entry always have the page and dma info? or could you have
>> entries that have page information only, and entries that have dma info only?
> When SG is not mapped yet it contains only the ->pages and ->len
> entries. I'm not aware of the SGs with the DMA information only, but in
> theory it might be possible to have such.
>> If the same entry has different size info (page_len = PAGE_SIZE,
>> dma_len = 4 * PAGE_SIZE?), are we guaranteed that the arrays (page and addrs) have
>> been sized correctly?
> 
> There are always no more DMA related entries than the phys pages. If
> there is 1:1 mapping between physical memory and DMA (IOVA) space, then
> each SG entry will have len == dma_len, and dma_addr will be describing
> the same as page entry. DMA mapping framework is allowed only to join
> entries while mapping to DMA (IOVA).

Nit: even in a 1:1 mapping, merging would still be permitted (subject to 
dma_parms constraints) during a bounce-buffer copy, or if the caller 
simply generates a naive list like so:

sg[0].page = 0x12000000
sg[0].len = 4096
sg[1].page = 0x12001000
sg[1].len = 4096

dma_map_sg() =>

sg[0].dma_addr = 0x12000000
sg[0].dma_len = 8192
sg[1].dma_addr = 0
sg[1].dma_len = 0

I'm not sure that any non-IOMMU DMA API implementations actually take 
advantage of this, but they are *allowed* to ;)

Robin.
