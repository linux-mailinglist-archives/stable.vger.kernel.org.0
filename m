Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F74610E8
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbhK2JSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbhK2JQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 04:16:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EA1C0613B3;
        Mon, 29 Nov 2021 01:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5105B80E2B;
        Mon, 29 Nov 2021 09:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76CEC004E1;
        Mon, 29 Nov 2021 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638176458;
        bh=Qlr43Soawr/WWYkdiJWsATYOLYnK2WCcrLgE7pjs6R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qrf3MfG4KKoLsRGFnsNpE+7cijbqY3jNHzzeoHfnJUszA7IEN1w/Qae2paOBap1QS
         A2dsMLWbexRe2WeJ6jF1sEML5GznFnB88dKsCz9EA5MyHNW5b+bBpJ1M90X8cNItZ3
         MulgHzXA+rToegfrAAQo3PocTZdXlHsE6XXBrXLmzCE0gsfYh8C2BkFj9kvUl/IACr
         zeLIYm/NLEYro0pxKWFVtcnT+eQ7gQXlSCubRABDFqOuc9zIVLAq6QahTAVXubyEe1
         eYfYk8k4b+ZHRAHDBEHAdcF62a66Da/kyZ2C2uPWn8zkmpwcj/hsux+RYG4Rk6gGJM
         idNDJ3XG5k+KA==
Date:   Mon, 29 Nov 2021 10:00:55 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Hector Martin <marcan@marcan.st>, Jean Delvare <jdelvare@suse.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: i801: Safely share SMBus with BIOS/ACPI
Message-ID: <YaSWx7ldFfbCmrK3@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Hector Martin <marcan@marcan.st>, Jean Delvare <jdelvare@suse.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210626054113.246309-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NJ64SnWzsGr4DzGg"
Content-Disposition: inline
In-Reply-To: <20210626054113.246309-1-marcan@marcan.st>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NJ64SnWzsGr4DzGg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 26, 2021 at 02:41:13PM +0900, Hector Martin wrote:
> The i801 controller provides a locking mechanism that the OS is supposed
> to use to safely share the SMBus with ACPI AML or other firmware.
>=20
> Previously, Linux attempted to get out of the way of ACPI AML entirely,
> but left the bus locked if it used it before the first AML access. This
> causes AML implementations that *do* attempt to safely share the bus
> to time out if Linux uses it first; notably, this regressed ACPI video
> backlight controls on 2015 iMacs after 01590f361e started instantiating
> SPD EEPROMs on boot.
>=20
> Commit 065b6211a8 fixed the immediate problem of leaving the bus locked,
> but we can do better. The controller does have a proper locking mechanism,
> so let's use it as intended. Since we can't rely on the BIOS doing this
> properly, we implement the following logic:
>=20
> - If ACPI AML uses the bus at all, we make a note and disable power
>   management. The latter matches already existing behavior.
> - When we want to use the bus, we attempt to lock it first. If the
>   locking attempt times out, *and* ACPI hasn't tried to use the bus at
>   all yet, we cautiously go ahead and assume the BIOS forgot to unlock
>   the bus after boot. This preserves existing behavior.
> - We always unlock the bus after a transfer.
> - If ACPI AML tries to use the bus (except trying to lock it) while
>   we're in the middle of a transfer, or after we've determined
>   locking is broken, we know we cannot safely share the bus and give up.
>=20
> Upon first usage of SMBus by ACPI AML, if nothing has gone horribly
> wrong so far, users will see:
>=20
> i801_smbus 0000:00:1f.4: SMBus controller is shared with ACPI AML. This s=
eems safe so far.
>=20
> If locking the SMBus times out, users will see:
>=20
> i801_smbus 0000:00:1f.4: BIOS left SMBus locked
>=20
> And if ACPI AML tries to use the bus concurrently with Linux, or it
> previously used the bus and we failed to subsequently lock it as
> above, the driver will give up and users will get:
>=20
> i801_smbus 0000:00:1f.4: BIOS uses SMBus unsafely
> i801_smbus 0000:00:1f.4: Driver SMBus register access inhibited
>=20
> This fixes the regression introduced by 01590f361e, and further allows
> safely sharing the SMBus on 2015 iMacs. Tested by running `i2cdump` in a
> loop while changing backlight levels via the ACPI video device.
>=20
> Fixes: 01590f361e ("i2c: i801: Instantiate SPD EEPROMs automatically")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Jean, Heiner, what do we do with this topic?

