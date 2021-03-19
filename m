Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14DD342339
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhCSRZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 13:25:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhCSRZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 13:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616174716;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXLDsLPoubbGp67OogE9XornHlWLqBqoYkBToHUCuGI=;
        b=ibjph8URka3JRcX++jDSPg1zul+gSt8sGYqHJbyq++KSNBOmu4PtOND/aiJg36rpESVH55
        /9aFN2jgUwTGk/ju51AnssPtenza9tuNzyEqlwTiN15CUKTI8XXZUfdAYRcylK/rcsAE9v
        rt07hQF5SfmgUsgFYR00QKUsaBp9Rfc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-AeXmr4ntMGu1S7UzCxn60g-1; Fri, 19 Mar 2021 13:25:11 -0400
X-MC-Unique: AeXmr4ntMGu1S7UzCxn60g-1
Received: by mail-qt1-f197.google.com with SMTP id f26so296651qtq.17
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 10:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=CXLDsLPoubbGp67OogE9XornHlWLqBqoYkBToHUCuGI=;
        b=sTUR1tDNCxBRU8lrE0oXoKHbucZtUv/U3sWBI5DMunT8RKG0YmlLbBa3V43U56flXn
         nxbrd4Plcfl2uywdiwvqwmoiJyMlIXWwGqinqvLh8dQjTTrgBke7kWbeuWribD/RoMV8
         mEyFKz9TYhswXffU6QkjuuyYmaEYVCF/lxZmkD0x57ti4MhHsMtdjUxnCJjuEy4objRx
         ONjdeo1ZF97aDK5HVRZlda+9GAkeippa0Xy/2wCpSbThAT8OC0NuLfQxMWkhmhA7gJNq
         oUHbOSo9+AWUDIksA+ifMrCfsj9+pN8uzH65+9i6vOr2MvNfmc8LD48ktb/YOIplJRJq
         In+A==
X-Gm-Message-State: AOAM532DHDzEUMrHRVxwnrm9hzWSwlhfMgnrOC09yhzKzyc/+4zvC8r3
        jAc/XpMOMpb2yGXUgG5gDgbUk4TKW8UzwHJ89Vs/QpoIW1UnuFjslFnmoCss96FfdnzIw/MARAp
        iM2AG49tZucsz4blv
X-Received: by 2002:a05:620a:16dc:: with SMTP id a28mr10483836qkn.442.1616174711247;
        Fri, 19 Mar 2021 10:25:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2PNSNgacEAxGh8jQ+yratSe0lj4CTdS+H9WCqhb0qDBaoyoNsaXhesCCJsm0Js0YryqbGcw==
X-Received: by 2002:a05:620a:16dc:: with SMTP id a28mr10483806qkn.442.1616174711008;
        Fri, 19 Mar 2021 10:25:11 -0700 (PDT)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id 18sm5119562qkr.90.2021.03.19.10.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:25:09 -0700 (PDT)
Message-ID: <ce79f22e1f7f7e6bf4424e5f9d2d657d8215480d.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] drm/i915/ilk-glk: Fix link training on links
 with LTTPRs
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     imre.deak@intel.com,
        "Almahallawy, Khaled" <khaled.almahallawy@intel.com>
Cc:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mail@bodograumann.de" <mail@bodograumann.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "santiago.zarate@suse.com" <santiago.zarate@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Date:   Fri, 19 Mar 2021 13:25:08 -0400
In-Reply-To: <20210318231749.GA23036@ideak-desk.fi.intel.com>
References: <20210317184901.4029798-1-imre.deak@intel.com>
         <20210317184901.4029798-2-imre.deak@intel.com> <YFOO4FOmOB8yp3me@intel.com>
         <20210318174907.GE4128033@ideak-desk.fi.intel.com>
         <20210318180645.GG4128033@ideak-desk.fi.intel.com>
         <e1e9f9ea76071af914b37352fc201d09f378a55b.camel@intel.com>
         <20210318231749.GA23036@ideak-desk.fi.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-03-19 at 01:17 +0200, Imre Deak wrote:
