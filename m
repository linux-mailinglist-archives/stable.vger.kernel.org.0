Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85B255BED
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 16:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgH1OFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 10:05:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:52679 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgH1OFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 10:05:23 -0400
IronPort-SDR: iCR7KPxJ4SVDLsEzyKZvCGKn/UpDCJyl52FPm2NaqEXKZuiv1Sgj53onrZUIic0uPHhDTmPUp+
 owRgT0XyG9TQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="241482880"
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="241482880"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 07:05:06 -0700
IronPort-SDR: dK9gviBjKEnclbB16DwwGzSs9323lMVMwaGN1DL7jl4vI629FjdiNj/AQg35ASep+uAQrdg7EP
 6knmfqcfT0Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="282409672"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by fmsmga008.fm.intel.com with ESMTP; 28 Aug 2020 07:05:07 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id F10495C277F; Fri, 28 Aug 2020 17:04:10 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Bruce Chang <yu.bruce.chang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 06/39] drm/i915/gt: Wait for CSB entries on Tigerlake
In-Reply-To: <20200826132811.17577-6-chris@chris-wilson.co.uk>
References: <20200826132811.17577-1-chris@chris-wilson.co.uk> <20200826132811.17577-6-chris@chris-wilson.co.uk>
Date:   Fri, 28 Aug 2020 17:04:10 +0300
Message-ID: <87tuwmzx2d.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> Forcibly evict stale csb entries") where, presumably, due to a missing
> Global Observation Point synchronisation, the write pointer of the CSB
> ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> we see the GPU report more context-switch entries for us to parse, but
> those entries have not been written, leading us to process stale events,
> and eventually report a hung GPU.
>
> However, this effect appears to be much more severe than we previously
> saw on Icelake (though it might be best if we try the same approach
> there as well and measure), and Bruce suggested the good idea of resetting
> the CSB entry after use so that we can detect when it has been updated by
> the GPU. By instrumenting how long that may be, we can set a reliable
> upper bound for how long we should wait for:
>
>     513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")

References: HSDES#1508287568

> Suggested-by: Bruce Chang <yu.bruce.chang@intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Bruce Chang <yu.bruce.chang@intel.com>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: stable@vger.kernel.org # v5.4
> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index d6e0f62337b4..d75712a503b7 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
>   */
>  static inline bool gen12_csb_parse(const u64 *csb)
>  {
> -	u64 entry = READ_ONCE(*csb);
> -	bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> -	bool new_queue =
> +	bool ctx_away_valid;
> +	bool new_queue;
> +	u64 entry;
> +
> +	/* HSD#22011248461 */

s/220011248461/1508287568

> +	entry = READ_ONCE(*csb);
> +	if (unlikely(entry == -1)) {
> +		preempt_disable();

As this seems to rather rare, consider falling back to mmio read
for this entry without the poll?

-Mika

> +		if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
> +			GEM_WARN_ON("50us CSB timeout");
> +		preempt_enable();
> +	}
> +	WRITE_ONCE(*(u64 *)csb, -1);
> +
> +	ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> +	new_queue =
>  		lower_32_bits(entry) & GEN12_CTX_STATUS_SWITCHED_TO_NEW_QUEUE;
>  
>  	/*
> @@ -4004,6 +4017,8 @@ static void reset_csb_pointers(struct intel_engine_cs *engine)
>  	WRITE_ONCE(*execlists->csb_write, reset_value);
>  	wmb(); /* Make sure this is visible to HW (paranoia?) */
>  
> +	/* Check that the GPU does indeed update the CSB entries! */
> +	memset(execlists->csb_status, -1, (reset_value + 1) * sizeof(u64));
>  	invalidate_csb_entries(&execlists->csb_status[0],
>  			       &execlists->csb_status[reset_value]);
>  
> -- 
> 2.20.1
