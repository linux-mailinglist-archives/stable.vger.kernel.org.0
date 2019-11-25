Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077B1108F1B
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 14:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfKYNpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 08:45:47 -0500
Received: from mail.nic.cz ([217.31.204.67]:50302 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727462AbfKYNpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 08:45:46 -0500
Received: from dellmb (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 092DA140E59;
        Mon, 25 Nov 2019 14:45:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1574689544; bh=c2dhsXgnzi1OMtQUvwm7JOIRXMonrQ9s548GPbknEiI=;
        h=Date:From:To;
        b=fAOBtJyq2erUWeyG/YVlaMFjj6IkQRQlfB2eQJy8CIfV33LMT+bjZRg5odd6aGFpX
         pxm0EnUbF2+ZnjqP5+ywDaYi1g0MKA3kW7X8nl/JfFH++XKGX1FFzspceZxaIwiCZ1
         2mkEW/e+HwAMKK8P3bJKEWPQKJFU5Ta/HUckZ0zc=
Date:   Mon, 25 Nov 2019 14:45:38 +0100
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     <stable@vger.kernel.org>
Cc:     <gregkh@linuxfoundation.org>, davem@davemloft.net
Subject: Re: Patch "mdio_bus: fix mdio_register_device when RESET_CONTROLLER
 is disabled" has been added to the 5.3-stable tree
Message-ID: <20191125144538.276daf86@dellmb>
In-Reply-To: <157468851123632@kroah.com>
References: <157468851123632@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream reverted this commit (2c61e821da7a) and then used 6e4ff1c94a04
instead.

Marek
 =20

On Mon, 25 Nov 2019 14:28:31 +0100
<gregkh@linuxfoundation.org> wrote:

> This is a note to let you know that I've just added the patch titled
>=20
>     mdio_bus: fix mdio_register_device when RESET_CONTROLLER is
> disabled
>=20
> to the 5.3-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      mdio_bus-fix-mdio_register_device-when-reset_controller-is-disabled.=
patch
> and it can be found in the queue-5.3 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable
> tree, please let <stable@vger.kernel.org> know about it.
>=20
>=20
> From foo@baz Mon 25 Nov 2019 02:27:19 PM CET
> From: "Marek Beh=FAn" <marek.behun@nic.cz>
> Date: Mon, 18 Nov 2019 19:15:05 +0100
> Subject: mdio_bus: fix mdio_register_device when RESET_CONTROLLER is
> disabled
>=20
> From: "Marek Beh=FAn" <marek.behun@nic.cz>
>=20
> [ Upstream commit 075e238d12c21c8bde700d21fb48be7a3aa80194 ]
>=20
> When CONFIG_RESET_CONTROLLER is disabled, the
> devm_reset_control_get_exclusive function returns -ENOTSUPP. This is
> not handled in subsequent check and then the mdio device fails to
> probe.
>=20
> When CONFIG_RESET_CONTROLLER is enabled, its code checks in OF for
> reset device, and since it is not present, returns -ENOENT. -ENOENT
> is handled. Add -ENOTSUPP also.
>=20
> This happened to me when upgrading kernel on Turris Omnia. You either
> have to enable CONFIG_RESET_CONTROLLER or use this patch.
>=20
> Signed-off-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
> Fixes: 71dd6c0dff51b ("net: phy: add support for reset-controller")
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/phy/mdio_bus.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -68,11 +68,12 @@ static int mdiobus_register_reset(struct
>  	if (mdiodev->dev.of_node)
>  		reset =3D
> devm_reset_control_get_exclusive(&mdiodev->dev, "phy");
> -	if (PTR_ERR(reset) =3D=3D -ENOENT ||
> -	    PTR_ERR(reset) =3D=3D -ENOTSUPP)
> -		reset =3D NULL;
> -	else if (IS_ERR(reset))
> -		return PTR_ERR(reset);
> +	if (IS_ERR(reset)) {
> +		if (PTR_ERR(reset) =3D=3D -ENOENT || PTR_ERR(reset) =3D=3D
> -ENOTSUPP)
> +			reset =3D NULL;
> +		else
> +			return PTR_ERR(reset);
> +	}
> =20
>  	mdiodev->reset_ctrl =3D reset;
> =20
>=20
>=20
> Patches currently in stable-queue which might be from
> marek.behun@nic.cz are
>=20
> queue-5.3/mdio_bus-fix-mdio_register_device-when-reset_controller-is-disa=
bled.patch

