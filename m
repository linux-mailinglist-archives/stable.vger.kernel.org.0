Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CB1B0524
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgDTJCq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Apr 2020 05:02:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:11723 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTJCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 05:02:45 -0400
IronPort-SDR: 8AZtY0E8gMiCPcFSVhByZ7WM/ik7jgvxFfnSNDpV5t0NH58FtZ61rdjr0l77VM9tffk1iZ2ov+
 U3WCktlvG+Og==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 02:02:45 -0700
IronPort-SDR: W43QuHTRN9lzxVVxpdQ/51zBDFMLtoJ72uvQxBoQqvQmZYsFpzmPIHn7amsBqoXBhDPvVGlBwL
 UxS+phTST7ww==
X-IronPort-AV: E=Sophos;i="5.72,406,1580803200"; 
   d="scan'208";a="429053088"
Received: from jlahtine-desk.ger.corp.intel.com (HELO localhost) ([10.252.46.49])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 02:02:42 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200414082344.GA10645@kroah.com>
References: <20200407065210.GA263852@kroah.com> <20200407071809.3148-1-sultan@kerneltoast.com> <20200410090838.GD1691838@kroah.com> <20200410141738.GB2025@sultan-box.localdomain> <20200411113957.GB2606747@kroah.com> <158685210730.16269.15932754047962572236@build.alporthouse.com> <20200414082344.GA10645@kroah.com>
Subject: Re: [PATCH v2] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Date:   Mon, 20 Apr 2020 12:02:39 +0300
Message-ID: <158737335977.8380.15005528012712372014@jlahtine-desk.ger.corp.intel.com>
User-Agent: alot/0.8.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Greg KH (2020-04-14 11:23:44)
> On Tue, Apr 14, 2020 at 09:15:07AM +0100, Chris Wilson wrote:
> > Quoting Greg KH (2020-04-11 12:39:57)
> > > On Fri, Apr 10, 2020 at 07:17:38AM -0700, Sultan Alsawaf wrote:
> > > > On Fri, Apr 10, 2020 at 11:08:38AM +0200, Greg KH wrote:
> > > > > On Tue, Apr 07, 2020 at 12:18:09AM -0700, Sultan Alsawaf wrote:
> > > > > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > > > > > 
> > > > > > The following deadlock exists in i915_active_wait() due to a double lock
> > > > > > on ref->mutex (call chain listed in order from top to bottom):
> > > > > >  i915_active_wait();
> > > > > >  mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
> > > > > >  i915_active_request_retire();
> > > > > >  node_retire();
> > > > > >  active_retire();
> > > > > >  mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK
> > > > > > 
> > > > > > Fix the deadlock by skipping the second ref->mutex lock when
> > > > > > active_retire() is called through i915_active_request_retire().
> > > > > > 
> > > > > > Note that this bug only affects 5.4 and has since been fixed in 5.5.
> > > > > > Normally, a backport of the fix from 5.5 would be in order, but the
> > > > > > patch set that fixes this deadlock involves massive changes that are
> > > > > > neither feasible nor desirable for backporting [1][2][3]. Therefore,
> > > > > > this small patch was made to address the deadlock specifically for 5.4.
> > > > > > 
> > > > > > [1] 274cbf20fd10 ("drm/i915: Push the i915_active.retire into a worker")
> > > > > > [2] 093b92287363 ("drm/i915: Split i915_active.mutex into an irq-safe spinlock for the rbtree")
> > > > > > [3] 750bde2fd4ff ("drm/i915: Serialise with remote retirement")
> > > > > > 
> > > > > > Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
> > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > > > > > ---
> > > > > >  drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
> > > > > >  drivers/gpu/drm/i915/i915_active.h |  4 ++--
> > > > > >  2 files changed, 25 insertions(+), 6 deletions(-)
> > > > > 
> > > > > Now queued up, thanks.
> > > > > 
> > > > > greg k-h
> > > > 
> > > > I'm sorry, I meant the v3 [1]. Apologies for the confusion. The v3 was picked
> > > > into Ubuntu so that's what we're rolling with.
> > > 
> > > Ok, thanks, hopefully now I picked upthe right one...
> > 
> > The patch does not fix a deadlock. Greg, this patch is not a backport of
> > a bugfix, why is it in stable?
> 
> Because it says it can't be a backport as the 3 above mentioned patches
> do the same thing instead?

Apologies for jumping late to the thread.

> I will be glad to drop this, but I need some kind of direction here, and
> given that at least one distro is already shipping this, it felt like
> the correct thing to do.
>
> So, what do you want me to do?

I think the the patch should be dropped for now before the issue is
properly addressed. Either by backporting the mainline fixes or if
those are too big and there indeed is a smaller alternative patch
that is properly reviewed. But the above patch is not, at least yet.

There is an another similar thread where there's jumping into
conclusions and doing ad-hoc patches for already fixed issues:

https://lore.kernel.org/dri-devel/20200414144309.GB2082@sultan-box.localdomain/

I appreciate enthusiasm to provide fixes to i915 but we should
continue do the regular due diligence to make sure we're properly
fixing bugs in upstream kernels. And when fixing them, to make
sure we're not simply papering over them for a single use case.

It would be preferred to file a bug for the seen issues,
describing how to reproduce them with vanilla upstream kernels:

https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs

That way we have enough information to assess the severity of the
bug and to prioritize the work accordingly.

Best Regards, Joonas
