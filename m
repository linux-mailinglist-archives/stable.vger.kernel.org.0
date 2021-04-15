Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC636084E
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 13:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDOLeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 07:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhDOLeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 07:34:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1929FC061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 04:33:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n127so500090wmb.5
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 04:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=13k+njGV2uKvtcoZVwTEnL8TyFMpsUTPjBtwvKMVIn0=;
        b=FA7sBqmNPXF8L1IJzMBiC1C+03+99yGRO7xmwzxSHEiQO8dF+RyiqtUv473TRBl9DJ
         ofy6vPj3WsLHCTJkVa/VA3GEbj+z04eJQju/RlhR1oPO7IJ+o65MGBUxf1pKuQFxfVJw
         KoqsWiC/bAs3ilsn2Nalfni+TyiMXOfAvpvqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=13k+njGV2uKvtcoZVwTEnL8TyFMpsUTPjBtwvKMVIn0=;
        b=r+xf7C3mHqZZ463vFmm5YOmbAELbrW4dR6Fw+VnOHVX969xrbBkOVMXuaEl8p6IETX
         07UuiDZbYXiXdcgKHBEqpKnah+o1M7uZYLE6nAD3vVNzGidYRuh/CX1Vb4Q7ky89/fTH
         C8DEWFrs72nBRcY31PnlF/E8TyPwZgxnfTMSIMKdXZ1v9wHnP/6q7ZHE1BSgmTfz9WlU
         dF5/GJfOxVVhI/1cn5AGZkPgkMiWx2j7F+KcFi+Zb8biCLdTvYSdlpk1B3RQG/h9P4Oo
         JCV+71hQJgbz4HfddLE0Da/pL62CxXuEpgAdsunE+7gjgzSzhcV8WT4LmV1ljrE5dW8L
         +SGA==
X-Gm-Message-State: AOAM530GA+VMPCrT05GEzPebwAw7SHtyxvZWM9Q4vTle6gRK+d/Cfgoh
        zL/9ZnSFwoDW9HpDwhutZ3rs5Q==
X-Google-Smtp-Source: ABdhPJwTws/OP8YfTa+zhDBcdtMyEgxr2rTeY9T3TS8womfbkDSVJm6xM69NBHRm4ORd7JehhSwcVQ==
X-Received: by 2002:a1c:2985:: with SMTP id p127mr2679848wmp.165.1618486429812;
        Thu, 15 Apr 2021 04:33:49 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id a22sm2431649wrc.59.2021.04.15.04.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 04:33:48 -0700 (PDT)
Date:   Thu, 15 Apr 2021 13:33:46 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 10/12] drm/tegra: Don't set allow_fb_modifiers explicitly
Message-ID: <YHgkmgsvBmMXiHTr@phenom.ffwll.local>
References: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
 <20210413094904.3736372-10-daniel.vetter@ffwll.ch>
 <YHWCgpq5fVpSGdSN@orome.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHWCgpq5fVpSGdSN@orome.fritz.box>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 01:37:38PM +0200, Thierry Reding wrote:
> On Tue, Apr 13, 2021 at 11:49:01AM +0200, Daniel Vetter wrote:
> > Since
> > 
> > commit 890880ddfdbe256083170866e49c87618b706ac7
> > Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > Date:   Fri Jan 4 09:56:10 2019 +0100
> > 
> >     drm: Auto-set allow_fb_modifiers when given modifiers at plane init
> > 
> > this is done automatically as part of plane init, if drivers set the
> > modifier list correctly. Which is the case here.
> > 
> > It was slightly inconsistently though, since planes with only linear
> > modifier support haven't listed that explicitly. Fix that, and cc:
> > stable to allow userspace to rely on this. Again don't backport
> > further than where Paul's patch got added.
> > 
> > Cc: stable@vger.kernel.org # v5.1 +
> > Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Jonathan Hunter <jonathanh@nvidia.com>
> > Cc: linux-tegra@vger.kernel.org
> > ---
> >  drivers/gpu/drm/tegra/dc.c  | 10 ++++++++--
> >  drivers/gpu/drm/tegra/drm.c |  2 --
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> > index c9385cfd0fc1..f9845a50f866 100644
> > --- a/drivers/gpu/drm/tegra/dc.c
> > +++ b/drivers/gpu/drm/tegra/dc.c
> > @@ -959,6 +959,11 @@ static const struct drm_plane_helper_funcs tegra_cursor_plane_helper_funcs = {
> >  	.atomic_disable = tegra_cursor_atomic_disable,
> >  };
> >  
> > +static const uint64_t linear_modifiers[] = {
> > +	DRM_FORMAT_MOD_LINEAR,
> > +	DRM_FORMAT_MOD_INVALID
> > +};
> > +
> >  static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
> >  						      struct tegra_dc *dc)
> >  {
> > @@ -987,7 +992,7 @@ static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
> >  
> >  	err = drm_universal_plane_init(drm, &plane->base, possible_crtcs,
> >  				       &tegra_plane_funcs, formats,
> > -				       num_formats, NULL,
> > +				       num_formats, linear_modifiers,
> >  				       DRM_PLANE_TYPE_CURSOR, NULL);
> >  	if (err < 0) {
> >  		kfree(plane);
> > @@ -1106,7 +1111,8 @@ static struct drm_plane *tegra_dc_overlay_plane_create(struct drm_device *drm,
> >  
> >  	err = drm_universal_plane_init(drm, &plane->base, possible_crtcs,
> >  				       &tegra_plane_funcs, formats,
> > -				       num_formats, NULL, type, NULL);
> > +				       num_formats, linear_modifiers,
> > +				       type, NULL);
> 
> I think we can do better than linear_modifiers for overlay planes, but
> given that this doesn't change existing behaviour, I'll do that in a
> separate patch.
> 
> Acked-by: Thierry Reding <treding@nvidia.com>

Applied to drm-misc-next, thanks for taking a look.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
