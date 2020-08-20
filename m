Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04024B039
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 09:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgHTHgZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 20 Aug 2020 03:36:25 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:51243 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbgHTHgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 03:36:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22181544-1500050 
        for multiple; Thu, 20 Aug 2020 08:36:13 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200819193326.p62h2dj7jpzfkeyy@duo.ucw.cz>
References: <20200819103952.19083-1-chris@chris-wilson.co.uk> <20200819172331.GA4796@amd> <159785861047.667.10730572472834322633@build.alporthouse.com> <20200819193326.p62h2dj7jpzfkeyy@duo.ucw.cz>
Subject: Re: [PATCH 1/2] drm/i915/gem: Replace reloc chain with terminator on error unwind
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        stable@vger.kernel.org
To:     Pavel Machek <pavel@ucw.cz>
Date:   Thu, 20 Aug 2020 08:36:11 +0100
Message-ID: <159790897155.667.4491040035549523476@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Pavel Machek (2020-08-19 20:33:26)
> Hi!
> 
> > > > If we hit an error during construction of the reloc chain, we need to
> > > > replace the chain into the next batch with the terminator so that upon
> > > > flushing the relocations so far, we do not execute a hanging batch.
> > > 
> > > Thanks for the patches. I assume this should fix problem from
> > > "5.9-rc1: graphics regression moved from -next to mainline" thread.
> > > 
> > > I have applied them over current -next, and my machine seems to be
> > > working so far (but uptime is less than 30 minutes).
> > > 
> > > If the machine still works tommorow, I'll assume problem is solved.
> > 
> > Aye, best wait until we have to start competing with Chromium for
> > memory... The suspicion is that it was the resource allocation failure
> > path.
> 
> Yep, my machines are low on memory.
> 
> But ... test did not work that well. I have dead X and blinking
> screen. Machine still works reasonably well over ssh, so I guess
> that's an improvement.

Well my last remaining 32bit gen3 device is currently pushing up the
daises, so could you try removing the attempt to use WC? Something like

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 44df98d85b38..b26f7de913c3 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -955,10 +955,7 @@ static u32 *__reloc_gpu_map(struct reloc_cache *cache,
 {
        u32 *map;

-       map = i915_gem_object_pin_map(pool->obj,
-                                     cache->has_llc ?
-                                     I915_MAP_FORCE_WB :
-                                     I915_MAP_FORCE_WC);
+       map = i915_gem_object_pin_map(pool->obj, I915_MAP_FORCE_WB);

on top of the previous patch. Faultinjection didn't turn up anything in
eb_relocate_vma, so we need to dig deeper.
-Chris
