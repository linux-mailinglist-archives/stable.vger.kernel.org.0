Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092596D2C0E
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 02:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbjDAAVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 20:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjDAAVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 20:21:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF821E716
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680308389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1akfVcI7QR7lEshuitx6obMsoCPveh68wJcZR6xPcO0=;
        b=GSuMFpwoC5DK4PS5l0AGdF5C1ZMkVMXhv3qudrHyo30thkK25KaQCQojDzzapA43joz2wt
        JpA1cK4tvJTpha4HMFfV1SYBjBg4U+jgci3IK9YlMh7eZO0U+xJGIjOowxVd2H5sMuh0jk
        mykA+khIa0DvtYn7PHRJD1XGrYxLChs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-nkyZh2omMCG0Bm7sHYNoLQ-1; Fri, 31 Mar 2023 20:19:48 -0400
X-MC-Unique: nkyZh2omMCG0Bm7sHYNoLQ-1
Received: by mail-lj1-f199.google.com with SMTP id t17-20020a05651c205100b0029f839410fcso5308704ljo.1
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:19:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680308386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1akfVcI7QR7lEshuitx6obMsoCPveh68wJcZR6xPcO0=;
        b=UI/DB8sTlQDH7VjtNq6gS+CmflBwEhKBFV3KK/ShvsfEti6HoIeB0f6aRQbLWry5qG
         1t0nVfiESPlxhEEINOBrmFTfPNF4yIrn804HzoP1vtsXRFuEeQQ3AlN2Tdc4r6cWJKl/
         mq3EHn9BlFYhgFIRFVUnIeJ3qmuCvCZVuRLEZvjHtRzkrvvr8ph/64TXXVcjydxWLx+l
         p/ruG7tlHOufEFvaTd/v0W39ypVCbO52MyhZaJuvaGlSn8BgoLJzGmNpObwth5NM5gPj
         WQnEbLMaVitTcXTHf8FZsESAdgjfcvSlYafYNRS8zQ0j1pYTVqwD/g3bROYQuwu7EIH0
         LB0Q==
X-Gm-Message-State: AAQBX9c4B0OiJ9uL/+4PG4DZ5QKlwcjLGEzquQXO6YVdTBThXJXB14MD
        dY9zG0fOjOYHPzh24Goc0sYu3qgRspj9gZvLwL6g6/GyGFgSt1eRlnT3wOf/257YUKY6AV26ePp
        sDeojKqXBxDHsxaITwyq39uqHm6Jp44QU
X-Received: by 2002:ac2:5448:0:b0:4e9:bcf5:a0b6 with SMTP id d8-20020ac25448000000b004e9bcf5a0b6mr8226772lfn.11.1680308386561;
        Fri, 31 Mar 2023 17:19:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350Ym6jp94Bk1kg399ONU4Y43W8m0No6VgXmQakZUMxIsdvzW+dZo3JC+oAnN0j7K8A6lQ3Sh1UTftySQqNEDppQ=
X-Received: by 2002:ac2:5448:0:b0:4e9:bcf5:a0b6 with SMTP id
 d8-20020ac25448000000b004e9bcf5a0b6mr8226765lfn.11.1680308386241; Fri, 31 Mar
 2023 17:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230330223938.4025569-1-kherbst@redhat.com>
In-Reply-To: <20230330223938.4025569-1-kherbst@redhat.com>
From:   Karol Herbst <kherbst@redhat.com>
Date:   Sat, 1 Apr 2023 02:19:34 +0200
Message-ID: <CACO55turFB8MNbxB3Vk=J1GK_t07K+Ybym906fR=yDLfnwk8bw@mail.gmail.com>
Subject: Re: [PATCH] drm/nouveau/disp: Support more modes by checking with
 lower bpc
To:     linux-kernel@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 12:39=E2=80=AFAM Karol Herbst <kherbst@redhat.com> =
wrote:
>
> This allows us to advertise more modes especially on HDR displays.
>
> Fixes using 4K@60 modes on my TV and main display both using a HDMI to DP
> adapter. Also fixes similiar issues for users running into this.
>
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Karol Herbst <kherbst@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 32 +++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_dp.c    |  8 ++++---
>  2 files changed, 37 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index ed9d374147b8d..f28e47c161dd9 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -363,6 +363,35 @@ nv50_outp_atomic_check_view(struct drm_encoder *enco=
der,
>         return 0;
>  }
>
> +static void
> +nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_=
state *crtc_state)
> +{
> +       struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
> +       struct nouveau_encoder *nv_encoder =3D nouveau_encoder(encoder);
> +       struct drm_display_mode *mode =3D &asyh->state.adjusted_mode;
> +       unsigned int max_rate, mode_rate;
> +
> +       switch (nv_encoder->dcb->type) {
> +       case DCB_OUTPUT_DP:
> +               max_rate =3D nv_encoder->dp.link_nr * nv_encoder->dp.link=
_bw;
> +
> +                /* we don't support more than 10 anyway */
> +               asyh->or.bpc =3D max_t(u8, asyh->or.bpc, 10);

luckily I didn't push yet, but this has to be `min_t` :)

> +
> +               /* reduce the bpc until it works out */
> +               while (asyh->or.bpc > 6) {
> +                       mode_rate =3D DIV_ROUND_UP(mode->clock * asyh->or=
.bpc * 3, 8);
> +                       if (mode_rate <=3D max_rate)
> +                               break;
> +
> +                       asyh->or.bpc -=3D 2;
> +               }
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
>  static int
>  nv50_outp_atomic_check(struct drm_encoder *encoder,
>                        struct drm_crtc_state *crtc_state,
> @@ -381,6 +410,9 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
>         if (crtc_state->mode_changed || crtc_state->connectors_changed)
>                 asyh->or.bpc =3D connector->display_info.bpc;
>
> +       /* We might have to reduce the bpc */
> +       nv50_outp_atomic_fix_depth(encoder, crtc_state);
> +
>         return 0;
>  }
>
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouve=
au/nouveau_dp.c
> index e00876f92aeea..d49b4875fc3c9 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dp.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
> @@ -263,8 +263,6 @@ nouveau_dp_irq(struct work_struct *work)
>  }
>
>  /* TODO:
> - * - Use the minimum possible BPC here, once we add support for the max =
bpc
> - *   property.
>   * - Validate against the DP caps advertised by the GPU (we don't check =
these
>   *   yet)
>   */
> @@ -276,7 +274,11 @@ nv50_dp_mode_valid(struct drm_connector *connector,
>  {
>         const unsigned int min_clock =3D 25000;
>         unsigned int max_rate, mode_rate, ds_max_dotclock, clock =3D mode=
->clock;
> -       const u8 bpp =3D connector->display_info.bpc * 3;
> +       /* Check with the minmum bpc always, so we can advertise better m=
odes.
> +        * In particlar not doing this causes modes to be dropped on HDR
> +        * displays as we might check with a bpc of 16 even.
> +        */
> +       const u8 bpp =3D 6 * 3;
>
>         if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_inter=
lace)
>                 return MODE_NO_INTERLACE;
> --
> 2.39.2
>

