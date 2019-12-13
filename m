Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654C811E0FF
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 10:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfLMJk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 04:40:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57996 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMJk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 04:40:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 64EFE1C24A9; Fri, 13 Dec 2019 10:40:56 +0100 (CET)
Date:   Fri, 13 Dec 2019 10:40:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thinh Nguyen <thinhn@synopsys.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 099/243] usb: dwc3: debugfs: Properly print/set link
 state for HS
Message-ID: <20191213094055.GB27976@amd>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150345.799359877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20191211150345.799359877@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Thinh Nguyen <thinh.nguyen@synopsys.com>
>=20
> [ Upstream commit 0d36dede457873404becd7c9cb9d0f2bcfd0dcd9 ]
>=20
> Highspeed device and below has different state names than superspeed and
> higher. Add proper checks and printouts of link states for highspeed and
> below.

Just noticed some more oddity:
>=20

> +	case DWC3_LINK_STATE_RESUME:
> +		return "Resume";
> +	default:
> +		return "UNKNOWN link state\n";
> +	}

"UNKNOWN" would be consistent with the rest of the file.

> +++ b/drivers/usb/dwc3/debugfs.c
> @@ -433,13 +433,17 @@ static int dwc3_link_state_show(struct seq_file *s,=
 void *unused)
>  	unsigned long		flags;
>  	enum dwc3_link_state	state;
>  	u32			reg;
> +	u8			speed;
> =20
>  	spin_lock_irqsave(&dwc->lock, flags);
>  	reg =3D dwc3_readl(dwc->regs, DWC3_DSTS);
>  	state =3D DWC3_DSTS_USBLNKST(reg);
> -	spin_unlock_irqrestore(&dwc->lock, flags);
> +	speed =3D reg & DWC3_DSTS_CONNECTSPD;
> =20
> -	seq_printf(s, "%s\n", dwc3_gadget_link_string(state));
> +	seq_printf(s, "%s\n", (speed >=3D DWC3_DSTS_SUPERSPEED) ?
> +		   dwc3_gadget_link_string(state) :
> +		   dwc3_gadget_hs_link_string(state));
> +	spin_unlock_irqrestore(&dwc->lock, flags);
> =20
>  	return 0;
>  }

The locking change is really wrong, right? There's no reason to do
seq_printfs under spinlock..

> @@ -477,6 +483,15 @@ static ssize_t dwc3_link_state_write(struct
file *file,
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&dwc->lock, flags);
> +	reg =3D dwc3_readl(dwc->regs, DWC3_DSTS);
> +	speed =3D reg & DWC3_DSTS_CONNECTSPD;
> +
> +	if (speed < DWC3_DSTS_SUPERSPEED &&
> +	    state !=3D DWC3_LINK_STATE_RECOV) {
> +		spin_unlock_irqrestore(&dwc->lock, flags);
> +		return -EINVAL;
> +	}
> +
>  	dwc3_gadget_set_link_state(dwc, state);
>  	spin_unlock_irqrestore(&dwc->lock, flags);
> =20

This might be ok but is not mentioned in the changelog.

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3zXKcACgkQMOfwapXb+vLikgCdHTHZdhRWzTvFTOhg7AE29rDJ
U8MAn1UIEgISShvU3BWSVEyBiz6Mq470
=qKFy
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
