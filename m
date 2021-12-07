Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72C246B584
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhLGIUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbhLGIUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:20:19 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA0C061746;
        Tue,  7 Dec 2021 00:16:49 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso1076654wms.3;
        Tue, 07 Dec 2021 00:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ly6PK7ZlXENS118/xi5eqqCwa0KSNmpdRCsrscbUxXs=;
        b=RJ2A2AvJ/GKuZox5oW4GExhqZKBSj9wIWUKbCtplJz8JhCWTyrAxFMIw72JuUB/V+Z
         SPoIecc4pG3tPMKscObyZ2G/uII+bgm7BfxUU0bXw71NAB7FS8lBRIzIVv8M21zkG4ef
         G2PFryO1xXzvsDYUoBUUexeBMEkGTatXl9Mr8rqweUAQNaeypw1JYwzKUEJQSaie5QLI
         fya9lVVVb/XDzqesXcy+ShboMtB1eQDnknTyJU2WHG1Lms0pw0K5obFk6njQiKtDiRhT
         kMTD92schvaOdVSO2zm7fddUwNXJc8+nBSWi5lxQP5xb7QB0pVdcvmXT3LXNvxahKlJ5
         r55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ly6PK7ZlXENS118/xi5eqqCwa0KSNmpdRCsrscbUxXs=;
        b=lfLszAvfMPplak3oGhDhhmtw20suqxoZow+6tU+94nrzR/aoYtfQVXSl1wmbPHf0pT
         onNWpoTNuN9v3uux2dWwns1IVqX+I8o88zUnkA6qEAwTPDjb7z1UZDzxRrkZX2MI4aej
         2N7fozra3H8vb1EtDV50wIj9umds9L3UOsZIPr5iWG7vcaAspqm0BpgTIz5d+WWTmoIm
         YhotB/Gn0sZPK9iACgvTN108J13Mbhefah1Sl9MQkZNMXlRT5olyJ3X8ExNaBVncvL2l
         piMHJOuoe1C/4fluTPucBkq65FcSHksgH1VYqRPIi9eF69ohfxIYTFFClxV6CCUZ4Bd3
         vi9Q==
X-Gm-Message-State: AOAM532LE/A2T4Fi+5auxTQ9IXhe6tXKfDUmc1p9SXBd0YdMUBjhl1wJ
        STDVZ2OmSOgPiE9s3w2Ydhw=
X-Google-Smtp-Source: ABdhPJwqMszyeTU2cTI4AGOx6dwxjoLr6yhBZ1CHjwUgz6wuPMFwPNBUzP0X7/jaHwSnRS/oZ9woXQ==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr5138256wmp.165.1638865008363;
        Tue, 07 Dec 2021 00:16:48 -0800 (PST)
Received: from orome.fritz.box ([193.209.96.43])
        by smtp.gmail.com with ESMTPSA id p12sm16556493wrr.10.2021.12.07.00.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 00:16:47 -0800 (PST)
Date:   Tue, 7 Dec 2021 09:16:43 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Sameer Pujar <spujar@nvidia.com>
Cc:     tiwai@suse.com, broonie@kernel.org, lgirdwood@gmail.com,
        robh+dt@kernel.org, perex@perex.cz, jonathanh@nvidia.com,
        digetx@gmail.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
Message-ID: <Ya8Ya2en5Tm5Ol2u@orome.fritz.box>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="57gZ4qqQmZgyq7I1"
Content-Disposition: inline
In-Reply-To: <1638858770-22594-2-git-send-email-spujar@nvidia.com>
User-Agent: Mutt/2.1.3 (987dde4c) (2021-09-10)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--57gZ4qqQmZgyq7I1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 07, 2021 at 12:02:48PM +0530, Sameer Pujar wrote:
> HDA regression is recently reported on Tegra194 based platforms.
> This happens because "hda2codec_2x" reset does not really exist
> in Tegra194 and it causes probe failure. All the HDA based audio
> tests fail at the moment. This underlying issue is exposed by
> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
> response") which now checks return code of BPMP command response.
>=20
> The failure can be fixed by avoiding above reset in the driver,
> but the explicit reset is not necessary for Tegra devices which
> depend on BPMP. On such devices, BPMP ensures reset application
> during unpowergate calls. Hence skip reset on these devices
> which is applicable for Tegra186 and later.
>=20
> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> Cc: stable@vger.kernel.org
> Depends-on: 87f0e46e7559 ("ALSA: hda/tegra: Reset hardware")
> ---
>  sound/pci/hda/hda_tegra.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
> index ea700395..862141e 100644
> --- a/sound/pci/hda/hda_tegra.c
> +++ b/sound/pci/hda/hda_tegra.c
> @@ -68,6 +68,10 @@
>   */
>  #define TEGRA194_NUM_SDO_LINES	  4
> =20
> +struct hda_data {
> +	unsigned int do_reset:1;
> +};

