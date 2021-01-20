Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1402FDA71
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 21:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbhATUKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 15:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389858AbhATOFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 09:05:51 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5CDC0613C1
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 06:05:11 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id d203so25108391oia.0
        for <stable@vger.kernel.org>; Wed, 20 Jan 2021 06:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=v0qGg49xcemOBrVvnnaWkXpY/JV5c3kQ4FhI1tZLljI=;
        b=Up4bCwslyUO1C38MQBy3fIDSbjU/4lFAxHitiUGJ4IJDcoR9rYcZX2pZirlZ8iEv9b
         rBVGzCViqGvaXL7pjzuRsEjf/vXQW/nIK3Bm4oMHl9AuLWfzlYbzyya/rXbcqJeQiyl8
         ngNpKZinV5kIxB4sVGTAaHUiBZ7y0FdoMXFr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=v0qGg49xcemOBrVvnnaWkXpY/JV5c3kQ4FhI1tZLljI=;
        b=R+CYWISQDl9yLGsRVHJWcnsYlmW4baLu7CYeoBKLKI1LgdZHbQh9ecJwzJx5mjbsIs
         saKDf+CxAgy0wRhMRRcjlfR7qaFyhBIPPMUbRRGn2VvKabbRIFKYxpFc11vhJBS7Cd/Y
         v7w4iwegayxf2qviwzpx8gGf1quJ2laUUlOm518ZWZivGzQzafydih8cKa4Lu3OskxPt
         6wmPqQyKQ45qWuQbvfYpWEVit/OXi+QzsuIcZLkG0z6S8K0kLeV6VW7DJZldPoBwow/l
         yEuv1gjFFrSTKYOqH3KgP3oxx+YMcJEk11c2apvBuSFrPcq9XobZiy0IAoQoiUHyUcH+
         j8mg==
X-Gm-Message-State: AOAM5326toX6T6YimTfKsOlpVd490MZtGQbvPcaMRABKc3ELV+wce5x5
        jbjbSTtTMvGJ0UNnhOk5+9gq5O0RPrte+UrH9C5C7A==
X-Google-Smtp-Source: ABdhPJy4wUehRTbpqEsfH4wUxDt6KdLiUIwx1fWbLM2A8Sh6vZbctMrLBY6UAx1C6E1Ip+PRi85OoS8WMyWH2YlYCA8=
X-Received: by 2002:aca:1906:: with SMTP id l6mr2902295oii.101.1611151510577;
 Wed, 20 Jan 2021 06:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20210120123535.40226-1-paul@crapouillou.net> <20210120123535.40226-3-paul@crapouillou.net>
 <CAKMK7uFaP7xcw90=KqiGJd7Mt-gD-spvcxvOZr2Txhyv5vcBvw@mail.gmail.com> <TFI8NQ.468S4PLHPA963@crapouillou.net>
In-Reply-To: <TFI8NQ.468S4PLHPA963@crapouillou.net>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 20 Jan 2021 15:04:59 +0100
Message-ID: <CAKMK7uEu7vWcJFC6S_hmKB4UMwPocwiOEy1iFnftOs5zfsRNYQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] drm/ingenic: Register devm action to cleanup encoders
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        od@zcrc.me, dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 2:21 PM Paul Cercueil <paul@crapouillou.net> wrote:
>
>
>
> Le mer. 20 janv. 2021 =C3=A0 14:01, Daniel Vetter <daniel@ffwll.ch> a
> =C3=A9crit :
> > On Wed, Jan 20, 2021 at 1:36 PM Paul Cercueil <paul@crapouillou.net>
> > wrote:
> >>
> >>  Since the encoders have been devm-allocated, they will be freed way
> >>  before drm_mode_config_cleanup() is called. To avoid use-after-free
> >>  conditions, we then must ensure that drm_encoder_cleanup() is called
> >>  before the encoders are freed.
> >>
> >>  v2: Use the new __drmm_simple_encoder_alloc() function
> >>
> >>  Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
> >>  Cc: <stable@vger.kernel.org> # 5.8+
> >>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> >>  ---
> >>
> >>  Notes:
> >>      Use the V1 of this patch to fix v5.11 and older kernels. This
> >> V2 only
> >>      applies on the current drm-misc-next branch.
> >>
> >>   drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 16 +++++++---------
> >>   1 file changed, 7 insertions(+), 9 deletions(-)
> >>
> >>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> >> b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> >>  index 7bb31fbee29d..158433b4c084 100644
> >>  --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> >>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> >>  @@ -1014,20 +1014,18 @@ static int ingenic_drm_bind(struct device
> >> *dev, bool has_components)
> >>                          bridge =3D
> >> devm_drm_panel_bridge_add_typed(dev, panel,
> >>
> >> DRM_MODE_CONNECTOR_DPI);
> >>
> >>  -               encoder =3D devm_kzalloc(dev, sizeof(*encoder),
> >> GFP_KERNEL);
> >>  -               if (!encoder)
> >>  -                       return -ENOMEM;
> >>  +               encoder =3D __drmm_simple_encoder_alloc(drm,
> >> sizeof(*encoder), 0,
> >
> > Please don't use the __ prefixed functions, those are the internal
> > ones. The official one comes with type checking and all that included.
> > Otherwise lgtm.
> > -Daniel
>
> The non-prefixed one assumes that I want to allocate a struct that
> contains the encoder, not just the drm_encoder itself.

Hm, but using the internal one is also a bit too ugly. A
drm_plain_simple_enocder_alloc(drm, type) wrapper would be the right
thing here I think? Setting the offsets and struct sizes directly in
these in drivers really doesn't feel like a good idea. I think simple
encoder is the only case where we really have a need for a
non-embeddable struct.
-Daniel

>
> -Paul
>
> >>  +
> >> DRM_MODE_ENCODER_DPI);
> >>  +               if (IS_ERR(encoder)) {
> >>  +                       ret =3D PTR_ERR(encoder);
> >>  +                       dev_err(dev, "Failed to init encoder:
> >> %d\n", ret);
> >>  +                       return ret;
> >>  +               }
> >>
> >>                  encoder->possible_crtcs =3D 1;
> >>
> >>                  drm_encoder_helper_add(encoder,
> >> &ingenic_drm_encoder_helper_funcs);
> >>
> >>  -               ret =3D drm_simple_encoder_init(drm, encoder,
> >> DRM_MODE_ENCODER_DPI);
> >>  -               if (ret) {
> >>  -                       dev_err(dev, "Failed to init encoder:
> >> %d\n", ret);
> >>  -                       return ret;
> >>  -               }
> >>  -
> >>                  ret =3D drm_bridge_attach(encoder, bridge, NULL, 0);
> >>                  if (ret) {
> >>                          dev_err(dev, "Unable to attach bridge\n");
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
