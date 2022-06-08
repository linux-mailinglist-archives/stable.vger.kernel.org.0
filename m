Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B3542F43
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbiFHLeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiFHLeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:34:00 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9685B117656;
        Wed,  8 Jun 2022 04:33:56 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 93C821C0BB4; Wed,  8 Jun 2022 13:33:54 +0200 (CEST)
Date:   Wed, 8 Jun 2022 13:33:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable <stable@kernel.org>, Albert Wang <albertccwang@google.com>
Subject: Re: [PATCH 5.10 011/452] usb: dwc3: gadget: Move null pinter check
 to proper place
Message-ID: <20220608113354.GA9333@duo.ucw.cz>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164908.873134406@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20220607164908.873134406@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 3c5880745b4439ac64eccdb040e37fc1cc4c5406 upstream.
>=20
> When dwc3_gadget_ep_cleanup_completed_requests() called to
> dwc3_gadget_giveback() where the dwc3 lock is released, other thread is
> able to execute. In this situation, usb_ep_disable() gets the chance to
> clear endpoint descriptor pointer which leds to the null pointer
> dereference problem. So needs to move the null pointer check to a proper
> place.

Ok, but could someone check the error handling there? There's some
cleanup at the out label, but moved code does not jump there.

Best regards,
								Pavel

> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2960,14 +2960,14 @@ static bool dwc3_gadget_endpoint_trbs_co
>  	struct dwc3		*dwc =3D dep->dwc;
>  	bool			no_started_trb =3D true;
> =20
> -	if (!dep->endpoint.desc)
> -		return no_started_trb;
> -
>  	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
> =20
>  	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
>  		goto out;
> =20
> +	if (!dep->endpoint.desc)
> +		return no_started_trb;
> +
>  	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
>  		list_empty(&dep->started_list) &&
>  		(list_empty(&dep->pending_list) || status =3D=3D -EXDEV))
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYqCJIgAKCRAw5/Bqldv6
8uR1AJ0YQhw3nc4YH/yLBp6Q9/VM9rlTBwCfWEChQvJhSJ0kBB3UYR+O5TMNdUE=
=mj4B
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
