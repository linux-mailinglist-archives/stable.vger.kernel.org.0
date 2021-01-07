Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029ED2EE818
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbhAGWFe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 7 Jan 2021 17:05:34 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:50030 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbhAGWFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:05:34 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23532673-1500050 
        for multiple; Thu, 07 Jan 2021 22:04:48 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210107195037.GA7228@intel.com>
References: <20201016175411.30406-1-chris@chris-wilson.co.uk> <20210107195037.GA7228@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Limit VFE threads based on GT
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Date:   Thu, 07 Jan 2021 22:04:46 +0000
Message-ID: <161005708697.28368.4209742988334494636@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Rodrigo Vivi (2021-01-07 19:50:37)
> On Fri, Oct 16, 2020 at 06:54:11PM +0100, Chris Wilson wrote:
> > MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> > range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> > based on plaform and the number of EU based on the number of slices and
> > subslices. This is a fixed number per platform/gt, so appropriately
> > limit the number of threads we spawn to match the device.
> > 
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024
> 
> we need to get this closed...

Unfortunately this failed the validation test. And as that test is still
not in CI, I cannot say why. My vote would be to remove the
clear_residuals until it works on all target platforms. Plus we clearly
need a hsw-gt1 in CI.
 
> >       bv->scratch_size = bv->surface_height * bv->surface_width;
> > @@ -244,7 +258,6 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
> >                   u32 urb_size, u32 curbe_size,
> >                   u32 mode)
> >  {
> > -     u32 urb_entries = bv->max_urb_entries;
> >       u32 threads = bv->max_primitives - 1;
> >       u32 *cs = batch_alloc_items(batch, 32, 8);
> >  
> > @@ -254,7 +267,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
> >       *cs++ = 0;
> >  
> >       /* number of threads & urb entries for GPGPU vs Media Mode */
> > -     *cs++ = threads << 16 | urb_entries << 8 | mode << 2;
> > +     *cs++ = threads << 16 | 1 << 8 | mode << 2;
> 
> why urb_entries = 1 ?

We only used a single entry. There was no measurable benefit from
assigning more entries, and the importance of any side effects from doing
so unknown.

> the range is 0,64 and 0,128 depending on the sku.
> 
> in general there's a min of 32 URBs

Don't forget num_entries * entry_size must fit within the URB
allocation/allotment.
-Chris
