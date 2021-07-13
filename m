Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8163C77E8
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhGMUZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:25:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:60120 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234290AbhGMUZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 16:25:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="197510097"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="197510097"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:22:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="459708451"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga008.jf.intel.com with SMTP; 13 Jul 2021 13:22:51 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 13 Jul 2021 23:22:50 +0300
Date:   Tue, 13 Jul 2021 23:22:50 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
Message-ID: <YO32GlZWgAnZk+dD@intel.com>
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
 <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
 <CAKMK7uFTYgK9rmXTNSczPdBWPTNaLBp-GitzBQb0-gX5wZWHNQ@mail.gmail.com>
 <CAKMK7uFjgu_TkPFYs0DTdAh9tdDbdpUc0S1n5XUfHJaq_0FHVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFjgu_TkPFYs0DTdAh9tdDbdpUc0S1n5XUfHJaq_0FHVw@mail.gmail.com>
X-Patchwork-Hint: comment
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

Thought I did. Apparently got lost somewhere.

> > - this should probably be ENOSPC or something like that for at least a
> > seeming retention of errno consistentcy:

ENOSPC is already used for other things.

> >
> > https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#recommended-ioctl-return-values
> 
> Other option would be to map that back to EDEADLK in the execbuf ioctl
> somewhere, so we retain a distinct errno code.

Already mentioned in the commit msg.

-- 
Ville Syrjälä
Intel
