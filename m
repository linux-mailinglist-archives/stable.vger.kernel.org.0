Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5692FA07D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391925AbhARMxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391922AbhARMxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 07:53:39 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC410C061574
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 04:52:58 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d13so16314775wrc.13
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 04:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=D1pyQppAA+wvHZoSq97i6wx6SxOqkfmcx7zBXfJmsUE=;
        b=ccLPRV7H6TPy5FaDHa6HRufGAmVTtUcPP0aNjYLtg7BXTDqPoAL1KqRBVJ8YssQe/q
         SkJeenWJs9M0OHU4D60tMaVsxRqbR/TpwkR+twarnfpbxmrItmT+5oZs954YiaGq4t7K
         mo2P5xg0rwUDd3yTU/qU14hKBc4MKtJOwKmPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=D1pyQppAA+wvHZoSq97i6wx6SxOqkfmcx7zBXfJmsUE=;
        b=JxIBbyRz59p7efbmZyDKkVqcwYQ0smC0u3hmubyN6ewoJDyuy/f73BlmTCytV1Qqr0
         xOLvqE0uWgquPAxmPOF1CLmA7d+yY7DctwcpKwEFyUjeDH6PD30dUzeA00sXQ+OmzonF
         MOz8BOXy7+M6M6IDLEMTnz3ZNr25fvSvh1T7UadERKhVz+7Kd7NJUbTRmjlh+fX76Tlp
         6T4fgNDGrHccfYUt+tvXGeJo1I3EV3D/KYW6Yt19cDl/DG6betchAS7ZqRJNbcA57z4b
         JDPLCiWniF+7Xdq5QzvjHCoHzqg++D3JnhYgHT+1bQPEU7zU+eEg4kXo5dtv6FelpaPJ
         IvhA==
X-Gm-Message-State: AOAM531spRJ7H3QoF6mK7Y6LRjsZnBAnkhL/f0RUrrpmBc/wEbAREaWD
        RHBXyxRxP/eGFgw3CEiHr5AkxA==
X-Google-Smtp-Source: ABdhPJzxIHaZac3kc6pq7MGlzbkyFJIIStSfDrlGhD0mywUk57483NkSG1rJNT2xYmJt1OLnql1nDQ==
X-Received: by 2002:adf:f4d0:: with SMTP id h16mr26228451wrp.30.1610974377438;
        Mon, 18 Jan 2021 04:52:57 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id i18sm30793367wrp.74.2021.01.18.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 04:52:56 -0800 (PST)
Date:   Mon, 18 Jan 2021 13:52:54 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, od@zcrc.me,
        dri-devel@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/3] drm/ingenic: Register devm action to cleanup encoders
Message-ID: <YAWEpjU6BmeK8deo@phenom.ffwll.local>
Mail-Followup-To: Paul Cercueil <paul@crapouillou.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, od@zcrc.me, dri-devel@lists.freedesktop.org,
        Sam Ravnborg <sam@ravnborg.org>
References: <20210117112646.98353-1-paul@crapouillou.net>
 <20210117112646.98353-3-paul@crapouillou.net>
 <YAVYUzR9+ic5lEjE@pendragon.ideasonboard.com>
 <1BO4NQ.1RZAXLMVC01T@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1BO4NQ.1RZAXLMVC01T@crapouillou.net>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 18, 2021 at 11:37:49AM +0000, Paul Cercueil wrote:
> Hi Laurent,
> 
> Le lun. 18 janv. 2021 à 11:43, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> a écrit :
> > Hi Paul,
> > 
> > Thank you for the patch.
> > 
> > On Sun, Jan 17, 2021 at 11:26:45AM +0000, Paul Cercueil wrote:
> > >  Since the encoders have been devm-allocated, they will be freed way
> > >  before drm_mode_config_cleanup() is called. To avoid use-after-free
> > >  conditions, we then must ensure that drm_encoder_cleanup() is called
> > >  before the encoders are freed.
> > 
> > How about allocating the encoder with drmm_encoder_alloc() instead ?
> 
> That would work, but it is not yet in drm-misc-fixes :(

Well I think then we should only fix this in drm-misc-next. Adding more
broken usage of devm_ isn't really a good idea.

If you want this in -fixes, then I think hand-roll it. But devm_ for drm
objects really is the wrong fix.
-Daniel

> 
> -Paul
> 
> > >  Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
> > >  Cc: <stable@vger.kernel.org> # 5.8+
> > >  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > >  ---
> > >   drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > > 
> > >  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > > b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > >  index 368bfef8b340..d23a3292a0e0 100644
> > >  --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > >  +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> > >  @@ -803,6 +803,11 @@ static void __maybe_unused
> > > ingenic_drm_release_rmem(void *d)
> > >   	of_reserved_mem_device_release(d);
> > >   }
> > > 
> > >  +static void ingenic_drm_encoder_cleanup(void *encoder)
> > >  +{
> > >  +	drm_encoder_cleanup(encoder);
> > >  +}
> > >  +
> > >   static int ingenic_drm_bind(struct device *dev, bool
> > > has_components)
> > >   {
> > >   	struct platform_device *pdev = to_platform_device(dev);
> > >  @@ -1011,6 +1016,11 @@ static int ingenic_drm_bind(struct device
> > > *dev, bool has_components)
> > >   			return ret;
> > >   		}
> > > 
> > >  +		ret = devm_add_action_or_reset(dev, ingenic_drm_encoder_cleanup,
> > >  +					       encoder);
> > >  +		if (ret)
> > >  +			return ret;
> > >  +
> > >   		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
> > >   		if (ret) {
> > >   			dev_err(dev, "Unable to attach bridge\n");
> > 
> > --
> > Regards,
> > 
> > Laurent Pinchart
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