I suppose this could also be a bool. Not sure if we need to care about
packing optimizations at this point.

It may also be useful to rename this to something less generic to avoid
potential clashes with other data structures in the future. We've often
used the _soc suffix in other drivers to mark this kind of SoC-specific
data. In this case it would be struct hda_tegra_soc.

If Takashi is fine with this as-is, I don't have any strong objections,
though.

> +
>  struct hda_tegra {
>  	struct azx chip;
>  	struct device *dev;
> @@ -76,6 +80,7 @@ struct hda_tegra {
>  	unsigned int nclocks;
>  	void __iomem *regs;
>  	struct work_struct probe_work;
> +	const struct hda_data *data;
>  };
> =20
>  #ifdef CONFIG_PM
> @@ -427,8 +432,13 @@ static int hda_tegra_create(struct snd_card *card,
>  	return 0;
>  }
> =20
> +static const struct hda_data tegra30_data =3D {
> +	.do_reset =3D 1,
> +};
> +
>  static const struct of_device_id hda_tegra_match[] =3D {
> -	{ .compatible =3D "nvidia,tegra30-hda" },
> +	{ .compatible =3D "nvidia,tegra30-hda", .data =3D &tegra30_data },
> +	{ .compatible =3D "nvidia,tegra186-hda" },
>  	{ .compatible =3D "nvidia,tegra194-hda" },
>  	{},
>  };

One other thing we've done in the past is to explicitly pass these
structures for each compatible string. That simplifies things a bit
because we don't have to keep checking for non-NULL pointers and instead
rely on the fact that there's always a valid pointer.

To do so, you'd basically add:

	static const struct hda_data tegra186_data =3D {
		.do_reset =3D 0,
	};

And reference that for both the Tegra186 and Tegra194 entries. Again,
not strictly necessary and since we have only one occurrence where we
need to check this, it seems fine as-is, so:

Acked-by: Thierry Reding <treding@nvidia.com>

--57gZ4qqQmZgyq7I1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmGvGGsACgkQ3SOs138+
s6ElZhAAkBaYvI5wUy4Npac6iTV4FV0hRhu5qIRVrFswg59quVV9ON7cg+yhPiT3
ECUBt0PvJSyC2WahkVievF9k/szqlqmuIkccsh1dyTg989V3unM3QAiIv77sdkua
HvljJ+klN7RCuYLG1ZRf9D2gq6673eTOh1DkAGX5piScMQj9cJskWDBkp6n3pxJt
cGuaEuXC1+VMMKAZqQuyFcp067IVbSsiPggWXKaaR0fWiZak2gGNPDaZQGBIUrmH
c5Tne6q+E3C+CRyuxE4SNTuurPwaorbFqR5rvaaViixJRrXII3pTa6MueGllsQPL
ZbasWvQgLhSUg2r//wgDoMNwX4DpbUgBdhqjmz9jPZ/a8QwqCmZXbjxBs30EdLMs
kZGfblGdGUUC2AEQRRUCG1ftCPrSj3FQtF41mOjWCEoeFvGSQhi0mi1Sm/vxYvbQ
ur4P42gmEf83YIgZG93GjP0lsvu06Rb/vqcvB7tIvM6FR9F3TNp5rWasRj94x8w2
v2JunAPyIjLPRd/h7mhFOJ7b40QrF4DkBduAQnfd/knk2qwaHmkHUG8wnPpoaVDN
5oMwUJ2p8eAM/GHkj4iuEivBSVGQ9gcNU7xYE1Rd7yx7lGKexlC37UW55lVxlGYX
7oXSVisIG2dJ4E3GjLbTkWQaf5Af4hjqdzziS4lEM33Fg+YY06c=
=bQYe
-----END PGP SIGNATURE-----

--57gZ4qqQmZgyq7I1--