> ---
>  drivers/i2c/busses/i2c-i801.c | 96 ++++++++++++++++++++++++++++-------
>  1 file changed, 79 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 04a1e38f2a6f..03be6310d6d7 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -287,11 +287,18 @@ struct i801_priv {
>  #endif
>  	struct platform_device *tco_pdev;
> =20
> +	/* BIOS left the controller marked busy. */
> +	bool inuse_stuck;
>  	/*
> -	 * If set to true the host controller registers are reserved for
> -	 * ACPI AML use. Protected by acpi_lock.
> +	 * If set to true, ACPI AML uses the host controller registers.
> +	 * Protected by acpi_lock.
>  	 */
> -	bool acpi_reserved;
> +	bool acpi_usage;
> +	/*
> +	 * If set to true, ACPI AML uses the host controller registers in an
> +	 * unsafe way. Protected by acpi_lock.
> +	 */
> +	bool acpi_unsafe;
>  	struct mutex acpi_lock;
>  };
> =20
> @@ -854,10 +861,37 @@ static s32 i801_access(struct i2c_adapter *adap, u1=
6 addr,
>  	int hwpec;
>  	int block =3D 0;
>  	int ret =3D 0, xact =3D 0;
> +	int timeout =3D 0;
>  	struct i801_priv *priv =3D i2c_get_adapdata(adap);
> =20
> +	/*
> +	 * The controller provides a bit that implements a mutex mechanism
> +	 * between users of the bus. First, try to lock the hardware mutex.
> +	 * If this doesn't work, we give up trying to do this, but then
> +	 * bail if ACPI uses SMBus at all.
> +	 */
> +	if (!priv->inuse_stuck) {
> +		while (inb_p(SMBHSTSTS(priv)) & SMBHSTSTS_INUSE_STS) {
> +			if (++timeout >=3D MAX_RETRIES) {
> +				dev_warn(&priv->pci_dev->dev,
> +					 "BIOS left SMBus locked\n");
> +				priv->inuse_stuck =3D true;
> +				break;
> +			}
> +			usleep_range(250, 500);
> +		}
> +	}
> +
>  	mutex_lock(&priv->acpi_lock);
> -	if (priv->acpi_reserved) {
> +	if (priv->acpi_usage && priv->inuse_stuck && !priv->acpi_unsafe) {
> +		priv->acpi_unsafe =3D true;
> +
> +		dev_warn(&priv->pci_dev->dev, "BIOS uses SMBus unsafely\n");
> +		dev_warn(&priv->pci_dev->dev,
> +			 "Driver SMBus register access inhibited\n");
> +	}
> +
> +	if (priv->acpi_unsafe) {
>  		mutex_unlock(&priv->acpi_lock);
>  		return -EBUSY;
>  	}
> @@ -1639,6 +1673,16 @@ static bool i801_acpi_is_smbus_ioport(const struct=
 i801_priv *priv,
>  	       address <=3D pci_resource_end(priv->pci_dev, SMBBAR);
>  }
> =20
> +static acpi_status
> +i801_acpi_do_access(u32 function, acpi_physical_address address,
> +				u32 bits, u64 *value)
> +{
> +	if ((function & ACPI_IO_MASK) =3D=3D ACPI_READ)
> +		return acpi_os_read_port(address, (u32 *)value, bits);
> +	else
> +		return acpi_os_write_port(address, (u32)*value, bits);
> +}
> +
>  static acpi_status
>  i801_acpi_io_handler(u32 function, acpi_physical_address address, u32 bi=
ts,
>  		     u64 *value, void *handler_context, void *region_context)
> @@ -1648,17 +1692,38 @@ i801_acpi_io_handler(u32 function, acpi_physical_=
address address, u32 bits,
>  	acpi_status status;
> =20
>  	/*
> -	 * Once BIOS AML code touches the OpRegion we warn and inhibit any
> -	 * further access from the driver itself. This device is now owned
> -	 * by the system firmware.
> +	 * Non-i801 accesses pass through.
>  	 */
> -	mutex_lock(&priv->acpi_lock);
> +	if (!i801_acpi_is_smbus_ioport(priv, address))
> +		return i801_acpi_do_access(function, address, bits, value);
> =20
> -	if (!priv->acpi_reserved && i801_acpi_is_smbus_ioport(priv, address)) {
> -		priv->acpi_reserved =3D true;
> +	if (!mutex_trylock(&priv->acpi_lock)) {
> +		mutex_lock(&priv->acpi_lock);
> +		/*
> +		 * This better be a read of the status register to acquire
> +		 * the lock...
> +		 */
> +		if (!priv->acpi_unsafe &&
> +			!(address =3D=3D SMBHSTSTS(priv) &&
> +			 (function & ACPI_IO_MASK) =3D=3D ACPI_READ)) {
> +			/*
> +			 * Uh-oh, ACPI AML is trying to do something with the
> +			 * controller without locking it properly.
> +			 */
> +			priv->acpi_unsafe =3D true;
> +
> +			dev_warn(&pdev->dev, "BIOS uses SMBus unsafely\n");
> +			dev_warn(&pdev->dev,
> +				 "Driver SMBus register access inhibited\n");
> +		}
> +	}
> =20
> -		dev_warn(&pdev->dev, "BIOS is accessing SMBus registers\n");
> -		dev_warn(&pdev->dev, "Driver SMBus register access inhibited\n");
> +	if (!priv->acpi_usage) {
> +		priv->acpi_usage =3D true;
> +
> +		if (!priv->acpi_unsafe)
> +			dev_info(&pdev->dev,
> +				 "SMBus controller is shared with ACPI AML. This seems safe so far.\=
n");
> =20
>  		/*
>  		 * BIOS is accessing the host controller so prevent it from
> @@ -1667,10 +1732,7 @@ i801_acpi_io_handler(u32 function, acpi_physical_a=
ddress address, u32 bits,
>  		pm_runtime_get_sync(&pdev->dev);
>  	}
> =20
> -	if ((function & ACPI_IO_MASK) =3D=3D ACPI_READ)
> -		status =3D acpi_os_read_port(address, (u32 *)value, bits);
> -	else
> -		status =3D acpi_os_write_port(address, (u32)*value, bits);
> +	status =3D i801_acpi_do_access(function, address, bits, value);
> =20
>  	mutex_unlock(&priv->acpi_lock);
> =20
> @@ -1706,7 +1768,7 @@ static void i801_acpi_remove(struct i801_priv *priv)
>  		ACPI_ADR_SPACE_SYSTEM_IO, i801_acpi_io_handler);
> =20
>  	mutex_lock(&priv->acpi_lock);
> -	if (priv->acpi_reserved)
> +	if (priv->acpi_usage)
>  		pm_runtime_put(&priv->pci_dev->dev);
>  	mutex_unlock(&priv->acpi_lock);
>  }
> --=20
> 2.32.0
>=20

--NJ64SnWzsGr4DzGg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmGklsMACgkQFA3kzBSg
Kbb19xAAp+/KuBaMeVdW591pCrHFWzeHtIY0DD8VW4txlCukb+DbpQhglCh55H+N
o9b0kwVdZU4Fv/5SMVfeTlXb7kPilI+JnlMiY4uxgzkQADzYBnkES/PsjBxY1aRQ
0evCirc8gDGrMllwe0p5YmYsir/4JvGowIMjpHA4LWm/Ul9wyoMbiEp0dtaecMQU
mq9LJSX6+oL3dhueuwNSX6h72mI55KfMTuS/ay83Fqwqhr/Y8txYSky1y8q7ICyx
jVLDUQFh/dcCqIPFKncVCLDFS/pcTpIDRvvvD7yDv5uC4SPKnq1xXHlkUm7iRP9+
nRAv/eSuyj9tZ4955Za/TBsrzh+QPlgVFXTkTeEr6W7PBOIOs5ayQFPpTYni/S8p
IQ5uDRVnEDMNiFPNf9O+Y9q0NeMiUiXl48aPRNWBjTbiCx4uLg98H89Pocb5Ji4L
thbfEiPuf86YRErHaqKIQo7m77tQBwd0ySk4XC2r5SiwlUORJ+1wMmH9cbLuEkp1
tfMMYzqpW7SQU8uxp3H/y0nZCnHFIWrPODtZZsTDv48ga5ODzQdqg/rt4MZG1cmy
6/B/e5dvDVYxBlynTShQ3ch7MwlBTGJjLaqWzI+ie0GzzzcoSW9BAfx0W60aDzC2
QiVnpPuiMBeTXY4yCSYl5qHBLog1L5BSRqiNuaekokZHBfjL6qA=
=pW/q
-----END PGP SIGNATURE-----

--NJ64SnWzsGr4DzGg--
