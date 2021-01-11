Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C589C2F1D12
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389851AbhAKRsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:48:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:53976 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbhAKRsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:48:52 -0500
IronPort-SDR: gLxYhrOCCuR/bnM5HIuShpVSuvRvpVFH0/OnzQeAT3JqqWOlNOq705DeJtDvlIA0aKIKfWQZol
 HEv0PLsNvwlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="175327800"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="175327800"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:48:12 -0800
IronPort-SDR: aLTQ3bcD8OFn5oHqkfBPAxmkBDJclTpnGPYe5Q4jXf7KpSjMUO5/c3LB3n9V9VJMPKoquyolCt
 EiYnuegNlq8A==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="363212210"
Received: from jaksamit-mobl.amr.corp.intel.com (HELO intel.com) ([10.212.178.167])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 09:48:11 -0800
Date:   Mon, 11 Jan 2021 12:48:09 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 03/11] drm/i915: Allow the sysadmin to
 override security mitigations
Message-ID: <20210111174809.GC3689@intel.com>
References: <20210110150404.19535-1-chris@chris-wilson.co.uk>
 <20210110150404.19535-3-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210110150404.19535-3-chris@chris-wilson.co.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 03:03:56PM +0000, Chris Wilson wrote:
> The clear-residuals mitigation is a relatively heavy hammer and under some
> circumstances the user may wish to forgo the context isolation in order
> to meet some performance requirement. Introduce a generic module
> parameter to allow selectively enabling/disabling different mitigations.
> 
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1858

I'm afraid this will have the same faith as the rc6 and the validation impact :/

> Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: stable@vger.kernel.org # v5.7
> ---
>  drivers/gpu/drm/i915/Makefile                 |   1 +
>  .../gpu/drm/i915/gt/intel_ring_submission.c   |   4 +-
>  drivers/gpu/drm/i915/i915_mitigations.c       | 148 ++++++++++++++++++
>  drivers/gpu/drm/i915/i915_mitigations.h       |  13 ++
>  4 files changed, 165 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/i915/i915_mitigations.c
>  create mode 100644 drivers/gpu/drm/i915/i915_mitigations.h
> 
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index 4074d8cb0d6e..48f82c354611 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -38,6 +38,7 @@ i915-y += i915_drv.o \
>  	  i915_config.o \
>  	  i915_irq.o \
>  	  i915_getparam.o \
> +	  i915_mitigations.o \
>  	  i915_params.o \
>  	  i915_pci.o \
>  	  i915_scatterlist.o \
> diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
> index 724d56c9583d..657afd8ebc14 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
> @@ -32,6 +32,7 @@
>  #include "gen6_ppgtt.h"
>  #include "gen7_renderclear.h"
>  #include "i915_drv.h"
> +#include "i915_mitigations.h"
>  #include "intel_breadcrumbs.h"
>  #include "intel_context.h"
>  #include "intel_gt.h"
> @@ -918,7 +919,8 @@ static int switch_context(struct i915_request *rq)
>  	GEM_BUG_ON(HAS_EXECLISTS(engine->i915));
>  
>  	if (engine->wa_ctx.vma && ce != engine->kernel_context) {
> -		if (engine->wa_ctx.vma->private != ce) {
> +		if (engine->wa_ctx.vma->private != ce &&
> +		    i915_mitigate_clear_residuals()) {
>  			ret = clear_residuals(rq);
>  			if (ret)
>  				return ret;
> diff --git a/drivers/gpu/drm/i915/i915_mitigations.c b/drivers/gpu/drm/i915/i915_mitigations.c
> new file mode 100644
> index 000000000000..8d5637cfa734
> --- /dev/null
> +++ b/drivers/gpu/drm/i915/i915_mitigations.c
> @@ -0,0 +1,148 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright © 2021 Intel Corporation
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/moduleparam.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +
> +#include "i915_drv.h"
> +#include "i915_mitigations.h"
> +
> +static unsigned long mitigations = ~0UL;
> +
> +enum {
> +	CLEAR_RESIDUALS = 0,

specially worse if this list grows...

> +};
> +
> +static const char * const names[] = {
> +	[CLEAR_RESIDUALS] = "residuals",
> +};
> +
> +bool i915_mitigate_clear_residuals(void)
> +{
> +	return READ_ONCE(mitigations) & BIT(CLEAR_RESIDUALS);
> +}
> +
> +static int mitigations_set(const char *val, const struct kernel_param *kp)
> +{
> +	unsigned long new = ~0UL;
> +	char *str, *sep, *tok;
> +	bool first = true;
> +	int err = 0;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(names) >= BITS_PER_TYPE(mitigations));
> +
> +	str = kstrdup(val, GFP_KERNEL);
> +	if (!str)
> +		return -ENOMEM;
> +
> +	for (sep = str; (tok = strsep(&sep, ","));) {
> +		bool enable = true;
> +		int i;
> +
> +		/* Be tolerant of leading/trailing whitespace */
> +		tok = strim(tok);
> +
> +		if (first) {
> +			first = false;
> +
> +			if (!strcmp(tok, "auto")) {
> +				new = ~0UL;
> +				continue;
> +			}
> +
> +			new = 0;
> +			if (!strcmp(tok, "off"))
> +				continue;
> +		}
> +
> +		if (*tok == '!') {
> +			enable = !enable;
> +			tok++;
> +		}
> +
> +		if (!strncmp(tok, "no", 2)) {
> +			enable = !enable;
> +			tok += 2;
> +		}
> +
> +		if (*tok == '\0')
> +			continue;
> +
> +		for (i = 0; i < ARRAY_SIZE(names); i++) {
> +			if (!strcmp(tok, names[i])) {
> +				if (enable)
> +					new |= BIT(i);
> +				else
> +					new &= ~BIT(i);
> +				break;
> +			}
> +		}
> +		if (i == ARRAY_SIZE(names)) {
> +			pr_err("Bad %s.mitigations=%s, '%s' is unknown\n",
> +			       DRIVER_NAME, val, tok);
> +			err = -EINVAL;
> +			break;
> +		}
> +	}
> +	kfree(str);
> +	if (err)
> +		return err;
> +
> +	WRITE_ONCE(mitigations, new);
> +	return 0;
> +}
> +
> +static int mitigations_get(char *buffer, const struct kernel_param *kp)
> +{
> +	unsigned long local = READ_ONCE(mitigations);
> +	int count, i;
> +	bool enable;
> +
> +	if (!local)
> +		return scnprintf(buffer, PAGE_SIZE, "%s\n", "off");
> +
> +	if (local & BIT(BITS_PER_LONG - 1)) {
> +		count = scnprintf(buffer, PAGE_SIZE, "%s,", "auto");
> +		enable = false;
> +	} else {
> +		enable = true;
> +		count = 0;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(names); i++) {
> +		if ((local & BIT(i)) != enable)
> +			continue;
> +
> +		count += scnprintf(buffer + count, PAGE_SIZE - count,
> +				   "%s%s,", enable ? "" : "!", names[i]);
> +	}
> +
> +	buffer[count - 1] = '\n';
> +	return count;
> +}
> +
> +static const struct kernel_param_ops ops = {
> +	.set = mitigations_set,
> +	.get = mitigations_get,
> +};
> +
> +module_param_cb_unsafe(mitigations, &ops, NULL, 0600);
> +MODULE_PARM_DESC(mitigations,
> +"Selectively enable security mitigations for all Intel® GPUs in the system.\n"
> +"\n"
> +"  auto -- enables all mitigations required for the platform [default]\n"
> +"  off  -- disables all mitigations\n"
> +"\n"
> +"Individual mitigations can be enabled by passing a comma-separated string,\n"
> +"e.g. mitigations=residuals to enable only clearing residuals or\n"
> +"mitigations=auto,noresiduals to disable only the clear residual mitigation.\n"
> +"Either '!' or 'no' may be used to switch from enabling the mitigation to\n"
> +"disabling it.\n"

but I liked this structure to at least stop the growing of the params...

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

> +"\n"
> +"Active mitigations for Ivybridge, Baytrail, Haswell:\n"
> +"  residuals -- clear all thread-local registers between contexts"
> +);
> diff --git a/drivers/gpu/drm/i915/i915_mitigations.h b/drivers/gpu/drm/i915/i915_mitigations.h
> new file mode 100644
> index 000000000000..1359d8135287
> --- /dev/null
> +++ b/drivers/gpu/drm/i915/i915_mitigations.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright © 2021 Intel Corporation
> + */
> +
> +#ifndef __I915_MITIGATIONS_H__
> +#define __I915_MITIGATIONS_H__
> +
> +#include <linux/types.h>
> +
> +bool i915_mitigate_clear_residuals(void);
> +
> +#endif /* __I915_MITIGATIONS_H__ */
> -- 
> 2.20.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
