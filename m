Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3598A4ED7FD
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 12:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiCaKxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 06:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbiCaKxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 06:53:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794BF1C9446
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 03:51:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZsOX-00078k-A6; Thu, 31 Mar 2022 12:51:13 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-ffcf-bd2e-518f-8dbf.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:ffcf:bd2e:518f:8dbf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 670AD57B86;
        Thu, 31 Mar 2022 10:51:12 +0000 (UTC)
Date:   Thu, 31 Mar 2022 12:51:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        linux-sparse@vger.kernel.org, ukl@pengutronix.de,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
Message-ID: <20220331105112.7t3qgtilhortkiq4@pengutronix.de>
References: <20220126171442.1338740-1-aurelien@aurel32.net>
 <20220331103247.y33wvkxk5vfbqohf@pengutronix.de>
 <20220331103913.2vlneq6clnheuty6@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y7e5q426lci6cphx"
Content-Disposition: inline
In-Reply-To: <20220331103913.2vlneq6clnheuty6@pengutronix.de>
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


--y7e5q426lci6cphx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc +=3D linux-sparse, Uwe, Luc Van Oostenryck

tl;dr:

A recent change in the kernel regarding the riscv -march handling breaks
current sparse.

On 31.03.2022 12:39:14, Marc Kleine-Budde wrote:
> On 31.03.2022 12:32:47, Marc Kleine-Budde wrote:
> > On 26.01.2022 18:14:42, Aurelien Jarno wrote:
> > > From version 2.38, binutils default to ISA spec version 20191213. This
> > > means that the csr read/write (csrr*/csrw*) instructions and fence.i
> > > instruction has separated from the `I` extension, become two standalo=
ne
> > > extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> > > this causes the following build failure:
> > >=20
> > >   CC      arch/riscv/kernel/vdso/vgettimeofday.o
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler =
messages:
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: =
unrecognized opcode `csrr a5,0xc01'
> > >=20
> > > The fix is to specify those extensions explicitely in -march. However=
 as
> > > older binutils version do not support this, we first need to detect
> > > that.
> > >=20
> > > Cc: stable@vger.kernel.org # 4.15+
> > > Cc: Kito Cheng <kito.cheng@gmail.com>
> > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > ---
> > >  arch/riscv/Makefile | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >=20
> > > diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> > > index 8a107ed18b0d..7d81102cffd4 100644
> > > --- a/arch/riscv/Makefile
> > > +++ b/arch/riscv/Makefile
> > > @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
> > >  riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
> > >  riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
> > >  riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
> > > +
> > > +# Newer binutils versions default to ISA spec version 20191213 which=
 moves some
> > > +# instructions from the I extension to the Zicsr and Zifencei extens=
ions.
> > > +toolchain-need-zicsr-zifencei :=3D $(call cc-option-yn, -march=3D$(r=
iscv-march-y)_zicsr_zifencei)
> > > +riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $(riscv-march-y)_z=
icsr_zifencei
> > > +
> > >  KBUILD_CFLAGS +=3D -march=3D$(subst fd,,$(riscv-march-y))
> > >  KBUILD_AFLAGS +=3D -march=3D$(riscv-march-y)
> >=20
> > I'm on current linus/master, this change breaks on current Debian
> > testing with:
> >=20
> > | make: Leaving directory 'linux'
> > |   SYNC    include/config/auto.conf.cmd
> > |   GEN     Makefile
> > |   GEN     Makefile
> > |   CC      scripts/mod/empty.o
> > |   CHECK   linux/scripts/mod/empty.c
>       ^^^^^
> It's actually "sparse" that breaks
>      =20
> > | invalid argument to '-march': '_zicsr_zifencei'
>=20
> | $ sparse --version
> | 0.6.4 (Debian: 0.6.4-2)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--y7e5q426lci6cphx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJFh5wACgkQrX5LkNig
013oyQgApEAGaNeYbcnBksclgOHXyRB9XqcWrrQVGYKkT0FziLqGCsxU30J3T4Rh
HRyf/cB3aJ1vsHwnz2wyT7ylEoeD6V2gozxE2rKl0ZIw74gCrQO09Yn31SvRxuUz
+CtJnkbrapsLGxZ8a7a08YU/9DSLkhvefR7vhgVMcjYYY/iceBjvdi1rJZGHI4iV
PMG1oDT6nm8i6GtYQ8KmRuFs7iyCCL92nnoYSxd3CjCUzvYzVaL3hiM7gpEr1c9+
SrVM13phszf/JPOUaZ1gRr2lnN5DXagyRH0S/ySN5fJ1+kJYq5HrRM6+NO01+5mN
q9mwLpS5NvsBOIhnxolvuCOS0Yth/Q==
=TEkc
-----END PGP SIGNATURE-----

--y7e5q426lci6cphx--
