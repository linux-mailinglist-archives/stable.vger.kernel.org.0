Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA743CE0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFMPi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:38:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:30152 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfFMKFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 06:05:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 03:05:51 -0700
X-ExtLoop1: 1
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 13 Jun 2019 03:05:48 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 13 Jun 2019 13:05:47 +0300
Date:   Thu, 13 Jun 2019 13:05:47 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Clint Taylor <Clinton.A.Taylor@intel.com>,
        stable@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>,
        Hui Wang <hui.wang@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH stable-5.1 0/3] drm/i915: Prevent screen from flickering
 when the CDCLK changes
Message-ID: <20190613100547.GW5942@intel.com>
References: <20190603100938.5414-1-jian-hong@endlessm.com>
 <20190610060141.5377-1-jian-hong@endlessm.com>
 <20190613075256.GF19685@kroah.com>
 <CAPpJ_ecg1ERjrSYoB_Abuf2oy_Nay4sr3Bpb15OXRFbrXUW=6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPpJ_ecg1ERjrSYoB_Abuf2oy_Nay4sr3Bpb15OXRFbrXUW=6Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 04:37:48PM +0800, Jian-Hong Pan wrote:
> Greg KH <gregkh@linuxfoundation.org> 於 2019年6月13日 週四 下午3:52寫道：
> >
> > On Mon, Jun 10, 2019 at 02:01:39PM +0800, Jian-Hong Pan wrote:
> > > Hi,
> > >
> > > After apply the commit "drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
> > > power is enabled", it induces the screen to flicker when the CDCLK changes on
> > > the laptop like ASUS E406MA. [1]
> > >
> > > So, we need these commits to prevent that:
> > > commit 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> > > commit 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
> > > commit 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
> > >
> > > [1]: https://bugzilla.kernel.org/show_bug.cgi?id=203623#c12
> > >
> > > Jian-Hong Pan
> > >
> > > Imre Deak (2):
> > >   drm/i915: Save the old CDCLK atomic state
> > >   drm/i915: Remove redundant store of logical CDCLK state
> > >
> > > Ville Syrjälä (1):
> > >   drm/i915: Skip modeset for cdclk changes if possible
> > >
> > >  drivers/gpu/drm/i915/i915_drv.h      |   3 +-
> > >  drivers/gpu/drm/i915/intel_cdclk.c   | 155 ++++++++++++++++++++++-----
> > >  drivers/gpu/drm/i915/intel_display.c |  48 +++++++--
> > >  drivers/gpu/drm/i915/intel_drv.h     |  18 +++-
> > >  4 files changed, 186 insertions(+), 38 deletions(-)
> >
> > These are all big patches, I would like to get an ack from the i915
> > developer(s) that these are acceptable for the stable tree before
> > applying them...
> >
> > thanks,
> >
> > greg k-h
> 
> Hi Intel friends,
> 
> We have laptops like ASUS E406MA, which hits the issue: The audio
> playback does not work anymore after suspend & resume [1]
> Thanks for your contribution.  We found the commit "drm/i915: Force
> 2*96 MHz cdclk on glk/cnl when audio power is enabled" can fix it.
> But, it induces the screen to flicker when the CDCLK changes on.  So,
> we need these commits to be back ported to Linux stable 5.1.x tree to
> prevent flickering:

Pardon the delay.

Now that I refreshed my memory a bit I can't really see how
this could fix anything, except by luck. Before these patches
we always forced cdclk to be >=2*96 MHz so audio should never
have hit this particular problem.

The reason for adding this extra complexity was to claw back
a few milliwatts of power by allowing cdclk to drop below that
magic limit when audio isn't needed.

I *think* these patches should probably work in 5.1, but for
now I don't see this as anything more than bandaid for an
unknown issue somewhere else. So I'd rather like a new bug
filed at https://bugs.freedesktop.org/enter_bug.cgi?product=DRI&component=DRM/Intel
with a full dmesg with drm.debug=0xe (+ some audio debug
knob(s) which show when it's trying to poke the hw during
suspend/resume) attached.

> 
> 59f9e9cab3a1 drm/i915: Skip modeset for cdclk changes if possible
> 2b21dfbeee72 drm/i915: Remove redundant store of logical CDCLK state
> 48d9f87ddd21 drm/i915: Save the old CDCLK atomic state
> 905801fe7237 drm/i915: Force 2*96 MHz cdclk on glk/cnl when audio
> power is enabled
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=203623
> 
> May we have your comment or ack for the back port patches?
> https://www.spinics.net/lists/stable/msg308491.html
> https://www.spinics.net/lists/stable/msg310121.html
> https://www.spinics.net/lists/stable/msg310122.html
> https://www.spinics.net/lists/stable/msg310124.html
> https://www.spinics.net/lists/stable/msg310125.html
> 
> Thank you,
> Jian-Hong Pan

-- 
Ville Syrjälä
Intel
