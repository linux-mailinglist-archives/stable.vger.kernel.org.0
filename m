Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5248C104605
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 22:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfKTVsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 16:48:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54028 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTVsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 16:48:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F2BFB1C1AB8; Wed, 20 Nov 2019 22:48:48 +0100 (CET)
Date:   Wed, 20 Nov 2019 22:48:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 063/422] ice: Prevent control queue operations
 during reset
Message-ID: <20191120214848.GA13271@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051403.783565468@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20191119051403.783565468@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> [ Upstream commit fd2a981777d911b2e94cdec50779c85c58a0dec9 ]
>=20
> Once reset is issued, the driver loses all control queue interfaces.
> Exercising control queue operations during reset is incorrect and
> may result in long timeouts.
>=20
> This patch introduces a new field 'reset_ongoing' in the hw structure.
> This is set to 1 by the core driver when it receives a reset interrupt.
> ice_sq_send_cmd checks reset_ongoing before actually issuing the control
> queue operation. If a reset is in progress, it returns a soft error code
> (ICE_ERR_RESET_PENDING) to the caller. The caller may or may not have to
> take any action based on this return. Once the driver knows that the
> reset is done, it has to set reset_ongoing back to 0. This will allow
> control queue operations to be posted to the hardware again.
>=20
> This "bail out" logic was specifically added to ice_sq_send_cmd (which
> is pretty low level function) so that we have one solution in one place
> that applies to all types of control queues.

I don't think this is suitable for stable. Would driver maintainers
comment?

> +			 *
> +			 * As this is the start of the reset/rebuild cycle, set
> +			 * both to indicate that.
> +			 */
> +			hw->reset_ongoing =3D true;
>  		}
>  	}

This should be =3D 1, since variable is u8...

Best regards,
									Pavel     	      =20

> +++ b/drivers/net/ethernet/intel/ice/ice_type.h
> @@ -293,6 +293,7 @@ struct ice_hw {
>  	u8 sw_entry_point_layer;
> =20
>  	u8 evb_veb;		/* true for VEB, false for VEPA */
> +	u8 reset_ongoing;	/* true if hw is in reset, false otherwise */
>  	struct ice_bus_info bus;
>  	struct ice_nvm_info nvm;
>  	struct ice_hw_dev_caps dev_caps;	/* device capabilities */
> --=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdW0wAAKCRAw5/Bqldv6
8sxlAKDEha3WJuock0aOY2h8UfYbOW3HEgCcCt+6GiSmCKL4VV2nDuTaeTApljg=
=AL5j
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
