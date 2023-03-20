Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3867A6C0DA4
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 10:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCTJqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 05:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCTJqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 05:46:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F41B313
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 02:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679305576; x=1710841576;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FBIRGd/LO9SReXFd+7N9klsBB4PTylrrWFsq2YzWaNs=;
  b=Sh+ZAgb/VnyjGR2xrfRDum9Cbjz8aXV5rWyAGRaIli3dj972KOt7PQl0
   uieD24SLqi9045OAzxUXqhNIoDqG0/SN1sFiubZPmkxUMttH47gOl+7q5
   NOYZQdzU2soAnaldL+LyIioCONTq/9Zl8d1kzN3F6O7C+AZQeA7Gjzo3y
   OdCoGxIjZfEdQMsRwx0IsfC2P1frGREHgvw1OYIcIlWvy8d25dzep7q+e
   RPDuOkYiykieOUWf532/556pl/r6bRrGh5g/oNFhXT78F6mhUXCQPMSrJ
   awjmHGGIb27I2vP0NCY5Xx1/aQxm8no/bQRfMT798VDBhqrplb4P6uFwC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="337335595"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="337335595"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:46:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="750022164"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="750022164"
Received: from vmiceli-mobl.amr.corp.intel.com (HELO [10.252.26.135]) ([10.252.26.135])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:46:15 -0700
Message-ID: <33f2aea1-8d2d-786c-2e83-368d10e8abe8@intel.com>
Date:   Mon, 20 Mar 2023 09:46:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH 1/6] drm/i915/dpt: Treat the DPT BO as a framebuffer
Content-Language: en-GB
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Imre Deak <imre.deak@intel.com>
References: <20230320090522.9909-1-ville.syrjala@linux.intel.com>
 <20230320090522.9909-2-ville.syrjala@linux.intel.com>
From:   Matthew Auld <matthew.auld@intel.com>
In-Reply-To: <20230320090522.9909-2-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/03/2023 09:05, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Currently i915_gem_object_is_framebuffer() doesn't treat the
> BO containing the framebuffer's DPT as a framebuffer itself.
> This means eg. that the shrinker can evict the DPT BO while
> leaving the actual FB BO bound, when the DPT is allocated
> from regular shmem.
> 
> That causes an immediate oops during hibernate as we
> try to rewrite the PTEs inside the already evicted
> DPT obj.
> 
> TODO: presumably this might also be the reason for the
> DPT related display faults under heavy memory pressure,
> but I'm still not sure how that would happen as the object
> should be pinned by intel_dpt_pin() while in active use by
> the display engine...

Yeah that's strange, if it's pinned then it should not be evictable. 
Also with DG2, are there any similar issues, since lmem is used for dpt 
and that can be moved to smem and swapped-out? Keeping the object pinned 
should also prevent that.

> 
> Cc: stable@vger.kernel.org
> Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Imre Deak <imre.deak@intel.com>
> Fixes: 0dc987b699ce ("drm/i915/display: Add smem fallback allocation for dpt")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>   drivers/gpu/drm/i915/display/intel_dpt.c         | 2 ++
>   drivers/gpu/drm/i915/gem/i915_gem_object.h       | 2 +-
>   drivers/gpu/drm/i915/gem/i915_gem_object_types.h | 3 +++
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dpt.c b/drivers/gpu/drm/i915/display/intel_dpt.c
> index ad1a37b515fb..2a9f40a2b3ed 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpt.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpt.c
> @@ -301,6 +301,7 @@ intel_dpt_create(struct intel_framebuffer *fb)
>   	vm->pte_encode = gen8_ggtt_pte_encode;
>   
>   	dpt->obj = dpt_obj;
> +	dpt->obj->is_dpt = true;
>   
>   	return &dpt->vm;
>   }
> @@ -309,5 +310,6 @@ void intel_dpt_destroy(struct i915_address_space *vm)
>   {
>   	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
>   
> +	dpt->obj->is_dpt = false;
>   	i915_vm_put(&dpt->vm);
>   }
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> index f9a8acbba715..885ccde9dc3c 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
> @@ -303,7 +303,7 @@ i915_gem_object_never_mmap(const struct drm_i915_gem_object *obj)
>   static inline bool
>   i915_gem_object_is_framebuffer(const struct drm_i915_gem_object *obj)
>   {
> -	return READ_ONCE(obj->frontbuffer);
> +	return READ_ONCE(obj->frontbuffer) || obj->is_dpt;
>   }
>   
>   static inline unsigned int
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> index 19c9bdd8f905..5dcbbef31d44 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> @@ -491,6 +491,9 @@ struct drm_i915_gem_object {
>   	 */
>   	unsigned int cache_dirty:1;
>   
> +	/* @is_dpt: Object houses a display page table (DPT) */
> +	unsigned int is_dpt:1;
> +
>   	/**
>   	 * @read_domains: Read memory domains.
>   	 *
