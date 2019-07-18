Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ED26D3E3
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 20:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGRS2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 14:28:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:36364 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfGRS2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 14:28:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 11:28:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="173266114"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 18 Jul 2019 11:28:43 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 18 Jul 2019 21:28:43 +0300
Date:   Thu, 18 Jul 2019 21:28:43 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] drm/i915: Use maximum write flush for pwrite_gtt
Message-ID: <20190718182843.GG5942@intel.com>
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-2-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190718145407.21352-2-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 03:54:05PM +0100, Chris Wilson wrote:
> As recently disovered by forcing big-core (!llc) machines to use the GTT
> paths, we need our full GTT write flush before manipulating the GTT PTE
> or else the writes may be directed to the wrong page.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Matthew Auld <matthew.william.auld@gmail.com>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/i915/i915_gem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index fed0bc421a55..c6ba350e6e4f 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -610,7 +610,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
>  		unsigned int page_length = PAGE_SIZE - page_offset;
>  		page_length = remain < page_length ? remain : page_length;
>  		if (node.allocated) {
> -			wmb(); /* flush the write before we modify the GGTT */
> +			/* flush the write before we modify the GGTT */
> +			intel_gt_flush_ggtt_writes(ggtt->vm.gt);

Matches the story told by intel_gt_flush_ggtt_writes().

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  			ggtt->vm.insert_page(&ggtt->vm,
>  					     i915_gem_object_get_dma_address(obj, offset >> PAGE_SHIFT),
>  					     node.start, I915_CACHE_NONE, 0);
> @@ -639,8 +640,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
>  	i915_gem_object_unlock_fence(obj, fence);
>  out_unpin:
>  	mutex_lock(&i915->drm.struct_mutex);
> +	intel_gt_flush_ggtt_writes(ggtt->vm.gt);
>  	if (node.allocated) {
> -		wmb();
>  		ggtt->vm.clear_range(&ggtt->vm, node.start, node.size);
>  		remove_mappable_node(&node);
>  	} else {
> -- 
> 2.22.0

-- 
Ville Syrjälä
Intel
