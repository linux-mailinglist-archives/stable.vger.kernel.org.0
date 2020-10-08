Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC7287232
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgJHKE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:04:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:62836 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgJHKE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 06:04:27 -0400
IronPort-SDR: 41gpR9zMF393ZaDyI56SHn/o4B/aTonh0X33y9rNCe4ZPT5GMFBnwEzBs6dOyOm5gEN2TXnJnd
 XWp02B+EHVJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="153144527"
X-IronPort-AV: E=Sophos;i="5.77,350,1596524400"; 
   d="scan'208";a="153144527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 03:04:25 -0700
IronPort-SDR: K6kEe61jF/WG5LoWDXK+FL6IhJ8K2tA71+f1oT8MLcCLDQWEi15JIqX146QWBAyrBbaPuOR4BA
 bjQUJeFvmwPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,350,1596524400"; 
   d="scan'208";a="316635788"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 08 Oct 2020 03:04:22 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 08 Oct 2020 13:04:22 +0300
Date:   Thu, 8 Oct 2020 13:04:22 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: Exclude low pages (128KiB) of
 stolen from use
Message-ID: <20201008100422.GI6112@intel.com>
References: <20201008095436.27743-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201008095436.27743-1-chris@chris-wilson.co.uk>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 10:54:36AM +0100, Chris Wilson wrote:
> The GPU is trashing the low pages of its reserved memory upon reset. If
> we are using this memory for ringbuffers, then we will dutiful resubmit
> the trashed rings after the reset causing further resets, and worse. We
> must exclude this range from our own use. The value of 128KiB was found
> by empirical measurement on gen9.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org
> ---
> v2 comes with a selftest to see how widespread the issue is

Do we need something to make sure FBC isn't scribbling into
stolen during the test?

