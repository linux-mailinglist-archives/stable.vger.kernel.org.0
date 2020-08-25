Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC20B250FE2
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 05:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgHYDTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 23:19:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:27238 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgHYDTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 23:19:01 -0400
IronPort-SDR: it/ebiSq6isHv/T9++5Be13HfsqHY4+WtVkvvzgcv91FsFNGvyk2LZLQliwhyevTswuiKo6hAX
 1nYp7a0QzJOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="240850053"
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="240850053"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 20:18:59 -0700
IronPort-SDR: /QQMVKdVSaKxgnc2FhLKHODbI95P99e0htrtIEtX0rYLu784bzeG0YZ2Uy7MRBuJMq1MsMeW2u
 gqCAEPXk6YHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="322591122"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2020 20:18:59 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH] iommu/intel: Handle 36b addressing for x86-32
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        iommu@lists.linux-foundation.org
Cc:     baolu.lu@linux.intel.com, intel-gfx@lists.freedesktop.org,
        James Sewart <jamessewart@arista.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
References: <20200822160209.28512-1-chris@chris-wilson.co.uk>
Message-ID: <98c34926-6085-81f2-dce2-53ef1ce1edc8@linux.intel.com>
Date:   Tue, 25 Aug 2020 11:13:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200822160209.28512-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chris,

On 2020/8/23 0:02, Chris Wilson wrote:
> Beware that the address size for x86-32 may exceed unsigned long.
> 
> [    0.368971] UBSAN: shift-out-of-bounds in drivers/iommu/intel/iommu.c:128:14
> [    0.369055] shift exponent 36 is too large for 32-bit type 'long unsigned int'
> 
> If we don't handle the wide addresses, the pages are mismapped and the
> device read/writes go astray, detected as DMAR faults and leading to
> device failure. The behaviour changed (from working to broken) in commit
> fa954e683178 ("iommu/vt-d: Delegate the dma domain to upper layer"), but
commit <fa954e683178> ("iommu/vt-d: Delegate the dma domain to upper layer")

and adjust the title as "iommu/vt-d: Handle 36bit addressing for x86-32"

with above two changes,

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> the error looks older.
> 
> Fixes: fa954e683178 ("iommu/vt-d: Delegate the dma domain to upper layer")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: James Sewart <jamessewart@arista.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: <stable@vger.kernel.org> # v5.3+
> ---
>   drivers/iommu/intel/iommu.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 2e9c8c3d0da4..ba78a2e854f9 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -123,29 +123,29 @@ static inline unsigned int level_to_offset_bits(int level)
>   	return (level - 1) * LEVEL_STRIDE;
>   }
>   
> -static inline int pfn_level_offset(unsigned long pfn, int level)
> +static inline int pfn_level_offset(u64 pfn, int level)
>   {
>   	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
>   }
>   
> -static inline unsigned long level_mask(int level)
> +static inline u64 level_mask(int level)
>   {
> -	return -1UL << level_to_offset_bits(level);
> +	return -1ULL << level_to_offset_bits(level);
>   }
>   
> -static inline unsigned long level_size(int level)
> +static inline u64 level_size(int level)
>   {
> -	return 1UL << level_to_offset_bits(level);
> +	return 1ULL << level_to_offset_bits(level);
>   }
>   
> -static inline unsigned long align_to_level(unsigned long pfn, int level)
> +static inline u64 align_to_level(u64 pfn, int level)
>   {
>   	return (pfn + level_size(level) - 1) & level_mask(level);
>   }
>   
>   static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
>   {
> -	return  1 << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
> +	return 1UL << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
>   }
>   
>   /* VT-d pages must always be _smaller_ than MM pages. Otherwise things
> 
