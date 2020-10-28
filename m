Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C237229D79B
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbgJ1WYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:24:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55242 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732580AbgJ1WV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:21:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2B4EF1C0B96; Wed, 28 Oct 2020 08:02:09 +0100 (CET)
Date:   Wed, 28 Oct 2020 08:02:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rohit kumar <rohitkr@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 072/264] ASoC: qcom: lpass-platform: fix memory leak
Message-ID: <20201028070207.GB8084@amd>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135434.080956764@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <20201027135434.080956764@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rohit kumar <rohitkr@codeaurora.org>
>=20
> [ Upstream commit 5fd188215d4eb52703600d8986b22311099a5940 ]
>=20
> lpass_pcm_data is never freed. Free it in close
> ops to avoid memory leak.

AFAICT this introduces memory leaks in the error paths.

Best regards,
							Pavel

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platfor=
m.c
index 2f2967247789..9e13a00d8c80 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -81,17 +81,20 @@ static int lpass_platform_pcmops_open(struct snd_pcm_su=
bstream *substream)
 	else
 		dma_ch =3D 0;
=20
-	if (dma_ch < 0)
+	if (dma_ch < 0) {
+		kfree(data);
 		return dma_ch;
+	}
=20
 	drvdata->substream[dma_ch] =3D substream;
=20
 	ret =3D regmap_write(drvdata->lpaif_map,
 			LPAIF_DMACTL_REG(v, dma_ch, dir), 0);
 	if (ret) {
+		kfree(data);
 		dev_err(soc_runtime->dev,
 			"error writing to rdmactl reg: %d\n", ret);
-			return ret;
+		return ret;
 	}
=20
 	data->dma_ch =3D dma_ch;
@@ -103,6 +106,7 @@ static int lpass_platform_pcmops_open(struct snd_pcm_su=
bstream *substream)
 	ret =3D snd_pcm_hw_constraint_integer(runtime,
 			SNDRV_PCM_HW_PARAM_PERIODS);
 	if (ret < 0) {
+		kfree(data);
 		dev_err(soc_runtime->dev, "setting constraints failed: %d\n",
 			ret);
 		return -EINVAL;

--=20
http://www.livejournal.com/~pavelmachek

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+ZF28ACgkQMOfwapXb+vLu5wCgqI/ejVB+foK2RbreTHgOI4+J
dz8AoJ7WzkEsVIvy7m/WrFgx8PB9F+X2
=TbFt
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
