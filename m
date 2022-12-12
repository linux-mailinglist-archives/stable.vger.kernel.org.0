Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE264AB26
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 00:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiLLXJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 18:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLLXJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 18:09:01 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357CD60F3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 15:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670886540; x=1702422540;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3o1WZ8betb2kUnHIXBXlT1hezIJeiPny7iniEYg6MUM=;
  b=XrLaPy1fqSd/dr0fFJHQaYK/rZ7BKr2wwu42hdFfPnqWXTiicZ0ww4jK
   JAWaWbFb0fSIajTg8EI8Y9XYPn4d/RfIRFkrNilFb9TF9kra2Uu0I5W0h
   IB60rgSy+4VzzAV95Hd3y1037p6qcengBIHQ6cZx6CmdsNw8SY3JwQpG3
   tvMErL1+mKD3Oc8qJg96+OI9XxXvQDojAwLWYPPUas9QnrbzJ8erSjyko
   95WyxjLGqmdUdjsX96dujBWWzLtO+g3tYy4O/spYYZZqv/nXZDQ583m8k
   1YqNu5zrNxijx7HqcO1MjJ7qcSP3iZWoyWPRd1vWq2vpg/JZylcf509XY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="319128072"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="319128072"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 15:08:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="822661955"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="822661955"
Received: from anicol1x-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.59.70])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 15:08:56 -0800
Date:   Tue, 13 Dec 2022 00:08:50 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi@etezian.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/gt: Reset twice
Message-ID: <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
 <Y5dc7vhfh6yixFRo@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5dc7vhfh6yixFRo@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rodrigo,

On Mon, Dec 12, 2022 at 11:55:10AM -0500, Rodrigo Vivi wrote:
> On Mon, Dec 12, 2022 at 05:13:38PM +0100, Andi Shyti wrote:
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> > After applying an engine reset, on some platforms like Jasperlake, we
> > occasionally detect that the engine state is not cleared until shortly
> > after the resume. As we try to resume the engine with volatile internal
> > state, the first request fails with a spurious CS event (it looks like
> > it reports a lite-restore to the hung context, instead of the expected
> > idle->active context switch).
> > 
> > Signed-off-by: Chris Wilson <hris@chris-wilson.co.uk>
> 
> There's a typo in the signature email I'm afraid...

oh yes, I forgot the 'C' :)

> Other than that, have we checked the possibility of using the driver-initiated-flr bit
> instead of this second loop? That should be the right way to guarantee everything is
> cleared on gen11+...

maybe I am misinterpreting it, but is FLR the same as resetting
hardware domains individually?

How am I supposed to use driver_initiated_flr() in this context?

Thanks,
Andi

> > Cc: stable@vger.kernel.org
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/gt/intel_reset.c | 34 ++++++++++++++++++++++-----
> >  1 file changed, 28 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
> > index ffde89c5835a4..88dfc0c5316ff 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> > @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt, intel_engine_mask_t engine_mask,
> >  static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
> >  {
> >  	struct intel_uncore *uncore = gt->uncore;
> > +	int loops = 2;
> >  	int err;
> >  
> >  	/*
> > @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
> >  	 * for fifo space for the write or forcewake the chip for
> >  	 * the read
> >  	 */
> > -	intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
> > +	do {
> > +		intel_uncore_write_fw(uncore, GEN6_GDRST, hw_domain_mask);
> >  
> > -	/* Wait for the device to ack the reset requests */
> > -	err = __intel_wait_for_register_fw(uncore,
> > -					   GEN6_GDRST, hw_domain_mask, 0,
> > -					   500, 0,
> > -					   NULL);
> > +		/*
> > +		 * Wait for the device to ack the reset requests.
> > +		 *
> > +		 * On some platforms, e.g. Jasperlake, we see see that the
> > +		 * engine register state is not cleared until shortly after
> > +		 * GDRST reports completion, causing a failure as we try
> > +		 * to immediately resume while the internal state is still
> > +		 * in flux. If we immediately repeat the reset, the second
> > +		 * reset appears to serialise with the first, and since
> > +		 * it is a no-op, the registers should retain their reset
> > +		 * value. However, there is still a concern that upon
> > +		 * leaving the second reset, the internal engine state
> > +		 * is still in flux and not ready for resuming.
> > +		 */
> > +		err = __intel_wait_for_register_fw(uncore, GEN6_GDRST,
> > +						   hw_domain_mask, 0,
> > +						   2000, 0,
> > +						   NULL);
> > +	} while (err == 0 && --loops);
> >  	if (err)
> >  		GT_TRACE(gt,
> >  			 "Wait for 0x%08x engines reset failed\n",
> >  			 hw_domain_mask);
> >  
> > +	/*
> > +	 * As we have observed that the engine state is still volatile
> > +	 * after GDRST is acked, impose a small delay to let everything settle.
> > +	 */
> > +	udelay(50);
> > +
> >  	return err;
> >  }
> >  
> > -- 
> > 2.38.1
> > 