> ---
>  drivers/gpu/drm/i915/Kconfig.debug         |   1 +
>  drivers/gpu/drm/i915/gem/i915_gem_stolen.c |   5 +-
>  drivers/gpu/drm/i915/gt/selftest_reset.c   | 141 +++++++++++++++++++++
>  3 files changed, 145 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig.debug b/drivers/gpu/drm/i915/Kconfig.debug
> index 206882e154bc..0fb7fd0ef717 100644
> --- a/drivers/gpu/drm/i915/Kconfig.debug
> +++ b/drivers/gpu/drm/i915/Kconfig.debug
> @@ -162,6 +162,7 @@ config DRM_I915_SELFTEST
>  	select DRM_EXPORT_FOR_TESTS if m
>  	select FAULT_INJECTION
>  	select PRIME_NUMBERS
> +	select CRC32
>  	help
>  	  Choose this option to allow the driver to perform selftests upon
>  	  loading; also requires the i915.selftest=1 module parameter. To
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
> index 0be5e8683337..c0cc2a972a11 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_stolen.c
> @@ -53,8 +53,9 @@ int i915_gem_stolen_insert_node(struct drm_i915_private *i915,
>  				struct drm_mm_node *node, u64 size,
>  				unsigned alignment)
>  {
> -	return i915_gem_stolen_insert_node_in_range(i915, node, size,
> -						    alignment, 0, U64_MAX);
> +	return i915_gem_stolen_insert_node_in_range(i915, node,
> +						    size, alignment,
> +						    SZ_128K, U64_MAX);
>  }
>  
>  void i915_gem_stolen_remove_node(struct drm_i915_private *i915,
> diff --git a/drivers/gpu/drm/i915/gt/selftest_reset.c b/drivers/gpu/drm/i915/gt/selftest_reset.c
> index 35406ecdf0b2..f73f132e57c4 100644
> --- a/drivers/gpu/drm/i915/gt/selftest_reset.c
> +++ b/drivers/gpu/drm/i915/gt/selftest_reset.c
> @@ -3,9 +3,149 @@
>   * Copyright © 2018 Intel Corporation
>   */
>  
> +#include <linux/crc32.h>
> +
> +#include "i915_memcpy.h"
>  #include "i915_selftest.h"
>  #include "selftests/igt_reset.h"
>  #include "selftests/igt_atomic.h"
> +#include "selftests/igt_spinner.h"
> +
> +static int igt_reset_stolen(void *arg)
> +{
> +	struct intel_gt *gt = arg;
> +	struct i915_ggtt *ggtt = &gt->i915->ggtt;
> +	struct resource *dsm = &gt->i915->dsm;
> +	resource_size_t num_pages, page, max, count;
> +	struct intel_engine_cs *engine;
> +	intel_wakeref_t wakeref;
> +	enum intel_engine_id id;
> +	struct igt_spinner spin;
> +	u32 seed, *crc;
> +	void *tmp;
> +	int err;
> +
> +	if (!drm_mm_node_allocated(&ggtt->error_capture))
> +		return 0;
> +
> +	num_pages = resource_size(dsm) >> PAGE_SHIFT;
> +	if (!num_pages)
> +		return 0;
> +
> +	crc = kmalloc_array(num_pages, sizeof(u32), GFP_KERNEL);
> +	if (!crc)
> +		return -ENOMEM;
> +
> +	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!tmp) {
> +		err = -ENOMEM;
> +		goto err_crc;
> +	}
> +
> +	igt_global_reset_lock(gt);
> +	wakeref = intel_runtime_pm_get(gt->uncore->rpm);
> +
> +	err = igt_spinner_init(&spin, gt);
> +	if (err)
> +		goto err_lock;
> +
> +	for_each_engine(engine, gt, id) {
> +		struct i915_request *rq;
> +
> +		intel_engine_pm_get(engine);
> +
> +		rq = igt_spinner_create_request(&spin,
> +						engine->kernel_context,
> +						MI_ARB_CHECK);
> +		i915_request_add(rq);
> +
> +		intel_engine_pm_put(engine);
> +	}
> +
> +	seed = 0;
> +	for (page = 0; page < num_pages; page++) {
> +		dma_addr_t dma;
> +		void __iomem *s;
> +		void *in;
> +
> +		dma = (dma_addr_t)dsm->start + (page << PAGE_SHIFT);
> +
> +		ggtt->vm.insert_page(&ggtt->vm, dma,
> +				     ggtt->error_capture.start,
> +				     I915_CACHE_NONE, 0);
> +		mb();
> +
> +		s = io_mapping_map_wc(&ggtt->iomap,
> +				      ggtt->error_capture.start,
> +				      PAGE_SIZE);
> +
> +		in = s;
> +		if (i915_memcpy_from_wc(tmp, s, PAGE_SIZE))
> +			in = tmp;
> +		seed = crc32_le(seed, in, PAGE_SIZE);
> +
> +		io_mapping_unmap(s);
> +
> +		crc[page] = seed;
> +	}
> +	mb();
> +	ggtt->vm.clear_range(&ggtt->vm, ggtt->error_capture.start, PAGE_SIZE);
> +
> +	intel_gt_reset(gt, ALL_ENGINES, NULL);
> +
> +	max = 0;
> +	seed = 0;
> +	count = 0;
> +	for (page = 0; page < num_pages; page++) {
> +		dma_addr_t dma;
> +		void __iomem *s;
> +		void *in;
> +
> +		dma = (dma_addr_t)dsm->start + (page << PAGE_SHIFT);
> +
> +		ggtt->vm.insert_page(&ggtt->vm, dma,
> +				     ggtt->error_capture.start,
> +				     I915_CACHE_NONE, 0);
> +		mb();
> +
> +		s = io_mapping_map_wc(&ggtt->iomap,
> +				      ggtt->error_capture.start,
> +				      PAGE_SIZE);
> +
> +		in = s;
> +		if (i915_memcpy_from_wc(tmp, s, PAGE_SIZE))
> +			in = tmp;
> +		seed = crc32_le(seed, in, PAGE_SIZE);
> +
> +		io_mapping_unmap(s);
> +
> +		if (seed != crc[page]) {
> +			pr_info("stolen page %pa modified by GPU reset\n",
> +				&page);
> +			seed = crc[page];
> +			max = page;
> +			count++;
> +		}
> +	}
> +	mb();
> +	ggtt->vm.clear_range(&ggtt->vm, ggtt->error_capture.start, PAGE_SIZE);
> +
> +	if (count > 0) {
> +		pr_err("Reset clobbered %pa pages of stolen, last clobber at page %pa\n", &count, &max);
> +		err = -EINVAL;
> +	}
> +
> +	igt_spinner_fini(&spin);
> +
> +err_lock:
> +	intel_runtime_pm_put(gt->uncore->rpm, wakeref);
> +	igt_global_reset_unlock(gt);
> +
> +	kfree(tmp);
> +err_crc:
> +	kfree(crc);
> +	return err;
> +}
>  
>  static int igt_global_reset(void *arg)
>  {
> @@ -164,6 +304,7 @@ int intel_reset_live_selftests(struct drm_i915_private *i915)
>  {
>  	static const struct i915_subtest tests[] = {
>  		SUBTEST(igt_global_reset), /* attempt to recover GPU first */
> +		SUBTEST(igt_reset_stolen),
>  		SUBTEST(igt_wedged_reset),
>  		SUBTEST(igt_atomic_reset),
>  		SUBTEST(igt_atomic_engine_reset),
> -- 
> 2.20.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
