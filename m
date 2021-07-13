Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4FA3C77C9
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhGMUWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:22:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:21289 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234933AbhGMUWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 16:22:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="190614984"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="190614984"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:20:01 -0700
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="493245515"
Received: from rmvillaz-mobl2.amr.corp.intel.com (HELO intel.com) ([10.212.91.132])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:20:00 -0700
Date:   Tue, 13 Jul 2021 16:19:59 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
Message-ID: <YO31b16UqQtsjX1b@intel.com>
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
 <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
 <CAKMK7uFTYgK9rmXTNSczPdBWPTNaLBp-GitzBQb0-gX5wZWHNQ@mail.gmail.com>
 <CAKMK7uFjgu_TkPFYs0DTdAh9tdDbdpUc0S1n5XUfHJaq_0FHVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFjgu_TkPFYs0DTdAh9tdDbdpUc0S1n5XUfHJaq_0FHVw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 09:59:18PM +0200, Daniel Vetter wrote:
> On Tue, Jul 13, 2021 at 9:58 PM Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Thu, Jul 1, 2021 at 9:07 AM Maarten Lankhorst
> > <maarten.lankhorst@linux.intel.com> wrote:
> > > Op 30-06-2021 om 18:44 schreef Ville Syrjala:
> > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > >
> > > > The conversion to ww mutexes failed to address the fence code which
> > > > already returns -EDEADLK when we run out of fences. Ww mutexes on
> > > > the other hand treat -EDEADLK as an internal errno value indicating
> > > > a need to restart the operation due to a deadlock. So now when the
> > > > fence code returns -EDEADLK the higher level code erroneously
> > > > restarts everything instead of returning the error to userspace
> > > > as is expected.
> > > >
> > > > To remedy this let's switch the fence code to use a different errno
> > > > value for this. -ENOBUFS seems like a semi-reasonable unique choice.
> > > > Apart from igt the only user of this I could find is sna, and even
> > > > there all we do is dump the current fence registers from debugfs
> > > > into the X server log. So no user visible functionality is affected.
> > > > If we really cared about preserving this we could of course convert
> > > > back to -EDEADLK higher up, but doesn't seem like that's worth
> > > > the hassle here.
> > > >
> > > > Not quite sure which commit specifically broke this, but I'll
> > > > just attribute it to the general gem ww mutex work.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > Cc: Thomas Hellström <thomas.hellstrom@intel.com>
> > > > Testcase: igt/gem_pread/exhaustion
> > > > Testcase: igt/gem_pwrite/basic-exhaustion
> > > > Testcase: igt/gem_fenced_exec_thrash/too-many-fences
> > > > Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww_ctx locking, v2.")
> > > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > ---
> > > >  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > > > index cac7f3f44642..f8948de72036 100644
> > > > --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > > > +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > > > @@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i915_ggtt *ggtt)
> > > >       if (intel_has_pending_fb_unpin(ggtt->vm.i915))
> > > >               return ERR_PTR(-EAGAIN);
> > > >
> > > > -     return ERR_PTR(-EDEADLK);
> > > > +     return ERR_PTR(-ENOBUFS);
> > > >  }
> > > >
> > > >  int __i915_vma_pin_fence(struct i915_vma *vma)
> > >
> > > Makes sense..
> > >
> > > Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > >
> > > Is it a slightly more reent commit? Might probably be the part that converts execbuffer to use ww locks.
> >
> > - please cc: dri-devel on anything gem/gt related.
> > - this should probably be ENOSPC or something like that for at least a
> > seeming retention of errno consistentcy:
> >
> > https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#recommended-ioctl-return-values
> 
> Other option would be to map that back to EDEADLK in the execbuf ioctl
> somewhere, so we retain a distinct errno code.

I'm about to push this patch to drm-intel-fixes... I'm assuming if there's any fix it will
be a follow-up patch and not a revert or force push, right?!

> -Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
