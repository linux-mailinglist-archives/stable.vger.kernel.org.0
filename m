Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDF536024F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhDOGZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhDOGZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:25:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945CE613EA;
        Thu, 15 Apr 2021 06:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618467919;
        bh=9gbCNiJ92z/+9kYkiggvzRQxzeus7PbgRPq40BEqOoY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XdfLDdmQi6axTBoWN8YZX/j0rzlIKOT6r35CB0JfRA1tOPaCO3EQyAi3tHBVB0Dgk
         Ev8xcjd1Bx3CWNRzG4Do4PAbziQW9tah8boo33KSpJmVNAMajxELdOsypsuAarNIWU
         fcDnqI9pkJGDvscRqb7VvTXdkWru4kiEZHcdaf6NUNS0i5vPt9AtunwNClFOIok5sx
         zGq/s9MbK4qWwYHmFUBVelyn3PZfc/I2ZD/F4WrNWCgiKFJfALcq1b+GPxScKt/7Fz
         D5cXZJNFvi3XVB9MHtAHsa4BwJ/gY5/NR6By10sxGcqjv4HXDuZzn1QQQenug8b04G
         NLL0wf3thVt4Q==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Remove FS bInterval_m1 limitation
In-Reply-To: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
References: <c2049798e1bce3ea38ae59dd17bbffb43e78370c.1618447155.git.Thinh.Nguyen@synopsys.com>
Date:   Thu, 15 Apr 2021 09:25:13 +0300
Message-ID: <87pmywnjxy.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> The programming guide incorrectly stated that the DCFG.bInterval_m1 must
> be set to 0 when operating in fullspeed. There's no such limitation for
> all IPs.

do we have an updated Databook correcting this statement?

> Cc: <stable@vger.kernel.org>
> Fixes: a1679af85b2a ("usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_=
m1")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/usb/dwc3/gadget.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 6227641f2d31..d87a29bd7d9b 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -608,12 +608,13 @@ static int dwc3_gadget_set_ep_config(struct dwc3_ep=
 *dep, unsigned int action)
>  		u8 bInterval_m1;
>=20=20
>  		/*
> -		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13, and it
> -		 * must be set to 0 when the controller operates in full-speed.
> +		 * Valid range for DEPCFG.bInterval_m1 is from 0 to 13.
> +		 *
> +		 * NOTE: The programming guide incorrectly stated bInterval_m1
> +		 * must be set to 0 when operating in fullspeed. Internally the
> +		 * controller does not have this limitation.

might be a good idea to refer to the section in this comment ;-)

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB33EkRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbslQ/+NGpas9VP0Mr7mZkkMeCIHmDexAP61hoR
33n1/rPKnU8Mfk1NcKbNi4iEFwqgdtqjfnHt+GA3MJF1wgkqLoY54DubKoWVEzGW
SWXHjfgj5pDp5i58AJHbEHfldNdR2BzuCrFwAhg9bMtwuOi5etQlJRtCjSBbcrsa
RVtyWO9+6jQZkvN66YQrX4noenV/1T0ZmuMQTdlf959XbJFtj13IICqvEwdSEYU1
3H88OGvmymGnqXqV4K+m5D+6XRmSIs8EkppVHYdsRVX4aN8qIa+w3rHJJSqmeF85
b4zLjRQYvspismnnhw5Xw9m+iRHFqLG+FOAeU9LOffvnZJYJfBkrDWxzi5D1rG3P
ApXh0QfdMLxH6VuyYcTjuQqQuammiXnZpFPJVByJ+STdUeMto7MZum2n1HXgNpph
ihYiUZ/fvmhHksHdDm/bUBXGxIC8Skz2/QoLnX5JnGirZohPNl7wUv0QJEDeRHS7
uopzqyH4cd0BSoo3bkN4jXstoflbiPz2Y04yoZJZb8RNYiScXf39UdpXCj+e1OLw
NCxTNF/4BsbN0wLdn3/cM9/cK2nrNenkiN4xLLpVigqQI1jqaSuKlqjWeJY2IYw+
A2KXqg3l38kWs/QPa8tqpll1twRsR8yNrMDi06eYtWXw7qij2YYBiao70T4D1Cni
HgmVl+W4YSs=
=62MQ
-----END PGP SIGNATURE-----
--=-=-=--
