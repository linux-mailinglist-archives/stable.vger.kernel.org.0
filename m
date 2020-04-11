Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4A61A4F8D
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 13:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDKLkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 07:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgDKLkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 07:40:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7294B214D8;
        Sat, 11 Apr 2020 11:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586605199;
        bh=SvpS8ofQxG/gfKVKsdp7xkFw2sUtzxdRCV1XrE9Gqfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JG9Kg4Bh3+8Rb9Ffl8S4nSejTh7pjxl6ypKqEQ/xOm8pj/3cQNmkKO+nl9p6L0GLV
         a482gx74YHVD/7z045tVuYbDoTVcE1fhljsaaQ6Wy73J8N45zv1tMb2W0HeDWKFJnw
         1IxcDdgsSjthxah8uFTvXmHdvD7UYBtBeIjgm81g=
Date:   Sat, 11 Apr 2020 13:39:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in
 i915_active_wait()
Message-ID: <20200411113957.GB2606747@kroah.com>
References: <20200407065210.GA263852@kroah.com>
 <20200407071809.3148-1-sultan@kerneltoast.com>
 <20200410090838.GD1691838@kroah.com>
 <20200410141738.GB2025@sultan-box.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410141738.GB2025@sultan-box.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 10, 2020 at 07:17:38AM -0700, Sultan Alsawaf wrote:
> On Fri, Apr 10, 2020 at 11:08:38AM +0200, Greg KH wrote:
> > On Tue, Apr 07, 2020 at 12:18:09AM -0700, Sultan Alsawaf wrote:
> > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > > 
> > > The following deadlock exists in i915_active_wait() due to a double lock
> > > on ref->mutex (call chain listed in order from top to bottom):
> > >  i915_active_wait();
> > >  mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
> > >  i915_active_request_retire();
> > >  node_retire();
> > >  active_retire();
> > >  mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK
> > > 
> > > Fix the deadlock by skipping the second ref->mutex lock when
> > > active_retire() is called through i915_active_request_retire().
> > > 
> > > Note that this bug only affects 5.4 and has since been fixed in 5.5.
> > > Normally, a backport of the fix from 5.5 would be in order, but the
> > > patch set that fixes this deadlock involves massive changes that are
> > > neither feasible nor desirable for backporting [1][2][3]. Therefore,
> > > this small patch was made to address the deadlock specifically for 5.4.
> > > 
> > > [1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
> > > [2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
> > > [3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")
> > > 
> > > Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > > ---
> > >  drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
> > >  drivers/gpu/drm/i915/i915_active.h |  4 ++--
> > >  2 files changed, 25 insertions(+), 6 deletions(-)
> > 
> > Now queued up, thanks.
> > 
> > greg k-h
> 
> I'm sorry, I meant the v3 [1]. Apologies for the confusion. The v3 was picked
> into Ubuntu so that's what we're rolling with.

Ok, thanks, hopefully now I picked upthe right one...

greg k-h
