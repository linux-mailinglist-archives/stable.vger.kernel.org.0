Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15A054DBD4
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359449AbiFPHdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 03:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359278AbiFPHdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 03:33:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1AB5F7A;
        Thu, 16 Jun 2022 00:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655364809; x=1686900809;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5fosfAjzAZBHADth+UjPo9ukq2bY8/4uhcqIhxkcAbw=;
  b=Tz8KQnqtcitV72gD3CH2tNS7IN1ac6CtRKkjkj+ptxCg45E7XJednW8n
   mk+hidrXjgIKO8P+9AMDoYqXYLfq0blOaf9dLeay3HoC40G8k/BBmmF00
   cyflPW5jhWMcHI2s8uQ5A75zOR84mqFiPRvtt5wNGOhYXQkVreI/gD7hM
   Uxp6YIrKQshfvap3XDIMM5iLFn2QDx/6MbHvjAMDnTv/FE+rHB0IPUPeN
   VSFIIzByoEULTZqQQhFunp+jOmw1DtFget2aV7oojGYR2MqsxspwGDsV0
   y7rrai0iAmYMujacfrod1oau8CpuXo3eLYBlFQ2UOwJHVk1Fn/EgFnuJV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="267877773"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="267877773"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 00:33:29 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="912048023"
Received: from mstokes1-mobl.ger.corp.intel.com (HELO [10.213.198.82]) ([10.213.198.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 00:33:25 -0700
Message-ID: <7c29c710-64ee-6e87-afb4-6d6b51e26315@linux.intel.com>
Date:   Thu, 16 Jun 2022 08:33:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/6] drm/i915/gt: Only invalidate TLBs exposed to user
 manipulation
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Andi Shyti <andi.shyti@linux.intel.com>,
        stable@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
References: <cover.1655306128.git.mchehab@kernel.org>
 <387b9a8d3e719ad2db4fce56c0bfc0f909fd6df6.1655306128.git.mchehab@kernel.org>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <387b9a8d3e719ad2db4fce56c0bfc0f909fd6df6.1655306128.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/06/2022 16:27, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Don't flush TLBs when the buffer is only used in the GGTT under full
> control of the kernel, as there's no risk of of concurrent access
> and stale access from prefetch.
> 
> We only need to invalidate the TLB if they are accessible by the user.
> 
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Same question as against the other patch - fix or optimisation?

Regards,

Tvrtko

> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> 
> See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/
> 
>   drivers/gpu/drm/i915/i915_vma.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
> index 0bffb70b3c5f..7989986161e8 100644
> --- a/drivers/gpu/drm/i915/i915_vma.c
> +++ b/drivers/gpu/drm/i915/i915_vma.c
> @@ -537,7 +537,8 @@ int i915_vma_bind(struct i915_vma *vma,
>   				   bind_flags);
>   	}
>   
> -	set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
> +	if (bind_flags & I915_VMA_LOCAL_BIND)
> +		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
>   
>   	atomic_or(bind_flags, &vma->flags);
>   	return 0;
