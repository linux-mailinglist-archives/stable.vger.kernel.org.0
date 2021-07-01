Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD333B951E
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhGARCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:02:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:60460 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhGARCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 13:02:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205568458"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205568458"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 10:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="457738053"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 01 Jul 2021 10:00:07 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 01 Jul 2021 20:00:05 +0300
Date:   Thu, 1 Jul 2021 20:00:05 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@intel.com>
Subject: Re: [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
Message-ID: <YN30lZ1aC+KDpMWQ@intel.com>
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
 <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 09:07:27AM +0200, Maarten Lankhorst wrote:
> Op 30-06-2021 om 18:44 schreef Ville Syrjala:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> > The conversion to ww mutexes failed to address the fence code which
> > already returns -EDEADLK when we run out of fences. Ww mutexes on
> > the other hand treat -EDEADLK as an internal errno value indicating
> > a need to restart the operation due to a deadlock. So now when the
> > fence code returns -EDEADLK the higher level code erroneously
> > restarts everything instead of returning the error to userspace
> > as is expected.
> >
> > To remedy this let's switch the fence code to use a different errno
> > value for this. -ENOBUFS seems like a semi-reasonable unique choice.
> > Apart from igt the only user of this I could find is sna, and even
> > there all we do is dump the current fence registers from debugfs
> > into the X server log. So no user visible functionality is affected.
> > If we really cared about preserving this we could of course convert
> > back to -EDEADLK higher up, but doesn't seem like that's worth
> > the hassle here.
> >
> > Not quite sure which commit specifically broke this, but I'll
> > just attribute it to the general gem ww mutex work.
> >
> > Cc: stable@vger.kernel.org
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Thomas Hellström <thomas.hellstrom@intel.com>
> > Testcase: igt/gem_pread/exhaustion
> > Testcase: igt/gem_pwrite/basic-exhaustion
> > Testcase: igt/gem_fenced_exec_thrash/too-many-fences
> > Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww_ctx locking, v2.")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > index cac7f3f44642..f8948de72036 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > @@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i915_ggtt *ggtt)
> >  	if (intel_has_pending_fb_unpin(ggtt->vm.i915))
> >  		return ERR_PTR(-EAGAIN);
> >  
> > -	return ERR_PTR(-EDEADLK);
> > +	return ERR_PTR(-ENOBUFS);
> >  }
> >  
> >  int __i915_vma_pin_fence(struct i915_vma *vma)
> 
> Makes sense..
> 
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> 
> Is it a slightly more reent commit? Might probably be the part that converts execbuffer to use ww locks.

No idea about the specific commit since I've not actually bisected it.
It's just been bugging CI for quite a while now so figured I need to
fix it.

-- 
Ville Syrjälä
Intel
