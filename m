Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA3F1DB8B6
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 17:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgETPx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 11:53:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34526 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgETPx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 11:53:26 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbR24-0007YG-AT; Wed, 20 May 2020 16:53:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbR23-007IZ9-NP; Wed, 20 May 2020 16:53:23 +0100
Message-ID: <9bb09863432ef9c9f820276cfe6db1a0aa8e6c4e.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 43/99] efi: Use early_mem*() instead of early_io*()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Date:   Wed, 20 May 2020 16:53:23 +0100
In-Reply-To: <lsq.1589984008.586913999@decadent.org.uk>
References: <lsq.1589984008.586913999@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-1ELFL5WP8obhLEch6Dz4"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-1ELFL5WP8obhLEch6Dz4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-05-20 at 15:14 +0100, Ben Hutchings wrote:
> 3.16.84-rc1 review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Daniel Kiper <daniel.kiper@oracle.com>
>=20
> commit abc93f8eb6e46a480485f19256bdbda36ec78a84 upstream.

I've now seen that this depends on the preceding commit 4fa62481e231
"arch/ia64: Define early_memunmap()".  I've queued that up as well.

Ben.

> Use early_mem*() instead of early_io*() because all mapped EFI regions
> are memory (usually RAM but they could also be ROM, EPROM, EEPROM, flash,
> etc.) not I/O regions. Additionally, I/O family calls do not work correct=
ly
> under Xen in our case. early_ioremap() skips the PFN to MFN conversion
> when building the PTE. Using it for memory will attempt to map the wrong
> machine frame. However, all artificial EFI structures created under Xen
> live in dom0 memory and should be mapped/unmapped using early_mem*() fami=
ly
> calls which map domain memory.
>=20
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: Mark Salter <msalter@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/platform/efi/efi.c | 28 ++++++++++++++--------------
>  drivers/firmware/efi/efi.c  |  4 ++--
>  2 files changed, 16 insertions(+), 16 deletions(-)
>=20
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -435,7 +435,7 @@ void __init efi_unmap_memmap(void)
>  {
>  	clear_bit(EFI_MEMMAP, &efi.flags);
>  	if (memmap.map) {
> -		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
> +		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
>  		memmap.map =3D NULL;
>  	}
>  }
> @@ -475,12 +475,12 @@ static int __init efi_systab_init(void *
>  			if (!data)
>  				return -ENOMEM;
>  		}
> -		systab64 =3D early_ioremap((unsigned long)phys,
> +		systab64 =3D early_memremap((unsigned long)phys,
>  					 sizeof(*systab64));
>  		if (systab64 =3D=3D NULL) {
>  			pr_err("Couldn't map the system table!\n");
>  			if (data)
> -				early_iounmap(data, sizeof(*data));
> +				early_memunmap(data, sizeof(*data));
>  			return -ENOMEM;
>  		}
> =20
> @@ -512,9 +512,9 @@ static int __init efi_systab_init(void *
>  					   systab64->tables;
>  		tmp |=3D data ? data->tables : systab64->tables;
> =20
> -		early_iounmap(systab64, sizeof(*systab64));
> +		early_memunmap(systab64, sizeof(*systab64));
>  		if (data)
> -			early_iounmap(data, sizeof(*data));
> +			early_memunmap(data, sizeof(*data));
>  #ifdef CONFIG_X86_32
>  		if (tmp >> 32) {
>  			pr_err("EFI data located above 4GB, disabling EFI.\n");
> @@ -524,7 +524,7 @@ static int __init efi_systab_init(void *
>  	} else {
>  		efi_system_table_32_t *systab32;
> =20
> -		systab32 =3D early_ioremap((unsigned long)phys,
> +		systab32 =3D early_memremap((unsigned long)phys,
>  					 sizeof(*systab32));
>  		if (systab32 =3D=3D NULL) {
>  			pr_err("Couldn't map the system table!\n");
> @@ -545,7 +545,7 @@ static int __init efi_systab_init(void *
>  		efi_systab.nr_tables =3D systab32->nr_tables;
>  		efi_systab.tables =3D systab32->tables;
> =20
> -		early_iounmap(systab32, sizeof(*systab32));
> +		early_memunmap(systab32, sizeof(*systab32));
>  	}
> =20
>  	efi.systab =3D &efi_systab;
> @@ -571,7 +571,7 @@ static int __init efi_runtime_init32(voi
>  {
>  	efi_runtime_services_32_t *runtime;
> =20
> -	runtime =3D early_ioremap((unsigned long)efi.systab->runtime,
> +	runtime =3D early_memremap((unsigned long)efi.systab->runtime,
>  			sizeof(efi_runtime_services_32_t));
>  	if (!runtime) {
>  		pr_err("Could not map the runtime service table!\n");
> @@ -586,7 +586,7 @@ static int __init efi_runtime_init32(voi
>  	efi_phys.set_virtual_address_map =3D
>  			(efi_set_virtual_address_map_t *)
>  			(unsigned long)runtime->set_virtual_address_map;
> -	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
> +	early_memunmap(runtime, sizeof(efi_runtime_services_32_t));
> =20
>  	return 0;
>  }
> @@ -595,7 +595,7 @@ static int __init efi_runtime_init64(voi
>  {
>  	efi_runtime_services_64_t *runtime;
> =20
> -	runtime =3D early_ioremap((unsigned long)efi.systab->runtime,
> +	runtime =3D early_memremap((unsigned long)efi.systab->runtime,
>  			sizeof(efi_runtime_services_64_t));
>  	if (!runtime) {
>  		pr_err("Could not map the runtime service table!\n");
> @@ -610,7 +610,7 @@ static int __init efi_runtime_init64(voi
>  	efi_phys.set_virtual_address_map =3D
>  			(efi_set_virtual_address_map_t *)
>  			(unsigned long)runtime->set_virtual_address_map;
> -	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
> +	early_memunmap(runtime, sizeof(efi_runtime_services_64_t));
> =20
>  	return 0;
>  }
> @@ -641,7 +641,7 @@ static int __init efi_runtime_init(void)
>  static int __init efi_memmap_init(void)
>  {
>  	/* Map the EFI memory map */
> -	memmap.map =3D early_ioremap((unsigned long)memmap.phys_map,
> +	memmap.map =3D early_memremap((unsigned long)memmap.phys_map,
>  				   memmap.nr_map * memmap.desc_size);
>  	if (memmap.map =3D=3D NULL) {
>  		pr_err("Could not map the memory map!\n");
> @@ -745,14 +745,14 @@ void __init efi_init(void)
>  	/*
>  	 * Show what we know for posterity
>  	 */
> -	c16 =3D tmp =3D early_ioremap(efi.systab->fw_vendor, 2);
> +	c16 =3D tmp =3D early_memremap(efi.systab->fw_vendor, 2);
>  	if (c16) {
>  		for (i =3D 0; i < sizeof(vendor) - 1 && *c16; ++i)
>  			vendor[i] =3D *c16++;
>  		vendor[i] =3D '\0';
>  	} else
>  		pr_err("Could not map the firmware vendor!\n");
> -	early_iounmap(tmp, 2);
> +	early_memunmap(tmp, 2);
> =20
>  	pr_info("EFI v%u.%.02u by %s\n",
>  		efi.systab->hdr.revision >> 16,
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -295,7 +295,7 @@ int __init efi_config_init(efi_config_ta
>  			if (table64 >> 32) {
>  				pr_cont("\n");
>  				pr_err("Table located above 4GB, disabling EFI.\n");
> -				early_iounmap(config_tables,
> +				early_memunmap(config_tables,
>  					       efi.systab->nr_tables * sz);
>  				return -EINVAL;
>  			}
> @@ -311,7 +311,7 @@ int __init efi_config_init(efi_config_ta
>  		tablep +=3D sz;
>  	}
>  	pr_cont("\n");
> -	early_iounmap(config_tables, efi.systab->nr_tables * sz);
> +	early_memunmap(config_tables, efi.systab->nr_tables * sz);
> =20
>  	set_bit(EFI_CONFIG_TABLES, &efi.flags);
> =20
>=20
--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken


--=-1ELFL5WP8obhLEch6Dz4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7FUnMACgkQ57/I7JWG
EQlYZg//R7Szg0IzIAgL/VpvxIvOpkDaUPCSmtcqLimTpd8zrljXXFNCeSX5XKB8
a2+f+UVeYSi5jpoXN5lSHJxqXh6UC/QIWWx4S5Q7vmbiFNwLpDcNFR1ozSL8PN6X
i5/er4hAN3INwsRddbrsjrYpg9MklX4eHVHQELmx0gYOH/syw3YRyJFCRyvnUf5m
4VGeve3/igYCzcvKm/sLl08UhYoyKfii6uxhiIO/wma2HpPjHzU2RYwiix0kiz8h
zy17vNGfKwS/x1dWcXdzShTgJt5V0fVEZK/FhkUQgelYNtgJr663iSKzumy1VPuv
cE3I0TEN0hN7+j5ra2+gRTOtAUZ/4ADcWECGOSqy4hu33mcdT3Oqxvkb+l5KVjdf
fQnc8sa9XHY5Ycic9YGi05Y5Z8/ol3JawzHuZiol3Mell652LTSICl1mQQj4sYpB
4xQpvcSfk3jtfIh1k/o5Jg6pMJfzsG3Pv6gkw0lUxAaVgbgKdnsC4FIBaYg/SVuJ
aVniqnGoYQdsnaKCdXv/XnIBtXmq5P/LGG7ZRAqq3Js2tTQS0vAHd8LVTbdLi80T
i047KvUWPT1XglEZVMAlks0lY2uru7+E2A8dlKFQZLQbZiLlrBaly4SCmO6aLGce
8n1YcMUrL4qSbF8aE0cQuJquqlOWV4He/QkolhpCILl570FCPeo=
=SW7j
-----END PGP SIGNATURE-----

--=-1ELFL5WP8obhLEch6Dz4--
