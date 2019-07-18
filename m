Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A926D496
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfGRTTP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 18 Jul 2019 15:19:15 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:65154 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727685AbfGRTTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:19:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17408102-1500050 
        for multiple; Thu, 18 Jul 2019 20:19:10 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     =?utf-8?b?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190718182843.GG5942@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        stable@vger.kernel.org
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-2-chris@chris-wilson.co.uk>
 <20190718182843.GG5942@intel.com>
Message-ID: <156347754810.24728.7304494028374635459@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [PATCH 2/4] drm/i915: Use maximum write flush for pwrite_gtt
Date:   Thu, 18 Jul 2019 20:19:08 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjälä (2019-07-18 19:28:43)
> On Thu, Jul 18, 2019 at 03:54:05PM +0100, Chris Wilson wrote:
> > As recently disovered by forcing big-core (!llc) machines to use the GTT
> > paths, we need our full GTT write flush before manipulating the GTT PTE
> > or else the writes may be directed to the wrong page.
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: Matthew Auld <matthew.william.auld@gmail.com>
> > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index fed0bc421a55..c6ba350e6e4f 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -610,7 +610,8 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
> >               unsigned int page_length = PAGE_SIZE - page_offset;
> >               page_length = remain < page_length ? remain : page_length;
> >               if (node.allocated) {
> > -                     wmb(); /* flush the write before we modify the GGTT */
> > +                     /* flush the write before we modify the GGTT */
> > +                     intel_gt_flush_ggtt_writes(ggtt->vm.gt);
> 
> Matches the story told by intel_gt_flush_ggtt_writes().
> 
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Ta, pushed to dinq. Hopefully, this may explain some mystery fails!
(Not that any sane userspace does for(;;) { gem_write(); gem_read(); })
-Chris
