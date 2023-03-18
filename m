Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA056BF747
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 02:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjCRBuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 21:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRBuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 21:50:06 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80755069
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 18:50:05 -0700 (PDT)
Received: from [213.219.167.32] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1pdLhm-0007hf-By; Sat, 18 Mar 2023 02:49:58 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1pdLhl-004RBG-2a;
        Sat, 18 Mar 2023 02:49:57 +0100
Message-ID: <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>
Subject: Re: [PATCH 4.19 161/252] x86/microcode/amd: Remove
 load_microcode_amd()s bsp parameter
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Cc:     patches@lists.linux.dev, stable <stable@vger.kernel.org>
Date:   Sat, 18 Mar 2023 02:49:53 +0100
In-Reply-To: <20230310133723.713256658@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
         <20230310133723.713256658@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-099/XO6jdpDwBawJ2K/4"
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-099/XO6jdpDwBawJ2K/4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-03-10 at 14:38 +0100, Greg Kroah-Hartman wrote:
> From: Borislav Petkov (AMD) <bp@alien8.de>
>=20
> commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.
>=20
> It is always the BSP.
>=20
> No functional changes.
>=20

Does this not depend on commit 2071c0aeda22 "x86/microcode: Simplify
init path even more"?  That hasn't been backported to any stable
branches.

Ben.

> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/20230130161709.11615-2-bp@alien8.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kernel/cpu/microcode/amd.c |   17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>=20
> --- a/arch/x86/kernel/cpu/microcode/amd.c
> +++ b/arch/x86/kernel/cpu/microcode/amd.c
> @@ -329,8 +329,7 @@ void load_ucode_amd_ap(unsigned int cpui
>  	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
>  }
> =20
> -static enum ucode_state
> -load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
> +static enum ucode_state load_microcode_amd(u8 family, const u8 *data, si=
ze_t size);
> =20
>  int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
>  {
> @@ -348,7 +347,7 @@ int __init save_microcode_in_initrd_amd(
>  	if (!desc.mc)
>  		return -EINVAL;
> =20
> -	ret =3D load_microcode_amd(true, x86_family(cpuid_1_eax), desc.data, de=
sc.size);
> +	ret =3D load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.siz=
e);
>  	if (ret > UCODE_UPDATED)
>  		return -EINVAL;
> =20
> @@ -698,8 +697,7 @@ static enum ucode_state __load_microcode
>  	return UCODE_OK;
>  }
> =20
> -static enum ucode_state
> -load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
> +static enum ucode_state load_microcode_amd(u8 family, const u8 *data, si=
ze_t size)
>  {
>  	struct ucode_patch *p;
>  	enum ucode_state ret;
> @@ -723,10 +721,6 @@ load_microcode_amd(bool save, u8 family,
>  		ret =3D UCODE_NEW;
>  	}
> =20
> -	/* save BSP's matching patch for early load */
> -	if (!save)
> -		return ret;
> -
>  	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
>  	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_S=
IZE));
> =20
> @@ -754,12 +748,11 @@ static enum ucode_state request_microcod
>  {
>  	char fw_name[36] =3D "amd-ucode/microcode_amd.bin";
>  	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
> -	bool bsp =3D c->cpu_index =3D=3D boot_cpu_data.cpu_index;
>  	enum ucode_state ret =3D UCODE_NFOUND;
>  	const struct firmware *fw;
> =20
>  	/* reload ucode container only on the boot cpu */
> -	if (!refresh_fw || !bsp)
> +	if (!refresh_fw)
>  		return UCODE_OK;
> =20
>  	if (c->x86 >=3D 0x15)
> @@ -776,7 +769,7 @@ static enum ucode_state request_microcod
>  		goto fw_release;
>  	}
> =20
> -	ret =3D load_microcode_amd(bsp, c->x86, fw->data, fw->size);
> +	ret =3D load_microcode_amd(c->x86, fw->data, fw->size);
> =20
>   fw_release:
>  	release_firmware(fw);
>=20
>=20

--=20
Ben Hutchings
[W]e found...that it wasn't as easy to get programs right as we had
thought. I realized that a large part of my life from then on was going
to be spent in finding mistakes in my own programs.
                                                 - Maurice Wilkes, 1949

--=-099/XO6jdpDwBawJ2K/4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmQVGMEACgkQ57/I7JWG
EQkyDBAAqtlB0T/T5REV6TdE5CBH7a+Ej+Br4lPZdul0ULL5nVm7zkse8WenBiHF
l0J5I6NDSJ1wsJIhvV2Sy314noMjw7WR+YfTxPFwk7IYUf2lh/wF5iSo0nwD7HPm
d5MaLOEEmthBwMTEtZe4lFt1MgyXXNNdMo5FIAO3GbDJpcJ7KuWhFyNJ2Pebckc8
ex6vfxRS53Yz5iMLZ37CLMpBWMJauIs9ayKN5lpeVSwpy09Z6UootjGiOSQxTdLJ
JmSZHcQ7vW5joigIxt7V2PLBqgXMlVXt706kg1OaEUYFth3dqjMRe9WRdgRoQvEf
UQqS6htoAM9pHQBCUb63o7q+EtIo+4ZuzkPsjL3+8iY8rT17qyxpeJDWp3IxQSdM
OMlKEWQaRqRcsNzt2DyFQTFrJBN4zgRzuuDXFKxXCBQ5Rw77EI0En4QOXxYiWEmg
ZBxu0ZERsF+IFh7hRyJUtT/aoN+JGPk04553CmWZVACq1qygmIRV/umLgIlTnlhm
lRKuN+UhPL2nWJI9NM9ytbcqRcf+AxDAd+sLxjBEA09rU4hbinmPovEOxMHCQT2Z
hcNdJCOzNUg4NhNXRz5fJfX+RqNP72q+uFqjfI5UmWEektk2baKancSEOWNjTWo6
FSiFf/yX5Hj1hlGnFhgOQed+FWI0y+SoAPkj/Y8NSSbqsCH22YQ=
=TNtX
-----END PGP SIGNATURE-----

--=-099/XO6jdpDwBawJ2K/4--
