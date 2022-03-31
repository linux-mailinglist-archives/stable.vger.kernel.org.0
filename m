Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607C64ED7CA
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiCaKez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 06:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiCaKew (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 06:34:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFCD204289
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 03:33:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZs6k-000591-1J; Thu, 31 Mar 2022 12:32:50 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-ffcf-bd2e-518f-8dbf.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ffcf:bd2e:518f:8dbf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A858C57B54;
        Thu, 31 Mar 2022 10:32:47 +0000 (UTC)
Date:   Thu, 31 Mar 2022 12:32:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
Message-ID: <20220331103247.y33wvkxk5vfbqohf@pengutronix.de>
References: <20220126171442.1338740-1-aurelien@aurel32.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vglrjwx3za2fhczz"
Content-Disposition: inline
In-Reply-To: <20220126171442.1338740-1-aurelien@aurel32.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vglrjwx3za2fhczz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.01.2022 18:14:42, Aurelien Jarno wrote:
> From version 2.38, binutils default to ISA spec version 20191213. This
> means that the csr read/write (csrr*/csrw*) instructions and fence.i
> instruction has separated from the `I` extension, become two standalone
> extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> this causes the following build failure:
>=20
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler mess=
ages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unre=
cognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unre=
cognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unre=
cognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unre=
cognized opcode `csrr a5,0xc01'
>=20
> The fix is to specify those extensions explicitely in -march. However as
> older binutils version do not support this, we first need to detect
> that.
>=20
> Cc: stable@vger.kernel.org # 4.15+
> Cc: Kito Cheng <kito.cheng@gmail.com>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  arch/riscv/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 8a107ed18b0d..7d81102cffd4 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
>  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> +
> +# Newer binutils versions default to ISA spec version 20191213 which mov=
es some
> +# instructions from the I extension to the Zicsr and Zifencei extensions.
> +toolchain-need-zicsr-zifencei :=3D $(call cc-option-yn, -march=3D$(riscv=
-march-y)_zicsr_zifencei)
> +riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $(riscv-march-y)_zicsr=
_zifencei
> +
>  KBUILD_CFLAGS +=3D -march=3D$(subst fd,,$(riscv-march-y))
>  KBUILD_AFLAGS +=3D -march=3D$(riscv-march-y)

I'm on current linus/master, this change breaks on current Debian
testing with:

| make: Leaving directory 'linux'
|   SYNC    include/config/auto.conf.cmd
|   GEN     Makefile
|   GEN     Makefile
|   CC      scripts/mod/empty.o
|   CHECK   linux/scripts/mod/empty.c
| invalid argument to '-march': '_zicsr_zifencei'

Used components:

| $ riscv64-linux-gnu-gcc -v
| Using built-in specs.
| COLLECT_GCC=3D/usr/bin/riscv64-linux-gnu-gcc
| COLLECT_LTO_WRAPPER=3D/usr/lib/gcc-cross/riscv64-linux-gnu/11/lto-wrapper
| Target: riscv64-linux-gnu
| Configured with: ../src/configure -v --with-pkgversion=3D'Debian 11.2.0-9=
' --with-bugurl=3Dfile:///usr/share/doc/gcc-11/README.Bugs --enable-languag=
es=3Dc,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=3D/usr --with-gcc-majo=
r-version-only --program-suffix=3D-11 --enable-shared --enable-linker-build=
-id --libexecdir=3D/usr/lib --without-included-gettext --enable-threads=3Dp=
osix --libdir=3D/usr/lib --enable-nls --with-sysroot=3D/ --enable-clocale=
=3Dgnu --enable-libstdcxx-debug --enable-libstdcxx-time=3Dyes --with-defaul=
t-libstdcxx-abi=3Dnew --enable-gnu-unique-object --disable-libitm --disable=
-libquadmath --disable-libquadmath-support --enable-plugin --enable-default=
-pie --with-system-zlib --enable-libphobos-checking=3Drelease --without-tar=
get-system-zlib --enable-multiarch --disable-werror --disable-multilib --wi=
th-arch=3Drv64imafdc --with-abi=3Dlp64d --enable-checking=3Drelease --build=
=3Dx86_64-linux-gnu --host=3Dx86_64-linux-gnu --target=3Driscv64-linux-gnu =
--program-prefix=3Driscv64-linux-gnu- --includedir=3D/usr/riscv64-linux-gnu=
/include --with-build-config=3Dbootstrap-lto-lean --enable-link-serializati=
on=3D2
| Thread model: posix
| Supported LTO compression algorithms: zlib zstd
| gcc version 11.2.0 (Debian 11.2.0-9)=20
| $ riscv64-linux-gnu-ld -v
| GNU ld (GNU Binutils for Debian) 2.38

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vglrjwx3za2fhczz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJFg0wACgkQrX5LkNig
010Pvgf/ZoWGG7K/5FYXrD6DqvRxaZGgXBUeIVFePKiNNRXC82F6VNIytbqSEg09
9LcT0qzh51lGHAI9n+ur77Hmiit//P0M3GYLxigpabDMtBoYN5iWwZpobYMP42ox
DCZ4ECYfzj/Hhtm++McTEGMW+EMCaKOf+53R3hS6Z7vmgfltDoT/Y6bmTNs9Vjue
bvxT9UN8iVhNiPgSwmA4VVaNAHoTyzYS+Axck6ndKq2qWLh6Rbu45MYaNMtWgz7l
Qfptz5E9TOaGItBnV47952dz2U6tsIvqNZBXdsqgQ501oeZMfk3jTvP+agrekeal
GDu+6B+/oPYD13DvqdchERnZaYNJLw==
=Jfvd
-----END PGP SIGNATURE-----

--vglrjwx3za2fhczz--
