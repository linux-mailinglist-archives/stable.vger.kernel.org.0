Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518A9F8C1A
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 10:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfKLJma convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 12 Nov 2019 04:42:30 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:56320 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbfKLJma (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 04:42:30 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19170270-1500050 
        for multiple; Tue, 12 Nov 2019 09:42:25 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Daniel Vetter <daniel@ffwll.ch>,
        Francisco Jerez <currojerez@riseup.net>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <CAKMK7uEgFS8FAatJBzsEid72sy2_h8x2WsyhsZuyyfaoD1Lg0Q@mail.gmail.com>
Cc:     intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>
References: <20190718145407.21352-1-chris@chris-wilson.co.uk>
 <20190718145407.21352-4-chris@chris-wilson.co.uk>
 <CAKMK7uEgFS8FAatJBzsEid72sy2_h8x2WsyhsZuyyfaoD1Lg0Q@mail.gmail.com>
Message-ID: <157355174344.9322.13853897964725973571@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915: Flush stale cachelines on
 set-cache-level
Date:   Tue, 12 Nov 2019 09:42:23 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Daniel Vetter (2019-11-12 09:09:06)
> On Thu, Jul 18, 2019 at 4:54 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > Ensure that we flush any cache dirt out to main memory before the user
> > changes the cache-level as they may elect to bypass the cache (even after
> > declaring their access cache-coherent) via use of unprivileged MOCS.
> >
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/i915/gem/i915_gem_domain.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > index 2e3ce2a69653..5d41e769a428 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
> > @@ -277,6 +277,11 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
> >
> >         list_for_each_entry(vma, &obj->vma.list, obj_link)
> >                 vma->node.color = cache_level;
> > +
> > +       /* Flush any previous cache dirt in case of cache bypass */
> > +       if (obj->cache_dirty & ~obj->cache_coherent)
> > +               i915_gem_clflush_object(obj, I915_CLFLUSH_SYNC);
> 
> I think writing out the bit logic instead of implicitly relying on the
> #defines would be much better, i.e. && !(cache_coherent &
> COHERENT_FOR_READ). Plus I think we only need to set cache_dirty =
> true if we don't flush here already, to avoid double flushing?

No. The mask is being updated, so you need to flush before you lose
track. The cache is then cleared of the dirty bit so won't be flushed
again until dirty and no longer coherent. We need to flag that the page
is no longer coherent at the end of its lifetime (passing back to the
system) to force the flush then.
-Chris
