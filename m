Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3573F47D0
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 11:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhHWJlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 05:41:45 -0400
Received: from foss.arm.com ([217.140.110.172]:50576 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235872AbhHWJlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 05:41:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D0A06D;
        Mon, 23 Aug 2021 02:41:02 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06D0E3F66F;
        Mon, 23 Aug 2021 02:41:00 -0700 (PDT)
Subject: Re: [PATCH 3/3] drm/panfrost: Clamp lock region to Bifrost minimum
To:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        dri-devel@lists.freedesktop.org
Cc:     Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com>
 <20210820213117.13050-4-alyssa.rosenzweig@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <818b1a15-ddf4-461b-1d6a-cea539deaf76@arm.com>
Date:   Mon, 23 Aug 2021 10:40:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210820213117.13050-4-alyssa.rosenzweig@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/08/2021 22:31, Alyssa Rosenzweig wrote:
> When locking a region, we currently clamp to a PAGE_SIZE as the minimum
> lock region. While this is valid for Midgard, it is invalid for Bifrost,

While the spec does seem to state it's invalid for Bifrost - kbase
didn't bother with a lower clamp for a long time. I actually think this
is in many ways more of a spec bug: i.e. implementation details of the
round-up that the hardware does. But it's much safer following the spec
;) And it seems like kbase eventually caught up too.

> where the minimum locking size is 8x larger than the 4k page size. Add a
> hardware definition for the minimum lock region size (corresponding to
> KBASE_LOCK_REGION_MIN_SIZE_LOG2 in kbase) and respect it.
> 
> Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> Tested-by: Chris Morgan <macromorgan@hotmail.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panfrost/panfrost_mmu.c  | 2 +-
>  drivers/gpu/drm/panfrost/panfrost_regs.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 3a795273e505..dfe5f1d29763 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -66,7 +66,7 @@ static void lock_region(struct panfrost_device *pfdev, u32 as_nr,
>  	/* The size is encoded as ceil(log2) minus(1), which may be calculated
>  	 * with fls. The size must be clamped to hardware bounds.
>  	 */
> -	size = max_t(u64, size, PAGE_SIZE);
> +	size = max_t(u64, size, AS_LOCK_REGION_MIN_SIZE);
>  	region_width = fls64(size - 1) - 1;
>  	region |= region_width;
>  
> diff --git a/drivers/gpu/drm/panfrost/panfrost_regs.h b/drivers/gpu/drm/panfrost/panfrost_regs.h
> index 1940ff86e49a..6c5a11ef1ee8 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_regs.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
> @@ -316,6 +316,8 @@
>  #define AS_FAULTSTATUS_ACCESS_TYPE_READ		(0x2 << 8)
>  #define AS_FAULTSTATUS_ACCESS_TYPE_WRITE	(0x3 << 8)
>  
> +#define AS_LOCK_REGION_MIN_SIZE                 (1ULL << 15)
> +
>  #define gpu_write(dev, reg, data) writel(data, dev->iomem + reg)
>  #define gpu_read(dev, reg) readl(dev->iomem + reg)
>  
> 

