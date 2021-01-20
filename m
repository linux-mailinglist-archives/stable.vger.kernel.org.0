Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A8C2FD9D3
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhATSop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 13:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732890AbhATRi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 12:38:56 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73DDC061757
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 09:38:15 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n42so24108565ota.12
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 09:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MNhh3DZneZFVWfjxYIARFu1yzUnEDm7HphLodqo3DQk=;
        b=b3rRh/jJExyI8+DPE2UALXm6/mFfCwwF0E489at7YF/FdDDs0G59cic92B9HOqPYkn
         i6Ke9a/H8crN4utU/49/HEC+QiHzShWj0IbERe//iYPc/9zNyUUpHrEorXkfeSdsJ1j+
         ioxRKAxIg8/yTdUpMKiCa5gZBnHCO8HcDx4+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MNhh3DZneZFVWfjxYIARFu1yzUnEDm7HphLodqo3DQk=;
        b=YWdG0/vdIRuM4fWPoKrWakW5xsZsG1OjFqVTBSWbX2hIWxouxLqjiUrfeRsQEtmDAb
         4HwhtktTFQdBq8oDWcNoqA5fFPwu+VjPQ7SbDTGo3YQcU6U9b+WrIm6ZP1Vu+Q7mh8Yw
         woupMjAmWuuDcn+RPdqzwDAvVFEIaHTcqmYtA7qdySsGPGD0ncxbQlepNiXRnEfVttzX
         YWWR7labl3F4/Tfvm+oFzDBddR6EKEjNQY1qx5VDfIb3IxQ11F7avJQgNMNqiA567GlH
         yHbO5ryCU175f9FHngS6YB5D8JeiVltp4GyMoIAYbW4+KZgpWZKzes8aNFExVLXf06jn
         zCMw==
X-Gm-Message-State: AOAM530NU5oCrSMVRG+XAgZYPjX6O3qYOvD2OhYHH12MxHGAV+nVz1uR
        /MtKeVQLpbfeqghUEDvpcef2S6p17Ghy5TNKOdcwUd6G7bE=
X-Google-Smtp-Source: ABdhPJxv43HxmTetCKsV75E7UstyzxmA3kKBQo3KsMDk26idvuSiiEtoQRKDJaZO3thYnbrqW0w9yXakr98YoMiThxM=
X-Received: by 2002:a05:6830:1bef:: with SMTP id k15mr7621513otb.303.1611164294761;
 Wed, 20 Jan 2021 09:38:14 -0800 (PST)
MIME-Version: 1.0
References: <20210120123535.40226-1-paul@crapouillou.net> <20210120123535.40226-2-paul@crapouillou.net>
 <CAKMK7uGGDe8bZpeTnyCkF7g_2gC1nixOzWe4FWYXPRWi-q5y7A@mail.gmail.com> <4YQ8NQ.HNQ7IMBKVEBV2@crapouillou.net>
In-Reply-To: <4YQ8NQ.HNQ7IMBKVEBV2@crapouillou.net>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 20 Jan 2021 18:38:03 +0100
Message-ID: <CAKMK7uFHYPvJm46f-LXBO=nERGBBO3i_=YXZyAUi0ZXJFLmXVw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] drm: bridge/panel: Cleanup connector on bridge detach
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 6:12 PM Paul Cercueil <paul@crapouillou.net> wrote:
>
>
>
> Le mer. 20 janv. 2021 =C3=A0 17:03, Daniel Vetter <daniel@ffwll.ch> a
> =C3=A9crit :
> > On Wed, Jan 20, 2021 at 1:35 PM Paul Cercueil <paul@crapouillou.net>
> > wrote:
> >>
> >>  If we don't call drm_connector_cleanup() manually in
> >>  panel_bridge_detach(), the connector will be cleaned up with the
> >> other
> >>  DRM objects in the call to drm_mode_config_cleanup(). However,
> >> since our
> >>  drm_connector is devm-allocated, by the time
> >> drm_mode_config_cleanup()
> >>  will be called, our connector will be long gone. Therefore, the
> >>  connector must be cleaned up when the bridge is detached to avoid
> >>  use-after-free conditions.
> >
> > For -fixes this sounds ok, but for -next I think switching to drmm_
> > would be much better.
>
> The API would need to change to have access to the drm_device struct,
> though. That would be quite a big patch, there are a few dozens source
> files that use this API already.

Hm right pure drmm_ doesn't work for panel or bridge since it's
usually a separate driver. But devm_ also doesn't work. I think what
we need here is two-stage: first kmalloc the panel (or bridge, it's
really the same) in the panel/bridge driver load. Then when we bind it
to the drm_device we can tie it into the managed resources with
drmm_add_action_or_reset. Passing the drm_device to the point where we
allocate the panel/bridge doesn't work for these.

I think minimally we need a FIXME here and ack from Laurent on how
this should be solved at least, since panel bridge is used rather
widely.
-Daniel

>
> Cheers,
> -Paul
>
> >
> >>  v2: Cleanup connector only if it was created
> >>
> >>  Fixes: 13dfc0540a57 ("drm/bridge: Refactor out the panel wrapper
> >> from the lvds-encoder bridge.")
> >>  Cc: <stable@vger.kernel.org> # 4.12+
> >>  Cc: Andrzej Hajda <a.hajda@samsung.com>
> >>  Cc: Neil Armstrong <narmstrong@baylibre.com>
> >>  Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> >>  Cc: Jonas Karlman <jonas@kwiboo.se>
> >>  Cc: Jernej Skrabec <jernej.skrabec@siol.net>
> >>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> >>  ---
> >>   drivers/gpu/drm/bridge/panel.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >>  diff --git a/drivers/gpu/drm/bridge/panel.c
> >> b/drivers/gpu/drm/bridge/panel.c
> >>  index 0ddc37551194..df86b0ee0549 100644
> >>  --- a/drivers/gpu/drm/bridge/panel.c
> >>  +++ b/drivers/gpu/drm/bridge/panel.c
> >>  @@ -87,6 +87,12 @@ static int panel_bridge_attach(struct drm_bridge
> >> *bridge,
> >>
> >>   static void panel_bridge_detach(struct drm_bridge *bridge)
> >>   {
> >>  +       struct panel_bridge *panel_bridge =3D
> >> drm_bridge_to_panel_bridge(bridge);
> >>  +       struct drm_connector *connector =3D &panel_bridge->connector;
> >>  +
> >>  +       /* Cleanup the connector if we know it was initialized */
> >>  +       if (!!panel_bridge->connector.dev)
> >>  +               drm_connector_cleanup(connector);
> >>   }
> >>
> >>   static void panel_bridge_pre_enable(struct drm_bridge *bridge)
> >>  --
> >>  2.29.2
> >>
> >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
>
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
