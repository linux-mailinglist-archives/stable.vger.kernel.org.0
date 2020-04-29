Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A721BDFCB
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 15:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgD2N6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 09:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726861AbgD2N6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 09:58:53 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AEDC03C1AD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 06:58:52 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s10so2443823iln.11
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 06:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1O7PosLz4mRDhGws3L+X1MUCZvuGxL4YzOJRVMpkTaQ=;
        b=eHymAAQ8uzRRFuwbAgXByowyQhoNtG23MGeOnSLTjl2/c8/JVe4ByL+NwJ6d0kH2WZ
         cH9imCbJQlTtVEumzMzfu3Vmg4bscDair4bddYL3PX8zQTs9xjtntzNwMU+vGKKce8mm
         5tAzVF6M08PS+9lhmgMVNTF+CIWcaeUKT8jxSxFn+YW3/g522mEad+pYfkp8JY8jiJ/U
         Hyj1xYGuKuBX6spzc/xvgWwJ3tYSexAD59kI31CNFXRYk3TTnWBm7ZDx4DC4iKDjesn1
         372V+x3eNygxbsJEBk3AGHxmYeA2VWFWvaO2TG9E4ppTN31egitIgZvUWRTH5QQ1Ywi9
         0Row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1O7PosLz4mRDhGws3L+X1MUCZvuGxL4YzOJRVMpkTaQ=;
        b=TqTsYft0JMwNkvkFpgpkR0WAEITJuRK/uVA6Dnl7A5cFxucbmyEakZTg5PVdW8YYxj
         GjEEYmXwCnwX9sDm5d7fI8RtTav3THO7jlJnp8d0P4J+2QG2fmz6BfjNQ5SKsVCFbp/d
         SZsQiO17lIi4GiIFY5kXlXws3UORUOAZvcabytLCFmnK56onPFqCRJp7z1cLF6q/I3uf
         gj2zBBfAGpyOjKKYyEcEZ7CWj0FFlOo45AUzETDcXqIjAtSsZpM/hW3VJekcPY4WHKoU
         IMYWaV+MnYtAkAaFSXbFuiaiNV2/g6cpuzKVcXuNR5Br0gb1Km85stked6EN7vlriK1k
         XGfw==
X-Gm-Message-State: AGi0PuY3HRQRqtbUGHKLxcFXTqHIFGZkgRsWldy5tVoaiHWEWv0AuFmb
        fcJvf454RKoVWwGpYNonxL7KJ6tFxxFWfw8yhmktrQ==
X-Google-Smtp-Source: APiQypLvPs4AHWI9ET+b6eQtMWEOQRdpthQqZ/tzDRlMHD81VYVlfhcADQ6lPbGU3Ksruzumm/5mxiNG1yL3fqgBikU=
X-Received: by 2002:a92:dd0e:: with SMTP id n14mr31447370ilm.71.1588168732168;
 Wed, 29 Apr 2020 06:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200414184835.2878-1-sean@poorly.run> <20200414190258.38873-1-sean@poorly.run>
 <20200429135037.GF22816@intel.com>
In-Reply-To: <20200429135037.GF22816@intel.com>
From:   Sean Paul <sean@poorly.run>
Date:   Wed, 29 Apr 2020 09:58:16 -0400
Message-ID: <CAMavQKKOKfcJSN1GjKctQp4qw6LyP6WNE9Q3Y4LedkjzcvPXxA@mail.gmail.com>
Subject: Re: [PATCH v2] drm: Fix HDCP failures when SRM fw is missing
To:     Ramalingam C <ramalingam.c@intel.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sean Paul <seanpaul@chromium.org>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 9:50 AM Ramalingam C <ramalingam.c@intel.com> wrote:
>
> On 2020-04-14 at 15:02:55 -0400, Sean Paul wrote:
> > From: Sean Paul <seanpaul@chromium.org>
> >
> > The SRM cleanup in 79643fddd6eb2 ("drm/hdcp: optimizing the srm
> > handling") inadvertently altered the behavior of HDCP auth when
> > the SRM firmware is missing. Before that patch, missing SRM was
> > interpreted as the device having no revoked keys. With that patch,
> > if the SRM fw file is missing we reject _all_ keys.
> >
> > This patch fixes that regression by returning success if the file
> > cannot be found. It also checks the return value from request_srm such
> > that we won't end up trying to parse the ksv list if there is an error
> > fetching it.
> >
> > Fixes: 79643fddd6eb ("drm/hdcp: optimizing the srm handling")
> > Cc: stable@vger.kernel.org
> > Cc: Ramalingam C <ramalingam.c@intel.com>
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: dri-devel@lists.freedesktop.org
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> >
> > Changes in v2:
> > -Noticed a couple other things to clean up
> > ---
> >
> > Sorry for the quick rev, noticed a couple other loose ends that should
> > be cleaned up.
> >
> >  drivers/gpu/drm/drm_hdcp.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/drm_hdcp.c b/drivers/gpu/drm/drm_hdcp.c
> > index 7f386adcf872..910108ccaae1 100644
> > --- a/drivers/gpu/drm/drm_hdcp.c
> > +++ b/drivers/gpu/drm/drm_hdcp.c
> > @@ -241,8 +241,12 @@ static int drm_hdcp_request_srm(struct drm_device *drm_dev,
> >
> >       ret = request_firmware_direct(&fw, (const char *)fw_name,
> >                                     drm_dev->dev);
> > -     if (ret < 0)
> > +     if (ret < 0) {
> > +             *revoked_ksv_cnt = 0;
> > +             *revoked_ksv_list = NULL;
> These two variables are already initialized by the caller.

Right now it is, but that's not guaranteed. In the ret == 0 case, it's
pretty common for a caller to assume the called function has
validated/assigned all the function output.

> > +             ret = 0;
> Missing of this should have been caught by CI. May be CI system always
> having the SRM file from previous execution. Never been removed. IGT
> need a fix to clean the prior SRM files before execution.
>
> CI fix shouldn't block this fix.
> >               goto exit;
> > +     }
> >
> >       if (fw->size && fw->data)
> >               ret = drm_hdcp_srm_update(fw->data, fw->size, revoked_ksv_list,
> > @@ -287,6 +291,8 @@ int drm_hdcp_check_ksvs_revoked(struct drm_device *drm_dev, u8 *ksvs,
> >
> >       ret = drm_hdcp_request_srm(drm_dev, &revoked_ksv_list,
> >                                  &revoked_ksv_cnt);
> > +     if (ret)
> > +             return ret;
> This error code also shouldn't effect the caller(i915)

Why not? I'd assume an invalid SRM revocation list should probably be
treated as failure?


> hence pushed a
> change https://patchwork.freedesktop.org/series/76730/
>
> With these addresed.
>
> LGTM.
>
> Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
> >
> >       /* revoked_ksv_cnt will be zero when above function failed */
> >       for (i = 0; i < revoked_ksv_cnt; i++)
> > --
> > Sean Paul, Software Engineer, Google / Chromium OS
> >
