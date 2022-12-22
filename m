Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC6C65421B
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 14:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiLVNrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 08:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLVNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 08:47:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D4BFCCA
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 05:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671716838; x=1703252838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=t787D+ejcPn+qQ2R2zVIIBxpAJBzcOzsEzKHnLIDJ5E=;
  b=NtlpI7/slmWqm5UZi9a6GgIh25CUhJFKN2i6eiLXqFXOHP7s5kKwahOZ
   KKjFnFniuGG48sXtX5ZTnCz0mNkIj/qYztwUmWN0RfQog2UZTzlZK4MeF
   0yvxAbNrF0fM47U9LrHYHiQqwS5K2yEWtUst9i6pXHwRZnJScxO/LaM8J
   2+n/ccAszshFBKGwG2tsxLOXbErJXgPJHLGDY9pNtgHQxubGcMIR543aw
   C1n0/gGrHqqdXmuGE9oc4BiefQhtCvfkDvbaK7VbJfuOg+jKzClQMlL8K
   yQad+RzQXkCgO7kZnYN+ABfyAcesmuHZjIossJpaqSbzM0A2q0+2KaCdc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="299798159"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="299798159"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 05:47:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="740545352"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="740545352"
Received: from mbanciu-mobl.ger.corp.intel.com (HELO intel.com) ([10.252.32.90])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 05:47:15 -0800
Date:   Thu, 22 Dec 2022 14:47:12 +0100
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Reset twice
Message-ID: <Y6Rf4LvHlbeFy/iF@ashyti-mobl2.lan>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
 <Y5dc7vhfh6yixFRo@intel.com>
 <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
 <51402d0d8cfdc319d0786ec03c5ada4d82757cf0.camel@intel.com>
 <Y5pQH+KGujkSJTvT@ashyti-mobl2.lan>
 <Y5t+gEMl/XFpAh4N@intel.com>
 <4a3f841d-e0ab-dfd9-a6c0-08e2e04c7b6f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a3f841d-e0ab-dfd9-a6c0-08e2e04c7b6f@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi GG,

> > > > > > >   drivers/gpu/drm/i915/gt/intel_reset.c | 34
> > > > > > > ++++++++++++++++++++++-----
> > > > > > >   1 file changed, 28 insertions(+), 6 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > > > b/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > > > index ffde89c5835a4..88dfc0c5316ff 100644
> > > > > > > --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > > > +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> > > > > > > @@ -268,6 +268,7 @@ static int ilk_do_reset(struct intel_gt *gt,
> > > > > > > intel_engine_mask_t engine_mask,
> > > > > > >   static int gen6_hw_domain_reset(struct intel_gt *gt, u32
> > > > > > > hw_domain_mask)
> > > > > > >   {
> > > > > > >          struct intel_uncore *uncore = gt->uncore;
> > > > > > > +       int loops = 2;
> > > > > > >          int err;
> > > > > > >          /*
> > > > > > > @@ -275,18 +276,39 @@ static int gen6_hw_domain_reset(struct
> > > > > > > intel_gt *gt, u32 hw_domain_mask)
> > > > > > >           * for fifo space for the write or forcewake the chip for
> > > > > > >           * the read
> > > > > > >           */
> > > > > > > -       intel_uncore_write_fw(uncore, GEN6_GDRST,
> > > > > > > hw_domain_mask);
> > > > > > > +       do {
> > > > > > > +               intel_uncore_write_fw(uncore, GEN6_GDRST,
> > > > > > > hw_domain_mask);
> > > > > > > -       /* Wait for the device to ack the reset requests */
> > > > > > > -       err = __intel_wait_for_register_fw(uncore,
> > > > > > > -                                          GEN6_GDRST,
> > > > > > > hw_domain_mask, 0,
> > > > > > > -                                          500, 0,
> > > > > > > -                                          NULL);
> > > > > > > +               /*
> > > > > > > +                * Wait for the device to ack the reset requests.
> > > > > > > +                *
> > > > > > > +                * On some platforms, e.g. Jasperlake, we see see
> > > > > > > that the
> > > > > > > +                * engine register state is not cleared until
> > > > > > > shortly after
> > > > > > > +                * GDRST reports completion, causing a failure as
> > > > > > > we try
> > > > > > > +                * to immediately resume while the internal state
> > > > > > > is still
> > > > > > > +                * in flux. If we immediately repeat the reset,
> > > > > > > the second
> > > > > > > +                * reset appears to serialise with the first, and
> > > > > > > since
> > > > > > > +                * it is a no-op, the registers should retain
> > > > > > > their reset
> > > > > > > +                * value. However, there is still a concern that
> > > > > > > upon
> > > > > > > +                * leaving the second reset, the internal engine
> > > > > > > state
> > > > > > > +                * is still in flux and not ready for resuming.
> > > > > > > +                */
> > > > > > > +               err = __intel_wait_for_register_fw(uncore,
> > > > > > > GEN6_GDRST,
> > > > > > > +
> > > > > > > hw_domain_mask, 0,
> > > > > > > +                                                  2000, 0,
> > > > > > > +                                                  NULL);

> Andi, fast_timeout_us is increased from 500 to 2000, and if it fails, it
> tries to reset it once more. How was this value of 2000 calculated?

No real reason, it's just an empiric choice to make the call a
bit more robust and suffer less from delayed feedback.

> > > > > > > +       } while (err == 0 && --loops);
> > > > > > >          if (err)
> > > > > > >                  GT_TRACE(gt,
> > > > > > >                           "Wait for 0x%08x engines reset
> > > > > > > failed\n",
> > > > > > >                           hw_domain_mask);

> Did GT_TRACE report an error in a situation where the problem was reported?

I guess so, in Jasperlake.

> > > > > > > +       /*
> > > > > > > +        * As we have observed that the engine state is still
> > > > > > > volatile
> > > > > > > +        * after GDRST is acked, impose a small delay to let
> > > > > > > everything settle.
> > > > > > > +        */
> > > > > > > +       udelay(50);

> udelay(50) affects all platforms that can call gen6_hw_domain_reset(), is
> that intended?

Yes, that's intended as apparently we need to give it a bit more
time for the engines to recover from the reset. We are here in
atomic context and we need udelay to wait atomically, thus
udelay().

Thank you,
Andi
