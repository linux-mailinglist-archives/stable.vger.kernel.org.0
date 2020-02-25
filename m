Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3016EA33
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 16:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbgBYPeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 10:34:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:18134 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730971AbgBYPeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 10:34:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 07:34:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,484,1574150400"; 
   d="scan'208";a="271349579"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga002.fm.intel.com with SMTP; 25 Feb 2020 07:34:00 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 25 Feb 2020 17:34:00 +0200
Date:   Tue, 25 Feb 2020 17:34:00 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniels@collabora.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm: avoid spurious EBUSY due to nonblocking
 atomic modesets
Message-ID: <20200225153400.GE13686@intel.com>
References: <20200225115024.2386811-1-daniel.vetter@ffwll.ch>
 <20200225144814.GC13686@intel.com>
 <CAKMK7uFKJd1G8qT2Kup8nOfp22V7eQmDZC=6bdU=UEpqO7K3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFKJd1G8qT2Kup8nOfp22V7eQmDZC=6bdU=UEpqO7K3QQ@mail.gmail.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 04:09:26PM +0100, Daniel Vetter wrote:
> On Tue, Feb 25, 2020 at 3:48 PM Ville Syrjälä
> <ville.syrjala@linux.intel.com> wrote:
> >
> > On Tue, Feb 25, 2020 at 12:50:24PM +0100, Daniel Vetter wrote:
> > > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > > pull in arbitrary other resources, including CRTCs (e.g. when
> > > reconfiguring global resources).
> > >
> > > But in nonblocking mode userspace has then no idea this happened,
> > > which can lead to spurious EBUSY calls, both:
> > > - when that other CRTC is currently busy doing a page_flip the
> > >   ALLOW_MODESET commit can fail with an EBUSY
> > > - on the other CRTC a normal atomic flip can fail with EBUSY because
> > >   of the additional commit inserted by the kernel without userspace's
> > >   knowledge
> > >
> > > For blocking commits this isn't a problem, because everyone else will
> > > just block until all the CRTC are reconfigured. Only thing userspace
> > > can notice is the dropped frames without any reason for why frames got
> > > dropped.
> > >
> > > Consensus is that we need new uapi to handle this properly, but no one
> > > has any idea what exactly the new uapi should look like. As a stop-gap
> > > plug this problem by demoting nonblocking commits which might cause
> > > issues by including CRTCs not in the original request to blocking
> > > commits.
> > >
> > > v2: Add comments and a WARN_ON to enforce this only when allowed - we
> > > don't want to silently convert page flips into blocking plane updates
> > > just because the driver is buggy.
> > >
> > > v3: Fix inverted WARN_ON (Pekka).
> > >
> > > References: https://lists.freedesktop.org/archives/dri-devel/2018-July/182281.html
> > > Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_9568
> > > Cc: Daniel Stone <daniel@fooishbar.org>
> > > Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Daniel Stone <daniels@collabora.com>
> > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > ---
> > >  drivers/gpu/drm/drm_atomic.c | 34 +++++++++++++++++++++++++++++++---
> > >  1 file changed, 31 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> > > index 9ccfbf213d72..4c035abf98b8 100644
> > > --- a/drivers/gpu/drm/drm_atomic.c
> > > +++ b/drivers/gpu/drm/drm_atomic.c
> > > @@ -1362,15 +1362,43 @@ EXPORT_SYMBOL(drm_atomic_commit);
> > >  int drm_atomic_nonblocking_commit(struct drm_atomic_state *state)
> > >  {
> > >       struct drm_mode_config *config = &state->dev->mode_config;
> > > -     int ret;
> > > +     unsigned requested_crtc = 0;
> > > +     unsigned affected_crtc = 0;
> > > +     struct drm_crtc *crtc;
> > > +     struct drm_crtc_state *crtc_state;
> > > +     bool nonblocking = true;
> > > +     int ret, i;
> > > +
> > > +     /*
> > > +      * For commits that allow modesets drivers can add other CRTCs to the
> > > +      * atomic commit, e.g. when they need to reallocate global resources.
> > > +      *
> > > +      * But when userspace also requests a nonblocking commit then userspace
> > > +      * cannot know that the commit affects other CRTCs, which can result in
> > > +      * spurious EBUSY failures. Until we have better uapi plug this by
> > > +      * demoting such commits to blocking mode.
> > > +      */
> > > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > > +             requested_crtc |= drm_crtc_mask(crtc);
> > >
> > >       ret = drm_atomic_check_only(state);
> > >       if (ret)
> > >               return ret;
> > >
> > > -     DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> > > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > > +             affected_crtc |= drm_crtc_mask(crtc);
> > > +
> > > +     if (affected_crtc != requested_crtc) {
> > > +             /* adding other CRTC is only allowed for modeset commits */
> > > +             WARN_ON(!state->allow_modeset);
> >
> > Not sure that's really true. What if the driver needs to eg.
> > redistribute FIFO space or something between the pipes? Or do we
> > expect drivers to now examine state->allow_modeset to figure out
> > if they're allowed to do certain things?
> 
> Maybe we need more fine-grained flags here, but adding other states
> (and blocking a commit flow) is exactly the uapi headaches this patch
> tries to solve here. So if our driver currently adds crtc states to
> reallocate fifo between pipes for an atomic flip then yes we're
> breaking userspace. Well, everyone figured out by now that you get
> random EBUSY and dropped frames for no apparent reason at all, and
> work around it. But happy, they are not.

I don't think we do this currently for the FIFO, but in theory we
could.

The one thing we might do currently is cdclk reprogramming, but that
can only happen without a full modeset when there's only a single
active pipe. So we shouldn't hit this right now. But that restriction
is going to disappear in the future, at which point we may want to
do this even with multiple active pipes.

-- 
Ville Syrjälä
Intel
