Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E191CDA16
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgEKMh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 08:37:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:52364 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbgEKMhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 08:37:25 -0400
IronPort-SDR: uBzVyiyIKN/ws5I3RcPjPq0sW5Puru0UskJvQNxZMxq99HwLrtpjnQhEv0Gh8pEwEvc0ptbDBo
 5yIF/MBAXvDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 05:37:21 -0700
IronPort-SDR: 89pvjIBQT6dfYxR71EyBPWacDiW2IkF9OUIip2wPXJMERKcxwVlaDcMwo7RipYYDAtzYY8/a76
 pp+WHbLWzmow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="306166876"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 11 May 2020 05:37:16 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 11 May 2020 15:37:15 +0300
Date:   Mon, 11 May 2020 15:37:15 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        stable <stable@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
Message-ID: <20200511123715.GI6112@intel.com>
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200417152310.GQ3456981@phenom.ffwll.local>
 <20200417154313.GO6112@intel.com>
 <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
 <20200417182834.GS6112@intel.com>
 <20200508170840.GE1219060@intel.com>
 <CAKMK7uHm+CmM6noHbMnmW9bSzk0dZ=9-CTpu+hxUwFbXmMkZ4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uHm+CmM6noHbMnmW9bSzk0dZ=9-CTpu+hxUwFbXmMkZ4g@mail.gmail.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 09, 2020 at 12:13:02PM +0200, Daniel Vetter wrote:
> On Fri, May 8, 2020 at 7:09 PM Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
> >
> > On Fri, Apr 17, 2020 at 09:28:34PM +0300, Ville Syrjälä wrote:
> > > On Fri, Apr 17, 2020 at 08:10:26PM +0200, Daniel Vetter wrote:
> > > > On Fri, Apr 17, 2020 at 5:43 PM Ville Syrjälä
> > > > <ville.syrjala@linux.intel.com> wrote:
> > > > >
> > > > > On Fri, Apr 17, 2020 at 05:23:10PM +0200, Daniel Vetter wrote:
> > > > > > On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> > > > > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > >
> > > > > > > Revert back to comparing fb->format->format instead fb->format for the
> > > > > > > page flip ioctl. This check was originally only here to disallow pixel
> > > > > > > format changes, but when we changed it to do the pointer comparison
> > > > > > > we potentially started to reject some (but definitely not all) modifier
> > > > > > > changes as well. In fact the current behaviour depends on whether the
> > > > > > > driver overrides the format info for a specific format+modifier combo.
> > > > > > > Eg. on i915 this now rejects compression vs. no compression changes but
> > > > > > > does not reject any other tiling changes. That's just inconsistent
> > > > > > > nonsense.
> > > > > > >
> > > > > > > The main reason we have to go back to the old behaviour is to fix page
> > > > > > > flipping with Xorg. At some point Xorg got its atomic rights taken away
> > > > > > > and since then we can't page flip between compressed and non-compressed
> > > > > > > fbs on i915. Currently we get no page flipping for any games pretty much
> > > > > > > since Mesa likes to use compressed buffers. Not sure how compositors are
> > > > > > > working around this (don't use one myself). I guess they must be doing
> > > > > > > something to get non-compressed buffers instead. Either that or
> > > > > > > somehow no one noticed the tearing from the blit fallback.
> > > > > >
> > > > > > Mesa only uses compressed buffers if you enable modifiers, and there's a
> > > > > > _loooooooooooot_ more that needs to be fixed in Xorg to enable that for
> > > > > > real. Like real atomic support.
> > > > >
> > > > > Why would you need atomic for modifiers? Xorg doesn't even have
> > > > > any sensible framework for atomic and I suspect it never will.
> > > >
> > > > Frankly if no one cares about atomic in X I don't think we should do
> > > > work-arounds for lack of atomic in X.
> > > >
> > > > > > Without modifiers all you get is X tiling,
> > > > > > and that works just fine.
> > > > > >
> > > > > > Which would also fix this issue here you're papering over.
> > > > > >
> > > > > > So if this is the entire reason for this, I'm inclined to not do this.
> > > > > > Current Xorg is toast wrt modifiers, that's not news.
> > > > >
> > > > > Works just fine. Also pretty sure modifiers are even enabled by
> > > > > default now in modesetting.
> > > >
> > > > Y/CSS is harder to scan out, you need to verify with TEST_ONLY whether
> > > > it works. Otherwise good chances for some oddball black screens on
> > > > configurations that worked before. Which is why all non-atomic
> > > > compositors reverted modifiers by default again.
> > >
> > > Y alone is hard to scanout also, and yet we do nothing to reject that.
> > > It's just an inconsistent mess.
> > >
> > > If we really want to keep this check then we should rewrite it
> > > to be explicit:
> > >
> > > if (old_fb->format->format != new_fb->format->format ||
> > >     is_ccs(old_fb->modifier) != is_ccs(new_fb->modifier))
> > >     return -EINVAL;
> > >
> > > Now it's just a random thing that may even stop doing what it's
> > > currently doing if anyone touches their .get_format_info()
> > > implementation.
> > >
> > > >
> > > > > And as stated the current check doesn't have consistent behaviour
> > > > > anyway. You can still flip between different modifiers as long a the
> > > > > driver doesn't override .get_format_info() for one of them. The *only*
> > > > > case where that happens is CCS on i915. There is no valid reason to
> > > > > special case that one.
> > > >
> > > > The thing is, you need atomic to make CCS work reliably enough for
> > > > compositors and distros to dare enabling it by default.
> > >
> > > If it's not enabled by default then there is no harm in letting people
> > > explicitly enable it and get better performance.
> > >
> > > > CCS flipping
> > > > works with atomic. I really see no point in baking this in with as
> > > > uapi.
> > >
> > > It's just going back to the original intention of the check.
> > > Heck, the debug message doesn't even match what it's doing now.
> > >
> > > > Just fix Xorg.
> > >
> > > Be serious. No one is going to rewrite all the randr code to be atomic.
> >
> > I fully understand Daniel's concern here, but I also believe this won't be
> > done so soon at least. Meanwhile would it be acceptable to have a comment
> > with the code /* XXX: Xorg blah... */ or /* FIXME: After Xorg blah.. */
> > ?
> 
> Here's a few numbers:
> 
> - skl shipped in Aug 2015, so about 5 years. Since then would we like
> to have modifiers enabled for intel, because it costs us quite a bit
> of performance. This isn't new at all.
> - the last Xorg release is from May 2018, so two years. Meanwhile even
> patches to fix some of the atomic mixups in -modesetting landed, but
> they never shipped so not useful.
> - I spent a few hours (which really is nothing) reading Xorg code
> yesterday, and I concur with Daniel Stone's napkin estimate that this
> will take about half to one year to fix properly. It's not happening,
> no one is working on that.
> 
> Conclusion: No one cares about modifiers on Xorg-modesetting. I don't
> see why the kernel should bend over for that.
> 
> Once that has changed (I'm not betting on that) and there's clear
> effort behind modifiers for Xorg-modesetting I guess we can look into
> stop-gap measures, but meanwhile the best imo is to not disturb the
> dead.

The alternative interpretation is that the current kernel code is
just nonsense, and since no one is depending on the current nonsense
behaviour we can safely change it it back to make sense.

Would allow people to at least test modifier plumbing via dri3/etc.
Also those of us who know what they're doing and want to actually
play games on Intel GPUs can flip it on for a a bit extra performance.
In the meantime I'll just have to keep carrying this patch in my own
kernels.

-- 
Ville Syrjälä
Intel
