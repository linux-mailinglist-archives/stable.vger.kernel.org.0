Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8726112CF90
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 12:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfL3LcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 06:32:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37904 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfL3LcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 06:32:17 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BBBF21C2604; Mon, 30 Dec 2019 12:32:15 +0100 (CET)
Date:   Mon, 30 Dec 2019 12:32:14 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 102/219] ALSA: hda/hdmi - implement
 mst_no_extra_pcms flag
Message-ID: <20191230113214.GB10304@amd>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162523.844585380@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20191229162523.844585380@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>=20
> [ Upstream commit 2a2edfbbfee47947dd05f5860c66c0e80ee5e09d ]
>=20
> To support the DP-MST multiple streams via single connector feature,
> the HDMI driver was extended with the concept of backup PCMs. See
> commit 9152085defb6 ("ALSA: hda - add DP MST audio support").
=2E..
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This variable is not ever set in this patch, nor is it set elsewhere
in 4.19-stable. This means this patch is not suitable for stable.

Best regards,
								Pavel

> index 2003403ce1c8..199927694aef 100644
> --- a/sound/pci/hda/hda_codec.h
> +++ b/sound/pci/hda/hda_codec.h
> @@ -262,6 +262,7 @@ struct hda_codec {
>  	unsigned int force_pin_prefix:1; /* Add location prefix */
>  	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
>  	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
> +	unsigned int mst_no_extra_pcms:1; /* no backup PCMs for DP-MST */
> =20
>  #ifdef CONFIG_PM
>  	unsigned long power_on_acct;
> diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
> index c827a2a89cc3..9d5e3c8d62b9 100644
> --- a/sound/pci/hda/patch_hdmi.c
> +++ b/sound/pci/hda/patch_hdmi.c
> @@ -2063,15 +2063,24 @@ static bool is_hdmi_pcm_attached(struct hdac_devi=
ce *hdac, int pcm_idx)
>  static int generic_hdmi_build_pcms(struct hda_codec *codec)
>  {
>  	struct hdmi_spec *spec =3D codec->spec;
> -	int idx;
> +	int idx, pcm_num;
> =20
>  	/*
>  	 * for non-mst mode, pcm number is the same as before
> -	 * for DP MST mode, pcm number is (nid number + dev_num - 1)
> -	 *  dev_num is the device entry number in a pin
> -	 *
> +	 * for DP MST mode without extra PCM, pcm number is same
> +	 * for DP MST mode with extra PCMs, pcm number is
> +	 *  (nid number + dev_num - 1)
> +	 * dev_num is the device entry number in a pin
>  	 */
> -	for (idx =3D 0; idx < spec->num_nids + spec->dev_num - 1; idx++) {
> +
> +	if (codec->mst_no_extra_pcms)
> +		pcm_num =3D spec->num_nids;
> +	else
> +		pcm_num =3D spec->num_nids + spec->dev_num - 1;
> +
> +	codec_dbg(codec, "hdmi: pcm_num set to %d\n", pcm_num);
> +
> +	for (idx =3D 0; idx < pcm_num; idx++) {
>  		struct hda_pcm *info;
>  		struct hda_pcm_stream *pstr;
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4J4D4ACgkQMOfwapXb+vJXXgCeNDh4A40dM5KvH84pVurQdugK
kUAAn3hedVY2L21yEaPLrk59oZ2eJyrx
=BvHn
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
