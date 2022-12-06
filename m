Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4C644364
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLFMqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFMqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:46:21 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D89E8
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670330777; x=1701866777;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wA27S/oqwnQlYlMg+dXYFKrlC5AywmwWCl5dqeP+tkM=;
  b=Ugijgpb70W6KlPh11FBB8D3v02Vb47MZMlefXv+yrRW3C6xiZH9qMVuo
   1xO6DgBLoLzpYnqMb8//kcDJbE0OBBkI1AQ7K8ZW7UMdyn2CLtNYsh/Mj
   FJ8dQvoeSYDYO9bj54TIGPell0mVvaLQtNsmPeAZgVYPbBwdYlTrZ8BrY
   c7HlKA+fvvm3iqVGiiV9tbj6MVQMmu+0gZNa7dlRY+H7Hu5mnexrbixnL
   M27Fxfqe/6/0qEW48joeHoQxcGhPeK0Ib47F7BguYmf6hXIawd70SB5Hh
   tZPhaiUe4Y8awzIlExVW7V6Wxp56y0Mf2f79KYEidLRpjG/dJyFgsAemX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="315324607"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="315324607"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 04:46:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="820568935"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="820568935"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.23.172]) ([10.213.23.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 04:46:15 -0800
Message-ID: <453dda8d-ffba-9352-df99-74b7bcc6a860@intel.com>
Date:   Tue, 6 Dec 2022 13:46:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [Intel-gfx] [PATCH v2 1/2] drm/i915/migrate: Account for the
 reserved_space
To:     Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris.p.wilson@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>
References: <20221118135723.621653-1-matthew.auld@intel.com>
Content-Language: en-US
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20221118135723.621653-1-matthew.auld@intel.com>
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

On 18.11.2022 14:57, Matthew Auld wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> If the ring is nearly full when calling into emit_pte(), we might
> incorrectly trample the reserved_space when constructing the packet to
> emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
> ring->space) when later submitting the request, since the request itself
> doesn't have enough space left in the ring to emit things like
> workarounds, breadcrumbs etc.
> 
> Testcase: igt@i915_selftests@live_emit_pte_full_ring
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
> Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Nirmoy Das <nirmoy.das@intel.com>
> Cc: <stable@vger.kernel.org> # v5.15+
> ---
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> index b405a04135ca..48c3b5168558 100644
> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> @@ -342,6 +342,16 @@ static int emit_no_arbitration(struct i915_request *rq)
>   	return 0;
>   }
>   
> +static int max_pte_pkt_size(struct i915_request *rq, int pkt)
> +{
> +       struct intel_ring *ring = rq->ring;
> +
> +       pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
> +       pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
> +
> +       return pkt;
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

