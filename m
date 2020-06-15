Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22F1F8EEC
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 08:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFOG7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 02:59:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:1518 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbgFOG7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 02:59:10 -0400
IronPort-SDR: 3H0cUk9W3U0O4ArSS9xW2Iv6nUtebNWsqmOxETyxK/FMkhyB8G3DOjEKdR6FbBOXHHMjfV5zQv
 b0fVJ6kyL28A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2020 23:59:09 -0700
IronPort-SDR: oic9DtRS/u/aAmXolUgNJg6D4j8JcEGeDTwsgVaArHwcIYnmEfIeobd+MKIYIiqtr8o0s9dQ38
 WPDeQhMjkwdA==
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="298418308"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2020 23:59:08 -0700
Date:   Mon, 15 Jun 2020 09:59:01 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Kunal Joshi <kunal1.joshi@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/icl+: Fix hotplug interrupt
 disabling after storm detection
Message-ID: <20200615065901.GA16626@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20200612121731.19596-1-imre.deak@intel.com>
 <20200612131848.GH6112@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200612131848.GH6112@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 04:18:48PM +0300, Ville Syrjälä wrote:
> On Fri, Jun 12, 2020 at 03:17:31PM +0300, Imre Deak wrote:
> > Atm, hotplug interrupts on TypeC ports are left enabled after detecting
> > an interrupt storm, fix this.
> > 
> > Reported-by: Kunal Joshi <kunal1.joshi@intel.com>
> > References: https://gitlab.freedesktop.org/drm/intel/-/issues/351
> > Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/1964
> > Cc: Kunal Joshi <kunal1.joshi@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_irq.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> > index 8e823ba25f5f..710224d930c5 100644
> > --- a/drivers/gpu/drm/i915/i915_irq.c
> > +++ b/drivers/gpu/drm/i915/i915_irq.c
> > @@ -3132,6 +3132,7 @@ static void gen11_hpd_irq_setup(struct drm_i915_private *dev_priv)
> >  
> >  	val = I915_READ(GEN11_DE_HPD_IMR);
> >  	val &= ~hotplug_irqs;
> > +	val |= ~enabled_irqs & hotplug_irqs;
> >  	I915_WRITE(GEN11_DE_HPD_IMR, val);
> >  	POSTING_READ(GEN11_DE_HPD_IMR);
> 
> Wondering if we should add a function for this just for consistency
> with all the other platforms.

Yes makes sense, or even abstract the hpd interrupt enabling using the
hpd pin -> interrupt flag table. I think we could even extend that table
with the pulse detection bits and register addresses. I'll check if
something like this would work for all platforms.

> Alhthough we don't strictly need one since we have no other users of
> this register. So maybe not.
> 
> Anyways, patch is
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Thanks, pushed.

> 
> >  
> > -- 
> > 2.23.1
> > 
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
> -- 
> Ville Syrjälä
> Intel
