Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA10D36D1A
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 09:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFFHLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 03:11:10 -0400
Received: from mx1.emlix.com ([188.40.240.192]:35320 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFHLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 03:11:10 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id C9A44600C2;
        Thu,  6 Jun 2019 09:11:07 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: Building arm64 EFI stub with -fpie breaks build of 4.9.x (undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_')
Date:   Thu, 06 Jun 2019 09:11:00 +0200
Message-ID: <2102708.6BiaULqomI@devpool35>
Organization: emlix GmbH
In-Reply-To: <CAKwvOdn9g2Z=G_qz84S5xmn2GBNK7T-MWOGYT5C52sP0R=M_-Q@mail.gmail.com>
References: <779905244.a0lJJiZRjM@devpool35> <CAKwvOdnegLvkAa+-2uc-GM63HLcucWZtN5OoFvocLs50iLNJLg@mail.gmail.com> <CAKwvOdn9g2Z=G_qz84S5xmn2GBNK7T-MWOGYT5C52sP0R=M_-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7089195.FZj7tgPdUX"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart7089195.FZj7tgPdUX
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Nick Desaulniers wrote:
> On Wed, Jun 5, 2019 at 10:27 AM Nick Desaulniers
>=20
> <ndesaulniers@google.com> wrote:
> > On Wed, Jun 5, 2019 at 9:26 AM Greg KH <gregkh@linuxfoundation.org> wro=
te:
> > > On Wed, Jun 05, 2019 at 05:19:40PM +0200, Rolf Eike Beer wrote:
> > > > I decided to dig out a toy project which uses a DragonBoard 410c. T=
his
> > > > has
> > > > been "running" with kernel 4.9, which I would keep this way for
> > > > unrelated
> > > > reasons. The vanilla 4.9 kernel wasn't bootable back then, but it w=
as
> > > > buildable, which was good enough.
> > > >=20
> > > > Upgrading the kernel to 4.9.180 caused the boot to suddenly fail:
> > > >=20
> > > > aarch64-unknown-linux-gnueabi-ld:
> > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): in functi=
on
> > > > `handle_kernel_image':
> > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub=
=2Ec:
> > > > 63:
> > > > undefined reference to `__efistub__GLOBAL_OFFSET_TABLE_'
> > > > aarch64-unknown-linux-gnueabi-ld:
> > > > ./drivers/firmware/efi/libstub/lib.a(arm64- stub.stub.o): relocation
> > > > R_AARCH64_ADR_PREL_PG_HI21 against symbol
> > > > `__efistub__GLOBAL_OFFSET_TABLE_' which may bind externally can not
> > > > be used when making a shared object; recompile with -fPIC
> > > > /tmp/e2/build/linux-4.9.139/drivers/firmware/efi/libstub/arm64-stub=
=2Ec:
> > > > 63:
> > > > (.init.text+0xc): dangerous relocation: unsupported relocation
> > > > /tmp/e2/build/linux-4.9.139/Makefile:1001: recipe for target 'vmlin=
ux'
> > > > failed -make[1]: *** [vmlinux] Error 1
> > > >=20
> > > > This is caused by commit 27b5ebf61818749b3568354c64a8ec2d9cd5ecca f=
rom
> > > > linux-4.9.y (which is 91ee5b21ee026c49e4e7483de69b55b8b47042be),
> > > > reverting
> > > > this commit fixes the build.
> > > >=20
> > > > This happens with vanilla binutils 2.32 and gcc 8.3.0 as well as
> > > > 9.1.0. See
> > > > the attached .config for reference.
> > > >=20
> > > > If you have questions or patches just ping me.
> > >=20
> > > Does Linus's latest tree also fail for you (or 5.1)?
> > >=20
> > > Nick, do we need to add another fix that is in mainline for this to w=
ork
> > > properly?
> > >=20
> > > thanks,
> > >=20
> > > greg k-h
> >=20
> > Doesn't immediately ring any bells for me.
>=20
> Upstream commits:
> dd6846d77469 ("arm64: drop linker script hack to hide __efistub_ symbols")
> 1212f7a16af4 ("scripts/kallsyms: filter arm64's __efistub_ symbols")
>=20
> Look related to __efistub__ prefixes on symbols and aren't in stable
> 4.9 (maybe Rolf can try cherry picks of those).

I now have cherry-picked these commits:

dd6846d77469
fdfb69a72522e97f9105a6d39a5be0a465951ed8
1212f7a16af4
56067812d5b0e737ac2063e94a50f76b810d6ca3

The 2 additional ones were needed as dependencies of the others. Nothing of=
=20
this has helped.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart7089195.FZj7tgPdUX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXPi8hAAKCRCr5FH7Xu2t
/ASKA/0ZByRKigRbwENTAwUqfHXS/Jco9PmokTrfRNv8S/uptVPQMGqmOKBNpdIl
keSVa2on12JHM7zjZAgKDMMNy4MYenNb3vjqbRZ7VFVoWLvChSCc1FkZlqRygjnP
gFjS/VrmfrngI63i2/CcCTwL/UWJfl7L7R/GFCPZYwlJ9sb0kw==
=mekT
-----END PGP SIGNATURE-----

--nextPart7089195.FZj7tgPdUX--



