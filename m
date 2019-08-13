Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF468ADE8
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 06:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfHMEjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 00:39:49 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:46394 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfHMEjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 00:39:49 -0400
Received: by mail-ua1-f67.google.com with SMTP id b41so3141297uad.13;
        Mon, 12 Aug 2019 21:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qCKnHreWojK5RwNrb4Am4EqgDEoPgcOXgABZDW2TdUI=;
        b=IWQDAJi5HAt1b+qr7sRzEWvpSY10qLjZga+DNHYEK299V5e3WdYBIUBjOz1DxHbolb
         akYX+a5yUMQ0nz6jlZkP41kgIcBkkuD9DtgP7CBpTcIVStiXPdiCsC1Z6E3xT1IzMz0s
         pmzPimE14K/pRfdKjAJBJaxASr4Dyx/g7Cd1tRBHDGrxKfz0ucHdPycDMh9053LlcoUH
         3kFZAvT6Al6dw+jVav4UBD2K58ytTABh+OFb0UQNQEauGIjgMjVOGuoBMV8u8nDgcv80
         Gs7iIxBdYSdy4T8V42zpdBIPZ0sLHITji8L3BtHXXxx4y8to51yNYJnkcgTzKo0C2fJc
         77Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qCKnHreWojK5RwNrb4Am4EqgDEoPgcOXgABZDW2TdUI=;
        b=IQKTPxTyWlzLHXpKTbiQ1Bvnjd03YO/y32YRTgB0iueR6sIPeBzO6v19uDWfzD5o1c
         QWdDCo6YskaDDbm/YqA/nxrCmb4UMxZAyTLLvDzIPsc9OOPZQFFU+EyiKidMRznXUMYV
         cYnVpamaamTY3yrQT7sqUzlx/xk6DbY7lWcUo8WtMUl3Biarlwo7zlzVfv0zyIUozHjK
         7D471LyEzyzd3VLmbGKksiQ4LTYnnn2Ho5XVbDvK92UBtC0zecUyNEGMBAIFYQEdWksR
         whsZOjKOZ6Oe49aDyyHMbZmRoTRb0F8iNSpQaAgmLGWyN13BfqwFMUVWE6sJ3N+6gYu/
         ZQmQ==
X-Gm-Message-State: APjAAAWdIRgSOy/OnIdedSqCePwXUQRnJ2FwuC+EviXtu7lg3TQ5gogQ
        FatLOyosPtXGcugHLt0Hz2NzlPyunerBF0qp4dE=
X-Google-Smtp-Source: APXvYqxe6D9OL+Toa4ztwqUqB/6+hbJt7cF2rk+1m8gIbOmafsFM+DOog8vVdKsKQYSALrZYizw4Q6CibEv92iIMv0E=
X-Received: by 2002:a9f:31cb:: with SMTP id w11mr7120341uad.40.1565671187831;
 Mon, 12 Aug 2019 21:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190809005307.18391-1-lyude@redhat.com>
In-Reply-To: <20190809005307.18391-1-lyude@redhat.com>
From:   Ben Skeggs <skeggsb@gmail.com>
Date:   Tue, 13 Aug 2019 14:39:36 +1000
Message-ID: <CACAvsv5Lj3nJRVQ1BsL5eVvCXvJD647PdZ5Hre_oYwd7ifNM7g@mail.gmail.com>
Subject: Re: [PATCH v2] drm/nouveau: Only recalculate PBN/VCPI on
 mode/connector changes
To:     Lyude Paul <lyude@redhat.com>
Cc:     ML nouveau <nouveau@lists.freedesktop.org>,
        Bohdan Milar <bmilar@redhat.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        William Lewis <minutemaidpark@hotmail.com>,
        stable@vger.kernel.org, Karol Herbst <karolherbst@gmail.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@redhat.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 9 Aug 2019 at 10:53, Lyude Paul <lyude@redhat.com> wrote:
>
> I -thought- I had fixed this entirely, but it looks like that I didn't
> test this thoroughly enough as we apparently still make one big mistake
> with nv50_msto_atomic_check() - we don't handle the following scenario:
>
> * CRTC #1 has n VCPI allocated to it, is attached to connector DP-4
>   which is attached to encoder #1. enabled=3Dy active=3Dn
> * CRTC #1 is changed from DP-4 to DP-5, causing:
>   * DP-4 crtc=3D#1=E2=86=92NULL (VCPI n=E2=86=920)
>   * DP-5 crtc=3DNULL=E2=86=92#1
>   * CRTC #1 steals encoder #1 back from DP-4 and gives it to DP-5
>   * CRTC #1 maintains the same mode as before, just with a different
>     connector
> * mode_changed=3Dn connectors_changed=3Dy
>   (we _SHOULD_ do VCPI 0=E2=86=92n here, but don't)
>
> Once the above scenario is repeated once, we'll attempt freeing VCPI
> from the connector that we didn't allocate due to the connectors
> changing, but the mode staying the same. Sigh.
>
> Since nv50_msto_atomic_check() has broken a few times now, let's rethink
> things a bit to be more careful: limit both VCPI/PBN allocations to
> mode_changed || connectors_changed, since neither VCPI or PBN should
> ever need to change outside of routing and mode changes.
>
> Changes since v1:
> * Fix accidental reversal of clock and bpp arguments in
>   drm_dp_calc_pbn_mode() - William Lewis
>
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Reported-by: Bohdan Milar <bmilar@redhat.com>
> Tested-by: Bohdan Milar <bmilar@redhat.com>
> Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
> References: 412e85b60531 ("drm/nouveau: Only release VCPI slots on mode c=
hanges")
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@redhat.com>
> Cc: Jerry Zuo <Jerry.Zuo@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Juston Li <juston.li@intel.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Karol Herbst <karolherbst@gmail.com>
> Cc: Ilia Mirkin <imirkin@alum.mit.edu>
> Cc: <stable@vger.kernel.org> # v5.1+
Acked-by: Ben Skeggs <bskeggs@redhat.com>

> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index 126703816794..5c36c75232e6 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -771,16 +771,20 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
>         struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
>         int slots;
>
> -       /* When restoring duplicated states, we need to make sure that th=
e
> -        * bw remains the same and avoid recalculating it, as the connect=
or's
> -        * bpc may have changed after the state was duplicated
> -        */
> -       if (!state->duplicated)
> -               asyh->dp.pbn =3D
> -                       drm_dp_calc_pbn_mode(crtc_state->adjusted_mode.cl=
ock,
> -                                            connector->display_info.bpc =
* 3);
> +       if (crtc_state->mode_changed || crtc_state->connectors_changed) {
> +               /*
> +                * When restoring duplicated states, we need to make sure=
 that
> +                * the bw remains the same and avoid recalculating it, as=
 the
> +                * connector's bpc may have changed after the state was
> +                * duplicated
> +                */
> +               if (!state->duplicated) {
> +                       const int bpp =3D connector->display_info.bpc * 3=
;
> +                       const int clock =3D crtc_state->adjusted_mode.clo=
ck;
> +
> +                       asyh->dp.pbn =3D drm_dp_calc_pbn_mode(clock, bpp)=
;
> +               }
>
> -       if (crtc_state->mode_changed) {
>                 slots =3D drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr=
,
>                                                       mstc->port,
>                                                       asyh->dp.pbn);
> --
> 2.21.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
