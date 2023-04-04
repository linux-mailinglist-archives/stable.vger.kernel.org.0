Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A457B6D5F40
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjDDLkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbjDDLkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:40:00 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F76E9
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:39:59 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A42111C0DFD; Tue,  4 Apr 2023 13:39:58 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:39:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 137/173] ALSA: ymfpci: Fix assignment in if condition
Message-ID: <ZCwMjYhLWVGuUblN@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140418.909550737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="shELKiVA3C2hljsJ"
Content-Disposition: inline
In-Reply-To: <20230403140418.909550737@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--shELKiVA3C2hljsJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> PCI YMFPCI driver code contains lots of assignments in if condition,
> which is a bad coding style that may confuse readers and occasionally
> lead to bugs.
>=20
> This patch is merely for coding-style fixes, no functional changes.

I believe I see functional changes there.

> @@ -250,9 +259,8 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
>  	pci_read_config_word(pci, PCIR_DSXG_LEGACY, &old_legacy_ctrl);
>  	pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
>  	pci_write_config_word(pci, PCIR_DSXG_ELEGACY, legacy_ctrl2);
> -	if ((err =3D snd_ymfpci_create(card, pci,
> -				     old_legacy_ctrl,
> -			 	     &chip)) < 0) {
> +	err =3D snd_ymfpci_create(card, pci, old_legacy_ctrl, &chip);
> +	if (err  < 0) {
>  		release_and_free_resource(mpu_res);

Whitespace could be fixed here.

> @@ -1814,27 +1826,37 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int=
 rear_switch)
>  	/* add S/PDIF control */
>  	if (snd_BUG_ON(!chip->pcm_spdif))
>  		return -ENXIO;
> -	if ((err =3D snd_ctl_add(chip->card, kctl =3D snd_ctl_new1(&snd_ymfpci_=
spdif_default, chip))) < 0)
> +	kctl =3D snd_ctl_new1(&snd_ymfpci_spdif_default, chip);
> +	err =3D snd_ctl_add(chip->card, kctl);
> +	if (err < 0)
>  		return err;

Old code discarded err value and tested just kctl error. New code
tests just err. I guess we should test both.

>  	kctl->id.device =3D chip->pcm_spdif->device;
> -	if ((err =3D snd_ctl_add(chip->card, kctl =3D snd_ctl_new1(&snd_ymfpci_=
spdif_mask, chip))) < 0)
> +	kctl =3D snd_ctl_new1(&snd_ymfpci_spdif_mask, chip);
> +	err =3D snd_ctl_add(chip->card, kctl);
> +	if (err < 0)
>  		return err;
>  	kctl->id.device =3D chip->pcm_spdif->device;
> -	if ((err =3D snd_ctl_add(chip->card, kctl =3D snd_ctl_new1(&snd_ymfpci_=
spdif_stream, chip))) < 0)
> +	kctl =3D snd_ctl_new1(&snd_ymfpci_spdif_stream, chip);
> +	err =3D snd_ctl_add(chip->card, kctl);
> +	if (err < 0)
>  		return err;

Same here.

> =20
>  	/* direct recording source */
> -	if (chip->device_id =3D=3D PCI_DEVICE_ID_YAMAHA_754 &&
> -	    (err =3D snd_ctl_add(chip->card, kctl =3D snd_ctl_new1(&snd_ymfpci_=
drec_source, chip))) < 0)
> -		return err;
> +	if (chip->device_id =3D=3D PCI_DEVICE_ID_YAMAHA_754) {
> +		kctl =3D snd_ctl_new1(&snd_ymfpci_drec_source, chip);
> +		err =3D snd_ctl_add(chip->card, kctl);
> +		if (err < 0)
> +			return err;
> +	}

And here.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--shELKiVA3C2hljsJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwMjQAKCRAw5/Bqldv6
8ohsAKCj7GvKgpqroscZaW0TlgQkkMmXZQCfZq7McNCXs83TfqS8cnQOYBdB6r8=
=y9VZ
-----END PGP SIGNATURE-----

--shELKiVA3C2hljsJ--
