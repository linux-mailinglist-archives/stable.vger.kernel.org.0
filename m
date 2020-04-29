Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E5D1BE3A0
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD2QUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 12:20:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:50742 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgD2QUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 12:20:55 -0400
IronPort-SDR: 8nfW9rh/yfzivqOL+uRU1pHG29kpfnfvCQ7bLsCBwJvokLbT2e1JVnDkg28Rx/C7K++Bn4DTng
 GTpbagFz+ygQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 09:20:55 -0700
IronPort-SDR: ugVUPLvVADlePeBXXhDS8oWz/61Rpta7hDODI7ZxMbi0enp7zvcBAjLRcoGbYjTfUZIQVdm5UH
 0DzWWiU+c8Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="282553440"
Received: from ramaling-i9x.iind.intel.com (HELO intel.com) ([10.99.66.154])
  by fmsmga004.fm.intel.com with ESMTP; 29 Apr 2020 09:20:52 -0700
Date:   Wed, 29 Apr 2020 21:50:43 +0530
From:   Ramalingam C <ramalingam.c@intel.com>
To:     Sean Paul <sean@poorly.run>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sean Paul <seanpaul@chromium.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v2] drm: Fix HDCP failures when SRM fw is missing
Message-ID: <20200429162043.GH22816@intel.com>
References: <20200414184835.2878-1-sean@poorly.run>
 <20200414190258.38873-1-sean@poorly.run>
 <20200429135037.GF22816@intel.com>
 <CAMavQKKOKfcJSN1GjKctQp4qw6LyP6WNE9Q3Y4LedkjzcvPXxA@mail.gmail.com>
 <20200429142221.GG22816@intel.com>
 <CAMavQKJJ5h+v0_RQVh6Yanjsz=ZbDyo=5AFVgfrkJcTVjynz9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMavQKJJ5h+v0_RQVh6Yanjsz=ZbDyo=5AFVgfrkJcTVjynz9A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-29 at 10:46:29 -0400, Sean Paul wrote:
> On Wed, Apr 29, 2020 at 10:22 AM Ramalingam C <ramalingam.c@intel.com> wrote:
> >
> > On 2020-04-29 at 09:58:16 -0400, Sean Paul wrote:
> > > On Wed, Apr 29, 2020 at 9:50 AM Ramalingam C <ramalingam.c@intel.com> wrote:
> > > >
> > > > On 2020-04-14 at 15:02:55 -0400, Sean Paul wrote:
> > > > > From: Sean Paul <seanpaul@chromium.org>
> > > > >
> > > > > The SRM cleanup in 79643fddd6eb2 ("drm/hdcp: optimizing the srm
> > > > > handling") inadvertently altered the behavior of HDCP auth when
> > > > > the SRM firmware is missing. Before that patch, missing SRM was
> > > > > interpreted as the device having no revoked keys. With that patch,
> > > > > if the SRM fw file is missing we reject _all_ keys.
> > > > >
> > > > > This patch fixes that regression by returning success if the file
> > > > > cannot be found. It also checks the return value from request_srm such
> > > > > that we won't end up trying to parse the ksv list if there is an error
> > > > > fetching it.
> > > > >
> > > > > Fixes: 79643fddd6eb ("drm/hdcp: optimizing the srm handling")
> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: Ramalingam C <ramalingam.c@intel.com>
> > > > > Cc: Sean Paul <sean@poorly.run>
> > > > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > > > > Cc: David Airlie <airlied@linux.ie>
> > > > > Cc: Daniel Vetter <daniel@ffwll.ch>
> > > > > Cc: dri-devel@lists.freedesktop.org
> > > > > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > > > >
> > > > > Changes in v2:
> > > > > -Noticed a couple other things to clean up
> > > > > ---
> > > > >
> > > > > Sorry for the quick rev, noticed a couple other loose ends that should
> > > > > be cleaned up.
> > > > >
> > > > >  drivers/gpu/drm/drm_hdcp.c | 8 +++++++-
> > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/drm_hdcp.c b/drivers/gpu/drm/drm_hdcp.c
> > > > > index 7f386adcf872..910108ccaae1 100644
> > > > > --- a/drivers/gpu/drm/drm_hdcp.c
> > > > > +++ b/drivers/gpu/drm/drm_hdcp.c
> > > > > @@ -241,8 +241,12 @@ static int drm_hdcp_request_srm(struct drm_device *drm_dev,
> > > > >
> > > > >       ret = request_firmware_direct(&fw, (const char *)fw_name,
> > > > >                                     drm_dev->dev);
> > > > > -     if (ret < 0)
> > > > > +     if (ret < 0) {
> > > > > +             *revoked_ksv_cnt = 0;
> > > > > +             *revoked_ksv_list = NULL;
> > > > These two variables are already initialized by the caller.
> > >
> > > Right now it is, but that's not guaranteed. In the ret == 0 case, it's
> > > pretty common for a caller to assume the called function has
> > > validated/assigned all the function output.
> > Ok.
> > >
> > > > > +             ret = 0;
> > > > Missing of this should have been caught by CI. May be CI system always
> > > > having the SRM file from previous execution. Never been removed. IGT
> > > > need a fix to clean the prior SRM files before execution.
> > > >
> > > > CI fix shouldn't block this fix.
> > > > >               goto exit;
> > > > > +     }
> > > > >
> > > > >       if (fw->size && fw->data)
> > > > >               ret = drm_hdcp_srm_update(fw->data, fw->size, revoked_ksv_list,
> > > > > @@ -287,6 +291,8 @@ int drm_hdcp_check_ksvs_revoked(struct drm_device *drm_dev, u8 *ksvs,
> > > > >
> > > > >       ret = drm_hdcp_request_srm(drm_dev, &revoked_ksv_list,
> > > > >                                  &revoked_ksv_cnt);
> > > > > +     if (ret)
> > > > > +             return ret;
> > > > This error code also shouldn't effect the caller(i915)
> > >
> > > Why not? I'd assume an invalid SRM revocation list should probably be
> > > treated as failure?
> > IMHO invalid SRM revocation need not be treated as HDCP authentication
> > failure.
> >
> > First of all SRM need not supplied by all players. and incase, supplied
> > SRM is not as per the spec, then we dont have any list of revoked ID.
> > with this I dont think we need to fail the HDCP authentication. Until we
> > have valid list of revoked IDs from SRM, and the receiver ID is matching
> > to one of the revoked IDs, I wouldn't want to fail the HDCP
> > authentication.
> >
> 
> Ok, thanks for the explanation. This all seems reasonable to me.
> 
> Looks like this can be applied as-is, right?
Yes.

Thanks,
Ram

> I'll review the patch you
> posted so we can ignore the -ve return values.
> 
> Thanks for the review!
> 
> Sean
> 
> > -Ram
> > >
> > >
> > > > hence pushed a
> > > > change https://patchwork.freedesktop.org/series/76730/
> > > >
> > > > With these addresed.
> > > >
> > > > LGTM.
> > > >
> > > > Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
> > > > >
> > > > >       /* revoked_ksv_cnt will be zero when above function failed */
> > > > >       for (i = 0; i < revoked_ksv_cnt; i++)
> > > > > --
> > > > > Sean Paul, Software Engineer, Google / Chromium OS
> > > > >
