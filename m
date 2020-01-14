Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73F613B520
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 23:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgANWK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 17:10:28 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:46066 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgANWK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 17:10:28 -0500
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id C383772CC6C;
        Wed, 15 Jan 2020 01:10:23 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id A58197CCE30; Wed, 15 Jan 2020 01:10:23 +0300 (MSK)
Date:   Wed, 15 Jan 2020 01:10:23 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, stable@vger.kernel.org,
        Rich Felker <dalias@libc.org>, libc-alpha@sourceware.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: fix struct ipc64_perm type definition
Message-ID: <20200114221023.GA8853@altlinux.org>
References: <20200114132633.3694261-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20200114132633.3694261-1-arnd@arndb.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2020 at 02:26:14PM +0100, Arnd Bergmann wrote:
> As discussed in the strace issue tracker, it appears that the sparc32
> sysvipc support has been broken for the past 11 years. It was however
> working in compat mode, which is how it must have escaped most of the
> regular testing.
>=20
> The problem is that a cleanup patch inadvertently changed the uid/gid
> fields in struct ipc64_perm from 32-bit types to 16-bit types in uapi
> headers.
>=20
> Both glibc and uclibc-ng still use the original types, so they should
> work fine with compat mode, but not natively.  Change the definitions
> to use __kernel_uid32_t and __kernel_gid32_t again.
>=20
> Fixes: 83c86984bff2 ("sparc: unify ipcbuf.h")
> Link: https://github.com/strace/strace/issues/116
> Cc: <stable@vger.kernel.org> # v2.6.29
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: "Dmitry V . Levin" <ldv@altlinux.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: libc-alpha@sourceware.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/sparc/include/uapi/asm/ipcbuf.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/sparc/include/uapi/asm/ipcbuf.h b/arch/sparc/include/ua=
pi/asm/ipcbuf.h
> index 5b933a598a33..0ea1240d2ea1 100644
> --- a/arch/sparc/include/uapi/asm/ipcbuf.h
> +++ b/arch/sparc/include/uapi/asm/ipcbuf.h
> @@ -17,19 +17,19 @@
> =20
>  struct ipc64_perm
>  {
> -	__kernel_key_t	key;
> -	__kernel_uid_t	uid;
> -	__kernel_gid_t	gid;
> -	__kernel_uid_t	cuid;
> -	__kernel_gid_t	cgid;
> +	__kernel_key_t		key;
> +	__kernel_uid32_t	uid;
> +	__kernel_gid32_t	gid;
> +	__kernel_uid32_t	cuid;
> +	__kernel_gid32_t	cgid;
>  #ifndef __arch64__
> -	unsigned short	__pad0;
> +	unsigned short		__pad0;
>  #endif
> -	__kernel_mode_t	mode;
> -	unsigned short	__pad1;
> -	unsigned short	seq;
> -	unsigned long long __unused1;
> -	unsigned long long __unused2;
> +	__kernel_mode_t		mode;
> +	unsigned short		__pad1;
> +	unsigned short		seq;
> +	unsigned long long	__unused1;
> +	unsigned long long	__unused2;
>  };
> =20
>  #endif /* __SPARC_IPCBUF_H */

I think the fix is correct, I also confirm that the part of strace
test suite that checks tracing of 32-bit tracees on sparc64 turns green
again when this patch is applied.

Please add to the commit message that
this bug was found by strace test suite.

Feel free to add
Reported-and-tested-by: Dmitry V. Levin <ldv@altlinux.org>


--=20
ldv

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJeHjxPAAoJEAVFT+BVnCUIGwIQANO/CcoeRKwRxH+405T1A7gr
RiBoO4UCZ8EydDh9r9ELr3vBfWLdn6wvEhSxgeyjswCbu2ObO4euUrSTPS+JpmDK
eDlu7ANPIek/3ZPkqzc0vI6Gc/joYawdldlkvw6qWwoya11Y2WfxmhvWNzXEhTrC
jVyf3rf+DKyDJg3wGpa1/0MhkYWl0MT5daESMh3h+RjwAarky1AQb0PI++FHda9G
WcXivT3U+KJHGiU1tr/FEGzb97tarjc3PBFPTnfEiq7D2S/7VhMb3b7JS+nh4r2p
oG2c5Rv/m+B9oiG1x8fLk5kMHn+BUKBv1kqc7SQC7AfWHiMucYmiAAvjNOvT5LCG
s1+Kh8d7dNZMT2apJVdLSA+gBiWtZ3udLqlYDQ4IudhEe20VOG9EGG+71FeA2yTH
eemiVwrGxSHKdkK9SAAk5Z0ljrMxIBHg1AFT6sUc3eFT5s7oIN6Epdsw3ooccT08
ysEBm2O/jPSiHVuQdPolcwsje9bpYrzZaK/tUWS7clBO8oEpA3ZCdTN60l7xLMJt
aWLKSGWz2zjNtOTrkgbOJTYhDeGXqQg2KiJ2zy0Ga0p7ujcMRydQAjxzu5kH2Dlg
UVG+7u8ctOdFB9738k2NBbAVFsYAZ84Y61F2MqzuIXZRG5Nbz//EqyNBATH2Bp0f
Rh4ul08WC6JsYU5Gx+Gv
=SfW4
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
