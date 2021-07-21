Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D40D3D1277
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 17:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbhGUOxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 10:53:39 -0400
Received: from orthanc.universe-factory.net ([104.238.176.138]:47414 "EHLO
        orthanc.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239825AbhGUOxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 10:53:39 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2021 10:53:37 EDT
Received: from [IPv6:2001:19f0:6c01:100::2] (unknown [IPv6:2001:19f0:6c01:100::2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by orthanc.universe-factory.net (Postfix) with ESMTPSA id D53CB1F4E2;
        Wed, 21 Jul 2021 17:28:21 +0200 (CEST)
To:     Moritz Fischer <mdf@kernel.org>
Cc:     linux-kernel@vger.kernel.org, gabriel.kh.huang@fii-na.com,
        moritzf@google.com, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>, linux-usb@vger.kernel.org
References: <20210719070519.41114-1-mdf@kernel.org>
From:   Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM
 state"
Message-ID: <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
Date:   Wed, 21 Jul 2021 17:28:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210719070519.41114-1-mdf@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HqCk6ZiLytvFswwmG4LPja68eEOGyVngQ"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HqCk6ZiLytvFswwmG4LPja68eEOGyVngQ
Content-Type: multipart/mixed; boundary="dne6ivMkj5K2Ni6kCDeXZjNUQjHxV9xO1";
 protected-headers="v1"
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: Moritz Fischer <mdf@kernel.org>
Cc: linux-kernel@vger.kernel.org, gabriel.kh.huang@fii-na.com,
 moritzf@google.com, stable@vger.kernel.org,
 Mathias Nyman <mathias.nyman@intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Vinod Koul <vkoul@kernel.org>, Justin Forbes <jmforbes@linuxtx.org>,
 linux-usb@vger.kernel.org
Message-ID: <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
Subject: Re: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM
 state"
References: <20210719070519.41114-1-mdf@kernel.org>
In-Reply-To: <20210719070519.41114-1-mdf@kernel.org>

--dne6ivMkj5K2Ni6kCDeXZjNUQjHxV9xO1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable

On 7/19/21 9:05 AM, Moritz Fischer wrote:
> This reverts commit d143825baf15f204dac60acdf95e428182aa3374.
>=20
> Justin reports some of his systems now fail as result of this commit:
>=20
>   xhci_hcd 0000:04:00.0: Direct firmware load for renesas_usb_fw.mem fa=
iled with error -2
>   xhci_hcd 0000:04:00.0: request_firmware failed: -2
>   xhci_hcd: probe of 0000:04:00.0 failed with error -2
>=20
> The revert brings back the original issue the commit tried to solve but=

> at least unbreaks existing systems relying on previous behavior.
>=20
> Cc: stable@vger.kernel.org
> Cc: Mathias Nyman <mathias.nyman@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Justin Forbes <jmforbes@linuxtx.org>
> Reported-by: Justin Forbes <jmforbes@linuxtx.org>
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
>=20
> Justin,
>=20
> would you be able to help out testing follow up patches to this?
>=20
> I don't have a machine to test your use-case and mine definitly require=
s
> a firmware load on RENESAS_ROM_STATUS_NO_RESULT.
>=20
> Thanks
> - Moritz


Hi Moritz,

as an additional data point, here's the behaviour of my system, a Thinkpa=
d=20
T14 AMD with:

06:00.0 USB controller [0c03]: Renesas Technology Corp. uPD720202 USB 3.0=
=20
Host Controller [1912:0015] (rev 02)

- On Kernel 5.13.1, no firmware: USB controller resets in an endless loop=
=20
when the system is running from battery
- On Kernel 5.13.4, no firmware: USB controller probe fails with the=20
mentioned firmware load error
- On Kernel 5.13.4, with renesas_usb_fw.mem: everything is working fine, =

the reset issue is gone

So it seems to me that requiring a firmware is generally the correct driv=
er=20
behaviour for this hardware. The firmware I found in the Arch User=20
Repository [1] unfortunately has a very restrictive license...

Kind regards,
Matthias


[1] https://github.com/denisandroid/uPD72020x-Firmware



>=20
> ---
>   drivers/usb/host/xhci-pci-renesas.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhc=
i-pci-renesas.c
> index 1da647961c25..5923844ed821 100644
> --- a/drivers/usb/host/xhci-pci-renesas.c
> +++ b/drivers/usb/host/xhci-pci-renesas.c
> @@ -207,8 +207,7 @@ static int renesas_check_rom_state(struct pci_dev *=
pdev)
>   			return 0;
>  =20
>   		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
> -			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
> -			break;
> +			return 0;
>  =20
>   		case RENESAS_ROM_STATUS_ERROR: /* Error State */
>   		default: /* All other states are marked as "Reserved states" */
> @@ -225,12 +224,13 @@ static int renesas_fw_check_running(struct pci_de=
v *pdev)
>   	u8 fw_state;
>   	int err;
>  =20
> -	/*
> -	 * Only if device has ROM and loaded FW we can skip loading and
> -	 * return success. Otherwise (even unknown state), attempt to load FW=
=2E
> -	 */
> -	if (renesas_check_rom(pdev) && !renesas_check_rom_state(pdev))
> -		return 0;
> +	/* Check if device has ROM and loaded, if so skip everything */
> +	err =3D renesas_check_rom(pdev);
> +	if (err) { /* we have rom */
> +		err =3D renesas_check_rom_state(pdev);
> +		if (!err)
> +			return err;
> +	}
>  =20
>   	/*
>   	 * Test if the device is actually needing the firmware. As most
>=20



--dne6ivMkj5K2Ni6kCDeXZjNUQjHxV9xO1--

--HqCk6ZiLytvFswwmG4LPja68eEOGyVngQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEZmTnvaa2aYgexS51Fu8/ZMsgHZwFAmD4PRUFAwAAAAAACgkQFu8/ZMsgHZxu
EBAA5q6s7FqVB71rjTBI5D46DCZ7m+yBlfD4cSDItuycPNAeNAbF8prz+KVX3uyFQnFixggBF5fK
t6CiFuhE4FrunQJYX9pVOEJD6v5WnYZznRNEdciZ/Pa6EQ8XSWmnp0cfeR+C7Z+ur8ZAhjgfylzW
7B+7wAYu/7vK7bGA5cSlZ0AW3SH2V/7A4DNdOuhgsGMSF3JuBOhoGdZQP8WhLz0wphSDXNBUi3uy
koKo89u7bBv/hSKMW/HF4+mgUaVBvQdd7Wj7IQQ57QwWjRdG2nY1LIs/PQU0yKtGQQdjo6kGij56
qLtADISuNrIdm4gWzC8qGVzWaUsNPAnrZmwnFxNwQ7YoEDwNti30hTbTnQbl9EBom/n+L47a23Eo
mXuH/z9Kw78qyK5IokumDxSwNrSWpnMADywhkqSZDE6Ul6dFj2Z8ScDsu0HOgXp3BM11OI4Y1XHU
DqEzZSyPTZmVzGsS59udJDznQV0cp2SWvt1PqB1EVpxwTGfXEehs+AWKaagaPgMqCK+0vDtM/C93
de9d2vMPOt+F3Cu0OqjznPktycUlhuJ9zwgksDl7KLfemSqv8mRAb2jtZ3u9YI7aw8jMnpMXjQUl
ndBCXEax7nQssarGoJZwQ/44YmNXxFr0gOTKlkY3754p5L1Cm2dNGeN/GVeWutbb6sHxMzcfXpqY
krw=
=2e4k
-----END PGP SIGNATURE-----

--HqCk6ZiLytvFswwmG4LPja68eEOGyVngQ--
