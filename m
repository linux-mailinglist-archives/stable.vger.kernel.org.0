Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F6D2578DD
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgHaMCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgHaMCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 08:02:10 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B8120866;
        Mon, 31 Aug 2020 12:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598875328;
        bh=HrYL8gHImJvclsYo0TErpiZWS1P2nrDFm4o9c34eur4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Df1T790sBNfYEQVJhXHurzEongiK4Y7ZhbMEg0go+CwRI+tFv1EZjX0xfv8RI7wDq
         au+Tzd4tqCfUnX3N1pnVBMujtUKAjuBup/UB0l5OXnsI3EyTXLLxvfvLNeqKweh9Ao
         6NLtYRxFxY7UMx9fzfVHsEx4s3l0VAjnD7bWTi9A=
From:   Felipe Balbi <balbi@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
        mthierer@gmail.com, Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: Fix out of sync data toggle if a configured device
 is reconfigured
In-Reply-To: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
References: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
Date:   Mon, 31 Aug 2020 15:02:01 +0300
Message-ID: <87tuwj9g7a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Mathias Nyman <mathias.nyman@linux.intel.com> writes:
> Userspace drivers that use a SetConfiguration() request to "lightweight"
> reset a already configured usb device might cause data toggles to get out
        ^
        an

> of sync between the device and host, and the device becomes unusable.
>
> The xHCI host requires endpoints to be dropped and added back to reset the
> toggle. USB core avoids these otherwise extra steps if the current active
> configuration is the same as the new requested configuration.
>
> A SetConfiguration() request will reset the device side data toggles.
> Make sure usb core drops and adds back the endpoints in this case.
>
> To avoid code duplication split the current usb_disable_device() function
> and reuse the endpoint specific part.

it looks like the refactoring is unrelated to the bug fix, perhaps? But
then again, it would mean adding more duplication just for the sake of
keeping bug fixes as pure bug fixes. No strong opinion.

> Cc: stable <stable@vger.kernel.org>

missing fixes?

> Tested-by: Martin Thierer <mthierer@gmail.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/core/message.c | 92 ++++++++++++++++++--------------------
>  1 file changed, 43 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 6197938dcc2d..a1f67efc261f 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -1205,6 +1205,35 @@ void usb_disable_interface(struct usb_device *dev,=
 struct usb_interface *intf,
>  	}
>  }
>=20=20
> +/*
> + * usb_disable_device_endpoints -- Disable all endpoints for a device
> + * @dev: the device whose endpoints are being disabled
> + * @skip_ep0: 0 to disable endpoint 0, 1 to skip it.
> + */
> +static void usb_disable_device_endpoints(struct usb_device *dev, int ski=
p_ep0)
> +{
> +	struct usb_hcd *hcd =3D bus_to_hcd(dev->bus);
> +	int i;
> +
> +	if (hcd->driver->check_bandwidth) {
> +

maybe remove this blank line?

> +		/* First pass: Cancel URBs, leave endpoint pointers intact. */
> +		for (i =3D skip_ep0; i < 16; ++i) {
> +			usb_disable_endpoint(dev, i, false);
> +			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
> +		}

maybe a blank line here?

> +		/* Remove endpoints from the host controller internal state */
> +		mutex_lock(hcd->bandwidth_mutex);
> +		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
> +		mutex_unlock(hcd->bandwidth_mutex);
> +	}

maybe a blank line here?

> +	/* Second pass: remove endpoint pointers */
> +	for (i =3D skip_ep0; i < 16; ++i) {
> +		usb_disable_endpoint(dev, i, true);
> +		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
> +	}
> +}
> +
>  /**
>   * usb_disable_device - Disable all the endpoints for a USB device
>   * @dev: the device whose endpoints are being disabled
> @@ -1522,6 +1536,9 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
>   * The caller must own the device lock.
>   *
>   * Return: Zero on success, else a negative error code.
> + *
> + * If this routine fails the device will probably be in an unusable state
> + * with endpoints disabled, and interfaces only partially enabled.

should you force U3 in that case?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9M5rkRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbs7hAAxeZ+swkd+kDCgWK4CvxAghcrhlOhZKRB
pePqv1+LdJ8sTfOpjiEFfKj/eBiHzxdezUMG6aQ14++f98hAb9sc1A2rYHrtIII7
wRznMw18aso7mw7lc5orocQn3t7KUJRErwotjxFJbRoG/d1j4eK6WUwESEGQCQMH
DvHHcU8ZP7+eGpVBcxnFab8s5zSoPioBkfr7hKa+17D8purHoyCAPdG/FYAMw8QU
R8jjdukAwvBshLIbnKRsUcbjAGb1xCO+dvYPd/SAmg0XaTmlhYyRFnWVtb+rHdIu
LSdkQ0KtOVaOtUsXowLc9VUnkxAbtP0ADgxnTA0/frUqJSxcopGiPUPkM2yx0rMC
kjVUO95Nwwl6Hi9txOz+vmgZ6E9duMT87GM4qUYUl1t/cJnkZfH7l6v28qqUpPCZ
h/qA+AZSljdpxB/9oKBTKlwSdwiOGtz3KHTvmCPKu9MACut7ZJiTTSJQrBblpHFX
JrLsKjXdk2czQSlMxej+k/ycFOeweNvWg99ih/dXmHJcsHQ9+KGEkwGjYpafz8Wh
Z0Vi4pvR5ESb1QycizdimEOKy4RPQJslbXDN5lZW2HU9M9yc8YrKq8sJj29WZacB
GUPYHYeWm6l94doAVNkfR5YUGDNGinVUbw2NVs9UR+BEqYkbu0lDmUyYX2cxhd2d
SYv6bOGokNc=
=CNT0
-----END PGP SIGNATURE-----
--=-=-=--