> On Fri, Mar 19, 2021 at 12:04:54AM +0200, Almahallawy, Khaled wrote:
> > On Thu, 2021-03-18 at 20:06 +0200, Imre Deak wrote:
> > > On Thu, Mar 18, 2021 at 07:49:13PM +0200, Imre Deak wrote:
> > > > On Thu, Mar 18, 2021 at 07:33:20PM +0200, Ville Syrjälä wrote:
> > > > > On Wed, Mar 17, 2021 at 08:48:59PM +0200, Imre Deak wrote:
> > > > > > The spec requires to use at least 3.2ms for the AUX timeout
> > > > > > period if
> > > > > > there are LT-tunable PHY Repeaters on the link (2.11.2). An
> > > > > > upcoming
> > > > > > spec update makes this more specific, by requiring a 3.2ms
> > > > > > minimum
> > > > > > timeout period for the LTTPR detection reading the 0xF0000-
> > > > > > 0xF0007
> > > > > > range (3.6.5.1).
> > > > > 
> > > > > I'm pondering if we could reduce the timeout after having
> > > > > determined
> > > > > wherther LTTPRs are present or not? But maybe that wouldn't
> > > > > really speed
> > > > > up anything since we can't reduce the timeout until after
> > > > > detecting
> > > > > *something*. And once there is something there we shouldn't
> > > > > really get
> > > > > any more timeouts I guess. So probably a totally stupid idea.
> > > > 
> > > > Right, if something is connected it would take anyway as much time
> > > > as it
> > > > takes for the sink to reply whether or not we decreased the
> > > > timeout.
> > > > 
> > > > However if nothing is connected, we have the excessive timeout
> > > > Khaled
> > > > already noticed (160 * 4ms = 6.4 sec on ICL+). I think to improve
> > > > that
> > > > we could scale the total number of retries by making it
> > > > total_timeout/platform_specific_timeout (letting total_timeout=2sec
> > > > for
> > > > instance) or just changing the drm retry logic to be time based
> > > > instead
> > > > of the number of retries we use atm.
> > > 
> > > Doh, reducing simply the HW timeouts would be enough to fix this.
> > 
> > What about Lyude's suggestion (
> > https://patchwork.freedesktop.org/patch/420369/#comment_756572)
> > to drop the retries in intel_dp_aux_xfer()
> > /* Must try at least 3 times according to DP spec */
> > for (try = 0; try < 5; try++) {
> > 
> > And use only the retries in drm_dpcd_access?
> 
> I think it would work if we can make the retries configurable and set it
> to
>         retries = total_timeout / platform_specific_timeout_per_retry
> 
> where total_timeout would be something reasonable like 1 sec.

I actually think I'm more open to the idea of configurable retries after
learning that apparently this is a thing that the i2c subsystem does - so
there's more precedence for it in the rest of the kernel than I originally
thought.

I'm still curious if we need these extra retries in here though - there seems to
be one set of retries that is actually platform specific, and then just a random
set of 5 retries that don't seem to have anything to do with platform specific
behavior - so I think it'd still be worth giving a shot at getting rid of that

> 
> > 
> > Thanks
> > Khaled
> > 
> > > 
> > > > > Anyways, this seems about the only thing we can do given the
> > > > > limited
> > > > > hw capabilities.
> > > > > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > 
> > > > > > Accordingly disable LTTPR detection until GLK, where the
> > > > > > maximum timeout
> > > > > > we can set is only 1.6ms.
> > > > > > 
> > > > > > Link training in the non-transparent mode is known to fail at
> > > > > > least on
> > > > > > some SKL systems with a WD19 dock on the link, which exposes an
> > > > > > LTTPR
> > > > > > (see the References below). While this could have different
> > > > > > reasons
> > > > > > besides the too short AUX timeout used, not detecting LTTPRs
> > > > > > (and so not
> > > > > > using the non-transparent LT mode) fixes link training on these
> > > > > > systems.
> > > > > > 
> > > > > > While at it add a code comment about the platform specific
> > > > > > maximum
> > > > > > timeout values.
> > > > > > 
> > > > > > v2: Add a comment about the g4x maximum timeout as well.
> > > > > > (Ville)
> > > > > > 
> > > > > > Reported-by: Takashi Iwai <tiwai@suse.de>
> > > > > > Reported-and-tested-by: Santiago Zarate <
> > > > > > santiago.zarate@suse.com>
> > > > > > Reported-and-tested-by: Bodo Graumann <mail@bodograumann.de>
> > > > > > References:
> > > > > > https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> > > > > > Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent
> > > > > > mode link training")
> > > > > > Cc: <stable@vger.kernel.org> # v5.11
> > > > > > Cc: Takashi Iwai <tiwai@suse.de>
> > > > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > > > > ---
> > > > > >  drivers/gpu/drm/i915/display/intel_dp_aux.c       |  7 +++++++
> > > > > >  .../gpu/drm/i915/display/intel_dp_link_training.c | 15
> > > > > > ++++++++++++---
> > > > > >  2 files changed, 19 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > index eaebf123310a..10fe17b7280d 100644
> > > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > @@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct
> > > > > > intel_dp *intel_dp,
> > > > > >  else
> > > > > >  precharge = 5;
> > > > > > 
> > > > > > +/* Max timeout value on G4x-BDW: 1.6ms */
> > > > > >  if (IS_BROADWELL(dev_priv))
> > > > > >  timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
> > > > > >  else
> > > > > > @@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct
> > > > > > intel_dp *intel_dp,
> > > > > >  enum phy phy = intel_port_to_phy(i915, dig_port-
> > > > > > > base.port);
> > > > > >  u32 ret;
> > > > > > 
> > > > > > +/*
> > > > > > + * Max timeout values:
> > > > > > + * SKL-GLK: 1.6ms
> > > > > > + * CNL: 3.2ms
> > > > > > + * ICL+: 4ms
> > > > > > + */
> > > > > >  ret = DP_AUX_CH_CTL_SEND_BUSY |
> > > > > >        DP_AUX_CH_CTL_DONE |
> > > > > >        DP_AUX_CH_CTL_INTERRUPT |
> > > > > > diff --git
> > > > > > a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > > b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > > index 19ba7c7cbaab..c0e25c75c105 100644
> > > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > > @@ -82,6 +82,18 @@ static void
> > > > > > intel_dp_read_lttpr_phy_caps(struct intel_dp *intel_dp,
> > > > > > 
> > > > > >  static bool intel_dp_read_lttpr_common_caps(struct intel_dp
> > > > > > *intel_dp)
> > > > > >  {
> > > > > > +struct drm_i915_private *i915 = dp_to_i915(intel_dp);
> > > > > > +
> > > > > > +if (intel_dp_is_edp(intel_dp))
> > > > > > +return false;
> > > > > > +
> > > > > > +/*
> > > > > > + * Detecting LTTPRs must be avoided on platforms with
> > > > > > an AUX timeout
> > > > > > + * period < 3.2ms. (see DP Standard v2.0, 2.11.2,
> > > > > > 3.6.6.1).
> > > > > > + */
> > > > > > +if (INTEL_GEN(i915) < 10)
> > > > > > +return false;
> > > > > > +
> > > > > >  if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
> > > > > >    intel_dp-
> > > > > > > lttpr_common_caps) < 0) {
> > > > > >  memset(intel_dp->lttpr_common_caps, 0,
> > > > > > @@ -127,9 +139,6 @@ int intel_dp_lttpr_init(struct intel_dp
> > > > > > *intel_dp)
> > > > > >  bool ret;
> > > > > >  int i;
> > > > > > 
> > > > > > -if (intel_dp_is_edp(intel_dp))
> > > > > > -return 0;
> > > > > > -
> > > > > >  ret = intel_dp_read_lttpr_common_caps(intel_dp);
> > > > > >  if (!ret)
> > > > > >  return 0;
> > > > > > --
> > > > > > 2.25.1
> > > > > 
> > > > > --
> > > > > Ville Syrjälä
> > > > > Intel
> 

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

