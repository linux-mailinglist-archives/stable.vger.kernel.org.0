Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A661411AC46
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbfLKNlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 08:41:08 -0500
Received: from foss.arm.com ([217.140.110.172]:58606 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbfLKNlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 08:41:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 089E01FB;
        Wed, 11 Dec 2019 05:41:07 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 142BA3F6CF;
        Wed, 11 Dec 2019 05:41:02 -0800 (PST)
Subject: Re: [PATCH] ARM: dma-api: fix max_pfn off-by-one error in
 __dma_supported()
To:     Chen-Yu Tsai <wens@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191211104152.26496-1-wens@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <28dfaeab-73cd-041b-9894-776064d13245@arm.com>
Date:   Wed, 11 Dec 2019 13:40:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211104152.26496-1-wens@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/12/2019 10:41 am, Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> max_pfn, as set in arch/arm/mm/init.c:
> 
>      static void __init find_limits(unsigned long *min,
> 				   unsigned long *max_low,
> 				   unsigned long *max_high)
>      {
> 	    *max_low = PFN_DOWN(memblock_get_current_limit());
> 	    *min = PFN_UP(memblock_start_of_DRAM());
> 	    *max_high = PFN_DOWN(memblock_end_of_DRAM());
>      }
> 
> with memblock_end_of_DRAM() pointing to the next byte after DRAM. As
> such, max_pfn points to the PFN after the end of DRAM.
> 
> Thus when using max_pfn to check DMA masks, we should subtract one
> when checking DMA ranges against it.
> 
> Commit 8bf1268f48ad ("ARM: dma-api: fix off-by-one error in
> __dma_supported()") fixed the same issue, but missed this spot.
> 
> This issue was found while working on the sun4i-csi v4l2 driver on the
> Allwinner R40 SoC. On Allwinner SoCs, DRAM is offset at 0x40000000,
> and we are starting to use of_dma_configure() with the "dma-ranges"
> property in the device tree to have the DMA API handle the offset.
> 
> In this particular instance, dma-ranges was set to the same range as
> the actual available (2 GiB) DRAM. The following error appeared when
> the driver attempted to allocate a buffer:
> 
>      sun4i-csi 1c09000.csi: Coherent DMA mask 0x7fffffff (pfn 0x40000-0xc0000)
>      covers a smaller range of system memory than the DMA zone pfn 0x0-0xc0001
>      sun4i-csi 1c09000.csi: dma_alloc_coherent of size 307200 failed
> 
> Fixing the off-by-one error makes things work.
> 
> Fixes: 11a5aa32562e ("ARM: dma-mapping: check DMA mask against available memory")
> Fixes: 9f28cde0bc64 ("ARM: another fix for the DMA mapping checks")
> Fixes: ab746573c405 ("ARM: dma-mapping: allow larger DMA mask than supported")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>   arch/arm/mm/dma-mapping.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index e822af0d9219..f4daafdbac56 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -227,12 +227,12 @@ static int __dma_supported(struct device *dev, u64 mask, bool warn)
>   	 * Translate the device's DMA mask to a PFN limit.  This
>   	 * PFN number includes the page which we can DMA to.
>   	 */
> -	if (dma_to_pfn(dev, mask) < max_dma_pfn) {
> +	if (dma_to_pfn(dev, mask) < max_dma_pfn - 1) {

I think this correction actually wants to happen a couple of lines up in 
the definition:

	unsigned long max_dma_pfn = min(max_pfn, arm_dma_pfn_limit);

max_pfn is indeed an exclusive limit, but AFAICS arm_dma_pfn_limit is 
inclusive, so none of these "+1"s and "-1"s can be entirely right for 
both cases.

Robin.

>   		if (warn)
>   			dev_warn(dev, "Coherent DMA mask %#llx (pfn %#lx-%#lx) covers a smaller range of system memory than the DMA zone pfn 0x0-%#lx\n",
>   				 mask,
>   				 dma_to_pfn(dev, 0), dma_to_pfn(dev, mask) + 1,
> -				 max_dma_pfn + 1);
> +				 max_dma_pfn);
>   		return 0;
>   	}
>   
> 
