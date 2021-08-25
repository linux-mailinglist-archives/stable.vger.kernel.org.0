Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED9A3F7163
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 11:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhHYJEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 05:04:52 -0400
Received: from foss.arm.com ([217.140.110.172]:46236 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhHYJEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 05:04:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDFB131B;
        Wed, 25 Aug 2021 02:04:05 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 802A73F66F;
        Wed, 25 Aug 2021 02:04:04 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] drm/panfrost: Simplify lock_region calculation
To:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        dri-devel@lists.freedesktop.org
Cc:     Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
References: <20210824173028.7528-1-alyssa.rosenzweig@collabora.com>
 <20210824173028.7528-2-alyssa.rosenzweig@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <698bbb98-5fd8-d6cd-b8cd-0ff29573314c@arm.com>
Date:   Wed, 25 Aug 2021 10:03:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824173028.7528-2-alyssa.rosenzweig@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/08/2021 18:30, Alyssa Rosenzweig wrote:
> In lock_region, simplify the calculation of the region_width parameter.
> This field is the size, but encoded as ceil(log2(size)) - 1.
> ceil(log2(size)) may be computed directly as fls(size - 1). However, we
> want to use the 64-bit versions as the amount to lock can exceed
> 32-bits.
> 
> This avoids undefined (and completely wrong) behaviour when locking all
> memory (size ~0). In this case, the old code would "round up" ~0 to the
> nearest page, overflowing to 0. Since fls(0) == 0, this would calculate
> a region width of 10 + 0 = 10. But then the code would shift by
> (region_width - 11) = -1. As shifting by a negative number is undefined,
> UBSAN flags the bug. Of course, even if it were defined the behaviour is
> wrong, instead of locking all memory almost none would get locked.
> 
> The new form of the calculation corrects this special case and avoids
> the undefined behaviour.
> 
> Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> Reported-and-tested-by: Chris Morgan <macromorgan@hotmail.com>
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panfrost/panfrost_mmu.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 0da5b3100ab1..f6e02d0392f4 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -62,21 +62,12 @@ static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
>  {
>  	u8 region_width;
>  	u64 region = iova & PAGE_MASK;
> -	/*
> -	 * fls returns:
> -	 * 1 .. 32
> -	 *
> -	 * 10 + fls(num_pages)
> -	 * results in the range (11 .. 42)
> -	 */
> -
> -	size = round_up(size, PAGE_SIZE);
>  
> -	region_width = 10 + fls(size >> PAGE_SHIFT);
> -	if ((size >> PAGE_SHIFT) != (1ul << (region_width - 11))) {
> -		/* not pow2, so must go up to the next pow2 */
> -		region_width += 1;
> -	}
> +	/* The size is encoded as ceil(log2) minus(1), which may be calculated
> +	 * with fls. The size must be clamped to hardware bounds.
> +	 */
> +	size = max_t(u64, size, PAGE_SIZE);
> +	region_width = fls64(size - 1) - 1;
>  	region |= region_width;
>  
>  	/* Lock the region that needs to be updated */
> 

