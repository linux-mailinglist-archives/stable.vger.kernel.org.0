Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C175364436C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbiLFMuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLFMuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:50:02 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1EFDFA8
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670331001; x=1701867001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mtk+Vk1B9nutmEiwfe+JBi3cP78MkEAyABeAV91zcuk=;
  b=Kzu+G7hllZGkZi+x+Cc9CVQ7kzYNAnV/kEFyY1o/G0schd+D5jtSFi3+
   FYq/nw4vGoTfa0FPR6l2S0jHFHDa8eVgsFT/vMTfc6+T2q6aYNzh8BJwG
   utBKV0qOlTeu1wNF4KVfUOR3KnilRO3TxIk+8Y0Nn2xp0WX2G52Mrh38X
   JGEMRTd52iToOrhfxMnnmucrKKjP4tCDLnzbNSBSPODfnjNjss4ugeC7q
   wjwg9Yg2QhfNV46KyY0H4acO6Mzopsz1NfRKQKCVxLFA5V1wrWgX44rUx
   OredyFYHmF6rpbt0gAPMjLStzdsMvVXJOv8rAVGjDfn1QQXTq6Fc3cvZ4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="318475226"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="318475226"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 04:50:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="709656573"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="709656573"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.23.172]) ([10.213.23.172])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 04:49:59 -0800
Message-ID: <b7630308-167f-f654-2801-d45767c2fb92@intel.com>
Date:   Tue, 6 Dec 2022 13:49:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH v6 1/3] drm/i915/migrate: Account for the reserved_space
Content-Language: en-US
To:     Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>, stable@vger.kernel.org
References: <20221202122844.428006-1-matthew.auld@intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20221202122844.428006-1-matthew.auld@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I messed-up with versions, my prev comment landed in v2, so I put it 
here to clean things up.

On 02.12.2022 13:28, Matthew Auld wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
>
> If the ring is nearly full when calling into emit_pte(), we might
> incorrectly trample the reserved_space when constructing the packet to
> emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
> ring->space) when later submitting the request, since the request itself
> doesn't have enough space left in the ring to emit things like
> workarounds, breadcrumbs etc.
>
> v2: Fix the whitespace errors
>
> Testcase: igt@i915_selftests@live_emit_pte_full_ring
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
> Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Nirmoy Das <nirmoy.das@intel.com>
> Cc: <stable@vger.kernel.org> # v5.15+
> Tested-by: Nirmoy Das <nirmoy.das@intel.com>
> Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
> ---
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> index b405a04135ca..b783f6f740c8 100644
> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> @@ -342,6 +342,16 @@ static int emit_no_arbitration(struct i915_request *rq)
>   	return 0;
>   }
>   
> +static int max_pte_pkt_size(struct i915_request *rq, int pkt)
> +{
> +	struct intel_ring *ring = rq->ring;
> +
> +	pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
> +	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +
> +	return pkt;
> +}
> +

I guess, the assumption that subtractions of u32 values do not 
overflows, is valid.
Then I guess more natural would be use u32 for all vars involved, this 
way we can use min instead of min_t, minor nit.

Anyway:
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

>   static int emit_pte(struct i915_request *rq,
>   		    struct sgt_dma *it,
>   		    enum i915_cache_level cache_level,
> @@ -388,8 +398,7 @@ static int emit_pte(struct i915_request *rq,
>   		return PTR_ERR(cs);
>   
>   	/* Pack as many PTE updates as possible into a single MI command */
> -	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
> -	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +	pkt = max_pte_pkt_size(rq, dword_length);
>   
>   	hdr = cs;
>   	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
> @@ -422,8 +431,7 @@ static int emit_pte(struct i915_request *rq,
>   				}
>   			}
>   
> -			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
> -			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +			pkt = max_pte_pkt_size(rq, dword_rem);
>   
>   			hdr = cs;
>   			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);

