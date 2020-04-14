Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6B1A75A2
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407083AbgDNIPX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 14 Apr 2020 04:15:23 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60260 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407082AbgDNIPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:15:20 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20891802-1500050 
        for multiple; Tue, 14 Apr 2020 09:15:08 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200411113957.GB2606747@kroah.com>
References: <20200407065210.GA263852@kroah.com> <20200407071809.3148-1-sultan@kerneltoast.com> <20200410090838.GD1691838@kroah.com> <20200410141738.GB2025@sultan-box.localdomain> <20200411113957.GB2606747@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Message-ID: <158685210730.16269.15932754047962572236@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 14 Apr 2020 09:15:07 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2020-04-11 12:39:57)
> On Fri, Apr 10, 2020 at 07:17:38AM -0700, Sultan Alsawaf wrote:
> > On Fri, Apr 10, 2020 at 11:08:38AM +0200, Greg KH wrote:
> > > On Tue, Apr 07, 2020 at 12:18:09AM -0700, Sultan Alsawaf wrote:
> > > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > > > 
> > > > The following deadlock exists in i915_active_wait() due to a double lock
> > > > on ref->mutex (call chain listed in order from top to bottom):
> > > >  i915_active_wait();
> > > >  mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
> > > >  i915_active_request_retire();
> > > >  node_retire();
> > > >  active_retire();
> > > >  mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK
> > > > 
> > > > Fix the deadlock by skipping the second ref->mutex lock when
> > > > active_retire() is called through i915_active_request_retire().
> > > > 
> > > > Note that this bug only affects 5.4 and has since been fixed in 5.5.
> > > > Normally, a backport of the fix from 5.5 would be in order, but the
> > > > patch set that fixes this deadlock involves massive changes that are
> > > > neither feasible nor desirable for backporting [1][2][3]. Therefore,
> > > > this small patch was made to address the deadlock specifically for 5.4.
> > > > 
> > > > [1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
> > > > [2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
> > > > [3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")
> > > > 
> > > > Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > > > ---
> > > >  drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
> > > >  drivers/gpu/drm/i915/i915_active.h |  4 ++--
> > > >  2 files changed, 25 insertions(+), 6 deletions(-)
> > > 
> > > Now queued up, thanks.
> > > 
> > > greg k-h
> > 
> > I'm sorry, I meant the v3 [1]. Apologies for the confusion. The v3 was picked
> > into Ubuntu so that's what we're rolling with.
> 
> Ok, thanks, hopefully now I picked upthe right one...

The patch does not fix a deadlock. Greg, this patch is not a backport of
a bugfix, why is it in stable?
-Chris
