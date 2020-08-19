Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DBE24A706
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHSTks convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Aug 2020 15:40:48 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:49870 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgHSTks (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 15:40:48 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22178220-1500050 
        for multiple; Wed, 19 Aug 2020 20:40:40 +0100
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
Date:   Wed, 19 Aug 2020 20:40:42 +0100
Message-ID: <159786604254.667.11923001796829417234@build.alporthouse.com>
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

> [ 7744.718473] BUG: unable to handle page fault for address: f8c00000
> [ 7744.718484] #PF: supervisor write access in kernel mode
> [ 7744.718487] #PF: error_code(0x0002) - not-present page
> [ 7744.718491] *pdpt = 0000000031b0b001 *pde = 0000000000000000 
> [ 7744.718500] Oops: 0002 [#1] PREEMPT SMP PTI
> [ 7744.718506] CPU: 0 PID: 3004 Comm: Xorg Not tainted 5.9.0-rc1-next-20200819+ #134
> [ 7744.718509] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
> [ 7744.718518] EIP: eb_relocate_vma+0xdbf/0xf20

To save me guessing, paste the above location into
	./scripts/decode_stacktrace.sh ./vmlinux . ./drivers/gpu/drm/i915

The f8c00000 is something running off the end of a kmap, but I didn't
spot a path were we would ignore an error and keep on writing.
Nevertheless it must exist.
-Chris
