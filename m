Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AFD7E3FB
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 22:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbfHAURp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 16:17:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:17256 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbfHAURp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 16:17:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:17:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="175363567"
Received: from pkumarva-server.ra.intel.com (HELO intel.com) ([10.23.184.130])
  by orsmga003.jf.intel.com with ESMTP; 01 Aug 2019 13:17:44 -0700
Date:   Thu, 1 Aug 2019 16:33:44 -0400
From:   "Kumar Valsan, Prathap" <prathap.kumar.valsan@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 3/3] drm/i915: Flush extra hard after writing
 relocations through the GTT
Message-ID: <20190801203344.GY3842@intel.com>
References: <20190730112151.5633-1-chris@chris-wilson.co.uk>
 <20190730112151.5633-4-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730112151.5633-4-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 12:21:51PM +0100, Chris Wilson wrote:
> Recently discovered in commit bdae33b8b82b ("drm/i915: Use maximum write
> flush for pwrite_gtt") was that we needed to our full write barrier
> before changing the GGTT PTE to ensure that our indirect writes through
> the GTT landed before the PTE changed (and the writes end up in a
> different page). That also applies to our GGTT relocation path.

Chris,

As i understand, changing the GGTT PTE also an indirect write. If so, isn't a wmb()
should be good enough.

Thanks,
Prathap
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> index 8a2047c4e7c3..01901dad33f7 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -1019,11 +1019,12 @@ static void reloc_cache_reset(struct reloc_cache *cache)
>  		kunmap_atomic(vaddr);
>  		i915_gem_object_finish_access((struct drm_i915_gem_object *)cache->node.mm);
>  	} else {
> -		wmb();
> +		struct i915_ggtt *ggtt = cache_to_ggtt(cache);
> +
> +		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
>  		io_mapping_unmap_atomic((void __iomem *)vaddr);
> -		if (cache->node.allocated) {
> -			struct i915_ggtt *ggtt = cache_to_ggtt(cache);
>  
> +		if (cache->node.allocated) {
>  			ggtt->vm.clear_range(&ggtt->vm,
>  					     cache->node.start,
>  					     cache->node.size);
> @@ -1078,6 +1079,7 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
>  	void *vaddr;
>  
>  	if (cache->vaddr) {
> +		intel_gt_flush_ggtt_writes(ggtt->vm.gt);
>  		io_mapping_unmap_atomic((void __force __iomem *) unmask_page(cache->vaddr));
>  	} else {
>  		struct i915_vma *vma;
> @@ -1119,7 +1121,6 @@ static void *reloc_iomap(struct drm_i915_gem_object *obj,
>  
>  	offset = cache->node.start;
>  	if (cache->node.allocated) {
> -		wmb();
>  		ggtt->vm.insert_page(&ggtt->vm,
>  				     i915_gem_object_get_dma_address(obj, page),
>  				     offset, I915_CACHE_NONE, 0);
> -- 
> 2.22.0
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
