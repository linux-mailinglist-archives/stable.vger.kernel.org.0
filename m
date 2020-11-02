Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16142A2FF2
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKBQij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:38:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:53356 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgKBQii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 11:38:38 -0500
IronPort-SDR: 0WSw0tzBsbVTTCqfJISSk8rAdmMH+DNmFV+8fAkg3FQb5YRPWDPFEzKle7dadyeBw3Grl8k0E8
 Gv0AdUSGzOrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155900158"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="155900158"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 08:38:38 -0800
IronPort-SDR: wT3sLkv+9h5Fnt986mMZt3G2YRn3BEkl7TSy5FWLz/iYz/smP1TdiVkjgKWw3WE+PawCEmRvs6
 Vo9bfDD2T+jg==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="538084323"
Received: from obarniv1-mobl.ger.corp.intel.com (HELO [10.214.212.214]) ([10.214.212.214])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 08:38:36 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold onto an explicit ref to
 i915_vma_work.pinned
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20201102161931.30031-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <788e4993-4b61-dd7f-cd02-6c628daf894c@linux.intel.com>
Date:   Mon, 2 Nov 2020 16:38:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201102161931.30031-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/11/2020 16:19, Chris Wilson wrote:
> Since __vma_release is run by a kworker after the fence has been
> signaled, it is no longer protected by the active reference on the vma,
> and so the alias of vw->pinned to vma->obj is also not protected by a
> reference on the object. Add an explicit reference for vw->pinned so it
> will always be safe.
> 
> Found by inspection.
> 
> Fixes: 54d7195f8c64 ("drm/i915: Unpin vma->obj on early error")
> Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>   drivers/gpu/drm/i915/i915_vma.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
> index ffb5287e055a..caa9b041616b 100644
> --- a/drivers/gpu/drm/i915/i915_vma.c
> +++ b/drivers/gpu/drm/i915/i915_vma.c
> @@ -314,8 +314,10 @@ static void __vma_release(struct dma_fence_work *work)
>   {
>   	struct i915_vma_work *vw = container_of(work, typeof(*vw), base);
>   
> -	if (vw->pinned)
> +	if (vw->pinned) {
>   		__i915_gem_object_unpin_pages(vw->pinned);
> +		i915_gem_object_put(vw->pinned);
> +	}
>   
>   	i915_vm_free_pt_stash(vw->vm, &vw->stash);
>   	i915_vm_put(vw->vm);
> @@ -431,7 +433,7 @@ int i915_vma_bind(struct i915_vma *vma,
>   
>   		if (vma->obj) {
>   			__i915_gem_object_pin_pages(vma->obj);
> -			work->pinned = vma->obj;
> +			work->pinned = i915_gem_object_get(vma->obj);
>   		}
>   	} else {
>   		vma->ops->bind_vma(vma->vm, NULL, vma, cache_level, bind_flags);
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
