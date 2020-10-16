Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF2128FEE4
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 09:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404322AbgJPHIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 03:08:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:25600 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404250AbgJPHIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 03:08:42 -0400
IronPort-SDR: IFQZIkylY2L1ihJM+CCEqf3Ccog6gHibCGYtut9yZI58kJAh94cBdvoXX4cmBd+3qrH2oHaKFC
 q1rgyUFFSZcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9775"; a="146409831"
X-IronPort-AV: E=Sophos;i="5.77,382,1596524400"; 
   d="scan'208";a="146409831"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 00:08:42 -0700
IronPort-SDR: oNYv+ZCWfOZJTHTvVgrQL/CZUWkcwDpzFhupKVOTkiKTrCT9RTCONyY16nL8F6beeqoeX00VWa
 DdUl2+F02M+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,382,1596524400"; 
   d="scan'208";a="357292343"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Oct 2020 00:08:40 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 3A89E5C2038; Fri, 16 Oct 2020 10:07:07 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gt: Delay execlist processing for tgl
In-Reply-To: <20201015195023.32346-1-chris@chris-wilson.co.uk>
References: <20201015195023.32346-1-chris@chris-wilson.co.uk>
Date:   Fri, 16 Oct 2020 10:07:07 +0300
Message-ID: <87eelysl7o.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk> writes:

> When running gem_exec_nop, it floods the system with many requests (with
> the goal of userspace submitting faster than the HW can process a single
> empty batch). This causes the driver to continually resubmit new
> requests onto the end of an active context, a flood of lite-restore
> preemptions. If we time this just right, Tigerlake hangs.
>
> Inserting a small delay between the processing of CS events and
> submitting the next context, prevents the hang. Naturally it does not
> occur with debugging enabled. The suspicion then is that this is related
> to the issues with the CS event buffer, and inserting an mmio read of
> the CS pointer status appears to be very successful in preventing the
> hang. Other registers, or uncached reads, or plain mb, do not prevent
> the hang, suggesting that register is key -- but that the hang can be
> prevented by a simple udelay, suggests it is just a timing issue like
> that encountered by commit 233c1ae3c83f ("drm/i915/gt: Wait for CSB
> entries on Tigerlake"). Also note that the hang is not prevented by
> applying CTX_DESC_FORCE_RESTORE, or by inserting a delay on the GPU
> between requests.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: Bruce Chang <yu.bruce.chang@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org

Acked-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_lrc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 6170f6874f52..d15d561152ba 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -2711,6 +2711,9 @@ static void process_csb(struct intel_engine_cs *engine)
>  			smp_wmb(); /* complete the seqlock */
>  			WRITE_ONCE(execlists->active, execlists->inflight);
>  
> +			/* Magic delay for tgl */
> +			ENGINE_POSTING_READ(engine, RING_CONTEXT_STATUS_PTR);
> +
>  			WRITE_ONCE(execlists->pending[0], NULL);
>  		} else {
>  			if (GEM_WARN_ON(!*execlists->active)) {
> -- 
> 2.20.1
