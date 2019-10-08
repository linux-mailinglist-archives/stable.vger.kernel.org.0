Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD6CFB71
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 15:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfJHNho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 09:37:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42692 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfJHNho (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 09:37:44 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 32451803D4; Tue,  8 Oct 2019 15:37:27 +0200 (CEST)
Date:   Tue, 8 Oct 2019 15:37:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charlene Liu <charlene.liu@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 033/106] drm/amd/display: support spdif
Message-ID: <20191008133741.GG608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171140.114447492@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <20191006171140.114447492@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b5a41620bb88efb9fb31a4fa5e652e3d5bead7d4 ]
>=20
> [Description]
> port spdif fix to staging:
>  spdif hardwired to afmt inst 1.
>  spdif func pointer
>  spdif resource allocation (reserve last audio endpoint for spdif only)

I'm sorry, but I don't understand this changelog. Code below modifies
whitespace, adds a debug output, and uses local variable for
pool->audio_count.

Does not seem to be a bugfix, and does not seem to do anything with
staging.

Best regards,
								Pavel


> +++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
> @@ -229,12 +229,10 @@ bool resource_construct(
>  				DC_ERR("DC: failed to create audio!\n");
>  				return false;
>  			}
> -
>  			if (!aud->funcs->endpoint_valid(aud)) {
>  				aud->funcs->destroy(&aud);
>  				break;
>  			}
> -
>  			pool->audios[i] =3D aud;
>  			pool->audio_count++;
>  		}
> @@ -1703,24 +1701,25 @@ static struct audio *find_first_free_audio(
>  		const struct resource_pool *pool,
>  		enum engine_id id)
>  {
> -	int i;
> -	for (i =3D 0; i < pool->audio_count; i++) {
> +	int i, available_audio_count;
> +
> +	available_audio_count =3D pool->audio_count;
> +
> +	for (i =3D 0; i < available_audio_count; i++) {
>  		if ((res_ctx->is_audio_acquired[i] =3D=3D false) && (res_ctx->is_strea=
m_enc_acquired[i] =3D=3D true)) {
>  			/*we have enough audio endpoint, find the matching inst*/
>  			if (id !=3D i)
>  				continue;
> -
>  			return pool->audios[i];
>  		}
>  	}
> =20
> -    /* use engine id to find free audio */
> -	if ((id < pool->audio_count) && (res_ctx->is_audio_acquired[id] =3D=3D =
false)) {
> +	/* use engine id to find free audio */
> +	if ((id < available_audio_count) && (res_ctx->is_audio_acquired[id] =3D=
=3D false)) {
>  		return pool->audios[id];
>  	}
> -
>  	/*not found the matching one, first come first serve*/
> -	for (i =3D 0; i < pool->audio_count; i++) {
> +	for (i =3D 0; i < available_audio_count; i++) {
>  		if (res_ctx->is_audio_acquired[i] =3D=3D false) {
>  			return pool->audios[i];
>  		}
> diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c b/drivers/gpu=
/drm/amd/display/dc/dce/dce_audio.c
> index 7f6d724686f1a..abb559ce64085 100644
> --- a/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
> +++ b/drivers/gpu/drm/amd/display/dc/dce/dce_audio.c
> @@ -611,6 +611,8 @@ void dce_aud_az_configure(
> =20
>  	AZ_REG_WRITE(AZALIA_F0_CODEC_PIN_CONTROL_SINK_INFO1,
>  		value);
> +	DC_LOG_HW_AUDIO("\n\tAUDIO:az_configure: index: %u data, 0x%x, displayN=
ame %s: \n",
> +		audio->inst, value, audio_info->display_name);
> =20
>  	/*
>  	*write the port ID:
> @@ -922,7 +924,6 @@ static const struct audio_funcs funcs =3D {
>  	.az_configure =3D dce_aud_az_configure,
>  	.destroy =3D dce_aud_destroy,
>  };
> -
>  void dce_aud_destroy(struct audio **audio)
>  {
>  	struct dce_audio *aud =3D DCE_AUD(*audio);
> @@ -953,7 +954,6 @@ struct audio *dce_audio_create(
>  	audio->regs =3D reg;
>  	audio->shifts =3D shifts;
>  	audio->masks =3D masks;
> -
>  	return &audio->base;
>  }
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2ckSUACgkQMOfwapXb+vKPEQCfW9gdJcW3g3C2l2dL7ITgHNmr
xQAAnAmvNSky0C+OBdgfsTc1S85NfylU
=EbfI
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
