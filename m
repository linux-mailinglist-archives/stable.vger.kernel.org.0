Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB47246844D
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhLDLAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 06:00:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384733AbhLDLAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 06:00:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007A8B801B8
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 10:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931FDC341C2;
        Sat,  4 Dec 2021 10:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638615443;
        bh=XsbzKPT5F6wfXCwHdQoo2y3HQPPpKAAakSBmnyR7TvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bxs8pWdHaxJy3eV7y65ebVjTX31vloFiAJUnv5PpKVXwymNFn2k7Hqkyu809ylgQo
         wEaGTBg0WtiwzBawnjA1ktC0J6IXk2TOVFck39KhzSO9f/6omwyJ9TYUWPL1IJfRXq
         T4+lXCbEUWQXMxGdxK+coo4d/C0Dyi/RQA1dMo97APnjPb0gfJVTCijP9agDNNmVyX
         POxfb5q6JPhgl2r87uzABQ0w+zW4RBXJuYwoTsy4clTTnhRDgMbQ9EHaRyFDCQwhdD
         mJC6gqCoPQj8gmMlNrb1nXGK6s2+r3Hho02Mti5N6dABzgB7nx39b0KP+KCXlrBb8n
         eAgMF9AKNeDQw==
Date:   Sat, 4 Dec 2021 11:57:19 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: Save power by
 disabling SerDes" failed to apply to 5.15-stable tree
Message-ID: <20211204115719.3315663b@thinkpad>
In-Reply-To: <16386137159777@kroah.com>
References: <16386137159777@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In fact it was a series of 6 patches, but the 2nd was without fixes tag:

21635d9203e1cf2b73b67e9a86059a62f62a3563
8c3318b4874e2dee867f5ae8f6d38f78e044bf71 (without fixes tag)
7527d66260ac0c603c6baca5146748061fcddbd6 (didnt apply)
93fd8207bed80ce19aaf59932cbe1c03d418a37d
163000dbc772c1eae9bdfe7c8fe30155db1efd74
ede359d8843a2779d232ed30bc36089d4b5962e4

On Sat, 04 Dec 2021 11:28:35 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 7527d66260ac0c603c6baca5146748061fcddbd6 Mon Sep 17 00:00:00 2001
> From: =3D?UTF-8?q?Marek=3D20Beh=3DC3=3DBAn?=3D <kabel@kernel.org>
> Date: Tue, 30 Nov 2021 18:01:48 +0100
> Subject: [PATCH] net: dsa: mv88e6xxx: Save power by disabling SerDes
>  trasmitter and receiver
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Save power on 88E6393X by disabling SerDes receiver and transmitter
> after SerDes is SerDes is disabled.
>=20
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Cc: stable@vger.kernel.org # de776d0d316f ("net: dsa: mv88e6xxx: add supp=
ort for mv88e6393x family")
> Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
> index 3a6244596a67..ceb63d7f1f97 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -1271,6 +1271,28 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_ch=
ip *chip, int port, void *_p)
>  	}
>  }
> =20
> +static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int=
 lane,
> +					bool on)
> +{
> +	u16 reg;
> +	int err;
> +
> +	err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				    MV88E6393X_SERDES_CTRL1, &reg);
> +	if (err)
> +		return err;
> +
> +	if (on)
> +		reg &=3D ~(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
> +			 MV88E6393X_SERDES_CTRL1_RX_PDOWN);
> +	else
> +		reg |=3D MV88E6393X_SERDES_CTRL1_TX_PDOWN |
> +		       MV88E6393X_SERDES_CTRL1_RX_PDOWN;
> +
> +	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +				      MV88E6393X_SERDES_CTRL1, reg);
> +}
> +
>  static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, in=
t lane)
>  {
>  	u16 reg;
> @@ -1297,7 +1319,11 @@ static int mv88e6393x_serdes_erratum_4_6(struct mv=
88e6xxx_chip *chip, int lane)
>  	if (err)
>  		return err;
> =20
> -	return mv88e6390_serdes_power_sgmii(chip, lane, false);
> +	err =3D mv88e6390_serdes_power_sgmii(chip, lane, false);
> +	if (err)
> +		return err;
> +
> +	return mv88e6393x_serdes_power_lane(chip, lane, false);
>  }
> =20
>  int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
> @@ -1362,17 +1388,29 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip=
 *chip, int port, int lane,
>  		err =3D mv88e6393x_serdes_erratum_4_8(chip, lane);
>  		if (err)
>  			return err;
> +
> +		err =3D mv88e6393x_serdes_power_lane(chip, lane, true);
> +		if (err)
> +			return err;
>  	}
> =20
>  	switch (cmode) {
>  	case MV88E6XXX_PORT_STS_CMODE_SGMII:
>  	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
>  	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> -		return mv88e6390_serdes_power_sgmii(chip, lane, on);
> +		err =3D mv88e6390_serdes_power_sgmii(chip, lane, on);
> +		break;
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> -		return mv88e6390_serdes_power_10g(chip, lane, on);
> +		err =3D mv88e6390_serdes_power_10g(chip, lane, on);
> +		break;
>  	}
> =20
> -	return 0;
> +	if (err)
> +		return err;
> +
> +	if (!on)
> +		err =3D mv88e6393x_serdes_power_lane(chip, lane, false);
> +
> +	return err;
>  }
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6x=
xx/serdes.h
> index cbb3ba30caea..e9292c8beee4 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.h
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.h
> @@ -93,6 +93,9 @@
>  #define MV88E6393X_SERDES_POC_PCS_MASK		0x0007
>  #define MV88E6393X_SERDES_POC_RESET		BIT(15)
>  #define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
> +#define MV88E6393X_SERDES_CTRL1			0xf003
> +#define MV88E6393X_SERDES_CTRL1_TX_PDOWN	BIT(9)
> +#define MV88E6393X_SERDES_CTRL1_RX_PDOWN	BIT(8)
> =20
>  #define MV88E6393X_ERRATA_4_8_REG		0xF074
>  #define MV88E6393X_ERRATA_4_8_BIT		BIT(14)
>=20

