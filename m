Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF706D29AB
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCaUwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 16:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCaUwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 16:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A6322214
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680295923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TExCraw6m8qeEuU/cKmvx3BPZJEqqAr20GEIk47fq4k=;
        b=Qr2871cXvrI53psf/bjoYgpVWzgUo/y8iNJAY/Ih7ZbmPiMYoguBUx9LFbMfUkSpvWc/qH
        Igi3p+h7hkJpRlRdX1dw5Y/fg0297JOaMu/vXVK7UW8ugY/Vfwk8WR+GWEHCenHlFuZcC2
        g/3r2Ioml2O2V3/uJrGwbhEOGp8xh34=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-Dm-zAKH5PimTL9iH4BnVMA-1; Fri, 31 Mar 2023 16:52:01 -0400
X-MC-Unique: Dm-zAKH5PimTL9iH4BnVMA-1
Received: by mail-qk1-f198.google.com with SMTP id 72-20020a37064b000000b007467c5d3abeso11042994qkg.19
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 13:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680295921;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TExCraw6m8qeEuU/cKmvx3BPZJEqqAr20GEIk47fq4k=;
        b=lUakO/vAqcx/7I5O/s/cvPtEqaTqzVyq70VZrJ/HsH9JwMAaTmHXk2OkxfRpLhTgtU
         fHR5MeQUC9S6qS3+wuLkLhFDi6pKer6B4oW9bh0zlhpb8TwAUW1LWClDnHP/aMqPr9Qe
         zB0WVdCf9hdCK+wSuxQJejYR1vEFptse+yUG2Hh8J9VLadNbP+mgopnVaJhg8kmoPcOe
         x1Vu4VO6Jt33yQZU1gS0+rQnMLpTvXZL8VgdQI5f4m6qmr9QSxiBF1r/6ooYMhHwKek5
         gMp+M3e73ssoOzXdGBpLVj/MGo0v2ZNQ4Fi3jns/ESqT0BlN2sbjpFu21JJhr0wrHrBg
         iBJQ==
X-Gm-Message-State: AAQBX9fiSnihjDJ2pjrhkOBVHWBa98SiLzvHOAoe5TUh1ODgRjFfMMst
        ynRkKMki0zDvQfk6lpGrUwXpiEce1YyuvyJonAvpSzvHFvQEvJGHJwNsMabqe2KcuKtGEplWL6C
        gXoHJ4Kt94v54tFI9
X-Received: by 2002:ad4:5de2:0:b0:5b5:a816:6b27 with SMTP id jn2-20020ad45de2000000b005b5a8166b27mr46860467qvb.8.1680295921458;
        Fri, 31 Mar 2023 13:52:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350a4BujdGcJ2iPES2jo4+UFcgXVDnbMTbMhCNXJcZZp/TV6Ekdjl4SHquQYXB/2xAlFP8ZOBGQ==
X-Received: by 2002:ad4:5de2:0:b0:5b5:a816:6b27 with SMTP id jn2-20020ad45de2000000b005b5a8166b27mr46860448qvb.8.1680295921187;
        Fri, 31 Mar 2023 13:52:01 -0700 (PDT)
Received: from ?IPv6:2600:4040:5c57:b700::feb? ([2600:4040:5c57:b700::feb])
        by smtp.gmail.com with ESMTPSA id bm20-20020a05620a199400b007435a646354sm939211qkb.0.2023.03.31.13.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 13:52:00 -0700 (PDT)
Message-ID: <286e8ae9c2bddf332e917b72178e0d4e82ab63cb.camel@redhat.com>
Subject: Re: [PATCH] drm/nouveau/disp: Support more modes by checking with
 lower bpc
From:   Lyude Paul <lyude@redhat.com>
To:     Karol Herbst <kherbst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
Date:   Fri, 31 Mar 2023 16:51:59 -0400
In-Reply-To: <20230330223938.4025569-1-kherbst@redhat.com>
References: <20230330223938.4025569-1-kherbst@redhat.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Fri, 2023-03-31 at 00:39 +0200, Karol Herbst wrote:
> This allows us to advertise more modes especially on HDR displays.
>=20
> Fixes using 4K@60 modes on my TV and main display both using a HDMI to DP
> adapter. Also fixes similiar issues for users running into this.
>=20
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Karol Herbst <kherbst@redhat.com>
> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 32 +++++++++++++++++++++++++
>  drivers/gpu/drm/nouveau/nouveau_dp.c    |  8 ++++---
>  2 files changed, 37 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/no=
uveau/dispnv50/disp.c
> index ed9d374147b8d..f28e47c161dd9 100644
> --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> @@ -363,6 +363,35 @@ nv50_outp_atomic_check_view(struct drm_encoder *enco=
der,
>  	return 0;
>  }
> =20
> +static void
> +nv50_outp_atomic_fix_depth(struct drm_encoder *encoder, struct drm_crtc_=
state *crtc_state)
> +{
> +	struct nv50_head_atom *asyh =3D nv50_head_atom(crtc_state);
> +	struct nouveau_encoder *nv_encoder =3D nouveau_encoder(encoder);
> +	struct drm_display_mode *mode =3D &asyh->state.adjusted_mode;
> +	unsigned int max_rate, mode_rate;
> +
> +	switch (nv_encoder->dcb->type) {
> +	case DCB_OUTPUT_DP:
> +		max_rate =3D nv_encoder->dp.link_nr * nv_encoder->dp.link_bw;
> +
> +                /* we don't support more than 10 anyway */
> +		asyh->or.bpc =3D max_t(u8, asyh->or.bpc, 10);
> +
> +		/* reduce the bpc until it works out */
> +		while (asyh->or.bpc > 6) {
> +			mode_rate =3D DIV_ROUND_UP(mode->clock * asyh->or.bpc * 3, 8);
> +			if (mode_rate <=3D max_rate)
> +				break;
> +
> +			asyh->or.bpc -=3D 2;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
>  static int
>  nv50_outp_atomic_check(struct drm_encoder *encoder,
>  		       struct drm_crtc_state *crtc_state,
> @@ -381,6 +410,9 @@ nv50_outp_atomic_check(struct drm_encoder *encoder,
>  	if (crtc_state->mode_changed || crtc_state->connectors_changed)
>  		asyh->or.bpc =3D connector->display_info.bpc;
> =20
> +	/* We might have to reduce the bpc */
> +	nv50_outp_atomic_fix_depth(encoder, crtc_state);
> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouve=
au/nouveau_dp.c
> index e00876f92aeea..d49b4875fc3c9 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dp.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
> @@ -263,8 +263,6 @@ nouveau_dp_irq(struct work_struct *work)
>  }
> =20
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
>  	const unsigned int min_clock =3D 25000;
>  	unsigned int max_rate, mode_rate, ds_max_dotclock, clock =3D mode->cloc=
k;
> -	const u8 bpp =3D connector->display_info.bpc * 3;
> +	/* Check with the minmum bpc always, so we can advertise better modes.
> +	 * In particlar not doing this causes modes to be dropped on HDR
> +	 * displays as we might check with a bpc of 16 even.
> +	 */
> +	const u8 bpp =3D 6 * 3;
> =20
>  	if (mode->flags & DRM_MODE_FLAG_INTERLACE && !outp->caps.dp_interlace)
>  		return MODE_NO_INTERLACE;

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

