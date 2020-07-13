Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461CB21D3E4
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 12:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgGMKkC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 13 Jul 2020 06:40:02 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:54896 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727890AbgGMKkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 06:40:02 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21802092-1500050 
        for multiple; Mon, 13 Jul 2020 11:39:50 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4d6930b8-80d2-0e74-79fa-9e297beccf26@linux.intel.com>
References: <20200711203236.12330-1-chris@chris-wilson.co.uk> <4d6930b8-80d2-0e74-79fa-9e297beccf26@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Ignore irq enabling on the virtual engines
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Mon, 13 Jul 2020 11:39:50 +0100
Message-ID: <159463679080.14386.1679019125495124467@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2020-07-13 11:19:58)
> 
> On 11/07/2020 21:32, Chris Wilson wrote:
> > We do not use the virtual engines for interrupts (they have physical
> > components), but we do use them to decouple the fence signaling during
> > submission. Currently, when we submit a completed request, we try to
> > enable the interrupt handler for the virtual engine, but we never disarm
> > it. A quick fix is then to mark the irq as enabled, and it will then
> > remain enabled -- and this prevents us from waking the device and never
> > letting it sleep again.
> > 
> > Fixes: f8db4d051b5e ("drm/i915: Initialise breadcrumb lists on the virtual engine")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > Cc: <stable@vger.kernel.org> # v5.5+
> > ---
> >   drivers/gpu/drm/i915/gt/intel_lrc.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > index cd4262cc96e2..504e269bb166 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > @@ -5727,6 +5727,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
> >       intel_engine_init_active(&ve->base, ENGINE_VIRTUAL);
> >       intel_engine_init_breadcrumbs(&ve->base);
> >       intel_engine_init_execlists(&ve->base);
> > +     ve->base.breadcrumbs.irq_armed = true;
> 
> Add a comment here saying this is a hack and why please. With that:

"This is a lot simpler than splitting breadcrumbs, although we do need
to do that. But that was becoming a very hairy patch."
-Chris
