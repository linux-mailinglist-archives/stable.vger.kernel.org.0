Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BB86B5992
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 09:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCKIzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 03:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjCKIzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 03:55:07 -0500
X-Greylist: delayed 120 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Mar 2023 00:55:04 PST
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B470C521D1
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 00:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=QsTBuE7gnkjhR2MUNnrttMd8TEsxslDanQchSVUkX+M=; b=Iq+gd6hmmqmUWnJtiGC/VtVxXP
        LXrGgsdjdlIkcZliLGcTvqzQYG+/wFvXuDejKJBrz0QzAmV2nTauFKtmuJksd8auqgPXQ1ErVWDuV
        xrUk2Mc0hSsfeWvrFPbEkEOY9YuQP559/iMVm+45318Gz4wu9Vm1YjTthy2kMoQ+Wz5N+vicd6lpf
        5lZAmjEavKkddS2NOIl8Ub3MmkAslr6LCu0aJ8pmkOglOPH9e87jckB6qVAxmTgYQ8BmK06/T6y5V
        n4oKR3tqnE3f1Y/Vmmzp6cgE4jXdyupY/Asm4Z2od6Aa/lve4Dam+6QqEME6D3Nwi/HIxhRgNCy/g
        MpZoWEsw==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1pav0A-00BgbO-1k; Sat, 11 Mar 2023 09:54:54 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.96)
        (envelope-from <aurelien@aurel32.net>)
        id 1pav09-009TwV-1X;
        Sat, 11 Mar 2023 09:54:53 +0100
Date:   Sat, 11 Mar 2023 09:54:53 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Bin Meng <bmeng.cn@gmail.com>
Cc:     conor@kernel.org, conor.dooley@microchip.com,
        linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
        naresh.kamboju@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, palmer@dabbelt.com, palmer@rivosinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
Message-ID: <ZAxB3cfsobGggdRc@aurel32.net>
References: <20230308220842.1231003-1-conor@kernel.org>
 <20230310150754.535425-1-bmeng.cn@gmail.com>
 <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAEUhbmWcfcSmuU6VnbTdLoErT113RZPgHSK3c+3M5kU0Wsv1pg@mail.gmail.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-03-10 23:35, Bin Meng wrote:
> On Fri, Mar 10, 2023 at 11:07=E2=80=AFPM Bin Meng <bmeng.cn@gmail.com> wr=
ote:
> >
> > > From: Conor Dooley <conor.dooley@microchip.com>
> > >
> > > The spec folk, in their infinite wisdom, moved both control and status
> > > registers & the FENCE.I instructions out of the I extension into their
> > > own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
> > > spec [0].
> > > The GCC/binutils crew decided [1] to move their default version of the
> > > ISA spec to the 20191213 version of the ISA spec, which came into bei=
ng
> > > for version 2.38 of binutils and GCC 12. Building with this toolchain
> > > configuration would result in assembler issues:
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
> > > This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binutils
> > > 2.38") by Aurelien Jarno, but has proven fragile.
> > >
> > > Before LLVM 17, LLVM did not support these extensions and, as such, t=
he
> > > cc-option check added by Aurelien worked. Since commit 22e199e6afb1
> > > ("[RISCV] Accept zicsr and zifencei command line options") however, L=
LVM
> > > *does* support them and the cc-option check passes.
> > >
> > > This surfaced as a problem while building the 5.10 stable kernel using
> > > the default Tuxmake Debian image [2], as 5.10 did not yet support ld.=
lld,
> > > and uses the Debian provided binutils 2.35.
> > > Versions of ld prior to 2.38 will refuse to link if they encounter
> > > unknown ISA extensions, and unfortunately Zifencei is not supported by
> > > bintuils 2.35.
> > >
> > > Instead of dancing around with adding these extensions to march, as we
> > > currently do, Palmer suggested locking GCC builds to the same version=
 of
> > > the ISA spec that is used by LLVM. As far as I can tell, that is 2.2,
> > > with, apparently [3], a lack of interest in implementing a flag like
> > > GCC's -misa-spec at present.
> > >
> > > Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS when
> > > GCC is used & remove the march dance.
> > >
> > > As clang does not accept this argument, I had expected to encounter
> > > issues with the assembler, as neither zicsr nor zifencei are present =
in
> > > the ISA string and the spec version *should* be defaulting to a versi=
on
> > > that requires them to be present. The build passed however and the
> > > resulting kernel worked perfectly fine for me on a PolarFire SoC...
> > >
> > > Link: https://riscv.org/wp-content/uploads/2019/06/riscv-spec.pdf [0]
> > > Link: https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/aE1ZeHH=
CYf4 [1]
> > > Link: https://lore.kernel.org/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf4pZcDO=
=3DhuCA0D8ug2V2+irJQ@mail.gmail.com/ [2]
> > > Link: https://discourse.llvm.org/t/specifying-unpriviledge-spec-versi=
on-misa-spec-gcc-flag-equivalent/66935 [3]
> > > CC: stable@vger.kernel.org
> > > Suggested-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > > ---
> > > I think Aurelien's original commit message might actually not be quite
> > > correct? I found, in my limited testing, that it is not the default
> > > behaviour of gas that matters, but rather the toolchain itself?
> > > My binutils versions (both those built using the clang-built-linux
> > > tc-build scripts which do not set an ISA spec version, and one built
> > > using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec vers=
ion
> > > set) do not encounter these issues.
> >
> > I am unable to reproduce the build failure as reported by commit 6df2a0=
16c0c8
> > ("riscv: fix build with binutils 2.38") by Aurelien Jarno using kernel.=
org
> > pre-built GCC 11.3.0 [1] which includes binutils 2.38.
> >
> > [1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_6=
4/11.3.0/x86_64-gcc-11.3.0-nolibc-x86_64-linux.tar.xz
> >
> > The defconfig of v5.16 kernel (commit 6df2a016c0c8 lands in v5.17) buil=
ds fine
> > for me. Anything I am missing?
> >
>=20
> Some further note:
>=20
> After I switched to kernel.org pre-built GCC 12.2.0 [1] which includes
> binutils 2.39, I was able to reproduce the exact same build failure of
> v5.16 kernel as described in the commit 6df2a016c0c8 ("riscv: fix
> build with binutils 2.38") by Aurelien Jarno.
>=20
> To verify the commit message of 6df2a016c0c8 is accurate or not, I
> built a GAS from binutils 2.37 and replaced the GAS 2.39 in the
> kernel.org package, surprisingly kernel v5.16 did not build with the
> same build failure.
>=20
> So it seems that it's GCC that caused the build failure instead of GAS
> from binutils??

No, GCC 12 was not yet released as the time of the commit, and the issue
was definitely due to binutils. That said GCC 12 also introduced some
support of the new extensions, which made the situation even more
complex.

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                 http://www.aurel32.net
