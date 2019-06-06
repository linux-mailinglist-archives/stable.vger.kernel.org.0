Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749C537029
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 11:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfFFJlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 05:41:02 -0400
Received: from mx1.emlix.com ([188.40.240.192]:36146 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfFFJlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 05:41:02 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 6503E600A1;
        Thu,  6 Jun 2019 11:40:59 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Date:   Thu, 06 Jun 2019 11:40:55 +0200
Message-ID: <2433398.iiuBUrR0On@devpool35>
Organization: emlix GmbH
In-Reply-To: <CAKv+Gu9oq+LseNvB9h1u+Q7QVOJFJwm_RyE1dMRgeVuL6D9fNQ@mail.gmail.com>
References: <779905244.a0lJJiZRjM@devpool35> <1993275.kHlTELq40E@devpool35> <CAKv+Gu9oq+LseNvB9h1u+Q7QVOJFJwm_RyE1dMRgeVuL6D9fNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1867592.6WJ3IrGa0d"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart1867592.6WJ3IrGa0d
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Ard Biesheuvel wrote:
> On Thu, 6 Jun 2019 at 09:50, Rolf Eike Beer <eb@emlix.com> wrote:
> > Am Donnerstag, 6. Juni 2019, 09:38:41 CEST schrieb Rolf Eike Beer:
> > > Greg KH wrote:
> > > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > > I decided to dig out a toy project which uses a DragonBoard 410c.
> > > > > This
> > > > > has
> > > > > been "running" with kernel 4.9, which I would keep this way for
> > > > > unrelated
> > > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it
> > > > > was
> > > > > buildable, which was good enough.
> > > > >=20
> > > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> > > > >=20
> > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in
> > > > > function
> > > > > `handle_kernel_image':
> > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-st=
ub.
> > > > > c:63
> > > > >=20
> > > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > > aarch64-unknown-linux-gnueabi-ld:
> > > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): relocat=
ion
> > > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can n=
ot
> > > > > be
> > > > > used when making a shared object; recompile with -fPIC
> > > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-st=
ub.
> > > > > c:63
> > > > >=20
> > > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target
> > > > > 'vmlinux'
> > > > > failed -make[1]: *** [vmlinux] Error 1
> > > > >=20
> > > > > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca
> > > > > from
> > > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be),
> > > > > reverting
> > > > > this commit fixes the build.
> > > > >=20
> > > > > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as
> > > > > 9.1.0.
> > > > > See
> > > > > the attached .config for reference.
> > > > >=20
> > > > > If you have questions or patches just ping me.
> > > >=20
> > > > Does Linus's latest tree also fail for you (or 5.1)?
> > >=20
> > > 5.1.7 with the same config as before and "make olddefconfig" builds f=
or
> > > me.
> >=20
> > Just for the fun of it: both 4.19 and 4.19.48 also work.

> Could you please check whether patch
> 60f38de7a8d4e816100ceafd1b382df52527bd50 applies cleanly, and whether
> it fixes the problem? Thanks.

The part in drivers/firmware/efi/libstub/arm-stub.c needs to be applied by=
=20
hand, but afterwards things build fine.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart1867592.6WJ3IrGa0d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXPjfpwAKCRCr5FH7Xu2t
/BzjA/9Pd3USy15vnfffsX50V3lfJ/gubyNSje0W25gGCPDqVoehWg/KfXRZea1s
0fPwkDaZ36+B1eQxa9PBqmYOm3+XcuM+/rOp1/7EBagM6SXZxlPzuIMgM4+i3+CG
eq/Xgow6Dpz7ewh/OLubSZFoCN57J8e/VQTl2lTRMpDZh1+8dQ==
=yAuE
-----END PGP SIGNATURE-----

--nextPart1867592.6WJ3IrGa0d--



