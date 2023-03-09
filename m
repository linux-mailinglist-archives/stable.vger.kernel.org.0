Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BAA6B1B4A
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 07:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCIGTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 01:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCIGTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 01:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19905FA6E
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 22:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5CE61668
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 06:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379A1C433D2;
        Thu,  9 Mar 2023 06:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678342747;
        bh=LTk3JCHGRe+TyYuQNOCTiDP23OkmIB+aL1dSoQuWeMk=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=TY6vA2YsJQg0fllmqZUrI3ydXqchsea80kIMp4OlFQ36O3/hXTXn+bmKxey5p/uY1
         4CEWCY7lCrBnvoVTWNFY9mZoaWImUB/4IgT872Ou0bTEBXbFJNiuHgOco6hYbH6s5y
         EmjPOWV1MoQDF2tclgTGOt3YbWN/UDE15aBp2c6vAUgZ3+MICD/fO13Ov1yHMgm+qJ
         AfvEeRpDW191ZsgFEUQpnwquklZ5qJAbYT940K5xO+rPQLfH0Uii+M7dYpQ7w0Mf3i
         AmtRHY2TpjLT41EPCAsgA1qtlYHIi/DC+v3uv9cluKnwH+3QfX/4JXkGQidqeiWXto
         DQzTWVkV9lacQ==
Date:   Thu, 09 Mar 2023 06:19:00 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jessica Clarke <jrtc27@jrtc27.com>
CC:     Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Nathan Chancellor <nathan@kernel.org>,
        naresh.kamboju@linaro.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, aurelien@aurel32.net,
        ndesaulniers@google.com, Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH v2] RISC-V: remove I-extension ISA spec version dance
User-Agent: K-9 Mail for Android
In-Reply-To: <3476D6EF-F7DD-4437-A71C-47EF05210AF3@jrtc27.com>
References: <20230308220842.1231003-1-conor@kernel.org> <3476D6EF-F7DD-4437-A71C-47EF05210AF3@jrtc27.com>
Message-ID: <DCDDEB71-B9CF-4F35-BFA6-CAD4F5B0ED74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9 March 2023 02:19:38 GMT, Jessica Clarke <jrtc27@jrtc27=2Ecom> wrote:
>On 8 Mar 2023, at 22:08, Conor Dooley <conor@kernel=2Eorg> wrote:
>>=20
>> From: Conor Dooley <conor=2Edooley@microchip=2Ecom>
>>=20
>> The spec folk, in their infinite wisdom, moved both control and status
>> registers & the FENCE=2EI instructions out of the I extension into thei=
r
>> own extensions (Zicsr, Zifencei) in the 20190608 version of the ISA
>> spec [0]=2E
>> The GCC/binutils crew decided [1] to move their default version of the
>> ISA spec to the 20191213 version of the ISA spec, which came into being
>> for version 2=2E38 of binutils and GCC 12=2E Building with this toolcha=
in
>> configuration would result in assembler issues:
>>  CC      arch/riscv/kernel/vdso/vgettimeofday=2Eo
>>  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday=2Eh: Assembler m=
essages:
>>  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday=2Eh:71: Error: u=
nrecognized opcode `csrr a5,0xc01'
>>  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday=2Eh:71: Error: u=
nrecognized opcode `csrr a5,0xc01'
>>  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday=2Eh:71: Error: u=
nrecognized opcode `csrr a5,0xc01'
>>  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday=2Eh:71: Error: u=
nrecognized opcode `csrr a5,0xc01'
>> This was fixed in commit 6df2a016c0c8 ("riscv: fix build with binutils
>> 2=2E38") by Aurelien Jarno, but has proven fragile=2E
>>=20
>> Before LLVM 17, LLVM did not support these extensions and, as such, the
>> cc-option check added by Aurelien worked=2E Since commit 22e199e6afb1
>> ("[RISCV] Accept zicsr and zifencei command line options") however, LLV=
M
>> *does* support them and the cc-option check passes=2E
>>=20
>> This surfaced as a problem while building the 5=2E10 stable kernel usin=
g
>> the default Tuxmake Debian image [2], as 5=2E10 did not yet support ld=
=2Elld,
>> and uses the Debian provided binutils 2=2E35=2E
>> Versions of ld prior to 2=2E38 will refuse to link if they encounter
>> unknown ISA extensions, and unfortunately Zifencei is not supported by
>> bintuils 2=2E35=2E
>>=20
>> Instead of dancing around with adding these extensions to march, as we
>> currently do, Palmer suggested locking GCC builds to the same version o=
f
>> the ISA spec that is used by LLVM=2E As far as I can tell, that is 2=2E=
2,
>> with, apparently [3], a lack of interest in implementing a flag like
>> GCC's -misa-spec at present=2E
>>=20
>> Add {cc,as}-option checks to add -misa-spec to KBUILD_{A,C}FLAGS when
>> GCC is used & remove the march dance=2E
>>=20
>> As clang does not accept this argument, I had expected to encounter
>> issues with the assembler, as neither zicsr nor zifencei are present in
>> the ISA string and the spec version *should* be defaulting to a version
>> that requires them to be present=2E The build passed however and the
>> resulting kernel worked perfectly fine for me on a PolarFire SoC=2E=2E=
=2E
>
>For what it=E2=80=99s worth, LLVM is likely to move from only supporting =
the
>old ratified spec to only supporting the latest one, with no ugly
>-misa-spec like the GNU world=2E You may therefore wish to reconsider
>this=2E=2E=2E

Oh well, at least we tried=2E Back to the Kconfig way of doing it I suppos=
e=2E=2E=2E

>
>Jess
>
>> Link: https://riscv=2Eorg/wp-content/uploads/2019/06/riscv-spec=2Epdf [=
0]
>> Link: https://groups=2Egoogle=2Ecom/a/groups=2Eriscv=2Eorg/g/sw-dev/c/a=
E1ZeHHCYf4 [1]
>> Link: https://lore=2Ekernel=2Eorg/all/CA+G9fYt9T=3DELCLaB9byxaLW2Qf4pZc=
DO=3DhuCA0D8ug2V2+irJQ@mail=2Egmail=2Ecom/ [2]
>> Link: https://discourse=2Ellvm=2Eorg/t/specifying-unpriviledge-spec-ver=
sion-misa-spec-gcc-flag-equivalent/66935 [3]
>> CC: stable@vger=2Ekernel=2Eorg
>> Suggested-by: Palmer Dabbelt <palmer@rivosinc=2Ecom>
>> Reported-by: Naresh Kamboju <naresh=2Ekamboju@linaro=2Eorg>
>> Signed-off-by: Conor Dooley <conor=2Edooley@microchip=2Ecom>
>> ---
>> I think Aurelien's original commit message might actually not be quite
>> correct? I found, in my limited testing, that it is not the default
>> behaviour of gas that matters, but rather the toolchain itself?
>> My binutils versions (both those built using the clang-built-linux
>> tc-build scripts which do not set an ISA spec version, and one built
>> using the riscv-gnu-toolchain infra w/ an explicit 20191213 spec versio=
n
>> set) do not encounter these issues=2E
>> From *my* testing, I was only able to reproduce the above build failure=
s
>> because of *GCC* defaulting to a newer ISA spec version, and saw no
>> issues with CC=3Dclang builds, where -misa-spec is not (AFAICT) passed =
to
>> gas=2E
>> I'm far from a toolchain person, so I am very very happy to have the
>> reason for that explained to me, as I've been scratching my head about
>> it all evening=2E
>>=20
>> I'm also not super confident in my "as-option"ing, but it worked for me=
,
>> so it's gotta be perfect, right? riiight??
>>=20
>> Changes from v1:
>> - entirely new approach to the issue
>> ---
>> arch/riscv/Makefile | 6 ++----
>> 1 file changed, 2 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>> index 6203c3378922=2E=2E2df7a5dc071c 100644
>> --- a/arch/riscv/Makefile
>> +++ b/arch/riscv/Makefile
>> @@ -57,10 +57,8 @@ riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
>> riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
>> riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
>>=20
>> -# Newer binutils versions default to ISA spec version 20191213 which m=
oves some
>> -# instructions from the I extension to the Zicsr and Zifencei extensio=
ns=2E
>> -toolchain-need-zicsr-zifencei :=3D $(call cc-option-yn, -march=3D$(ris=
cv-march-y)_zicsr_zifencei)
>> -riscv-march-$(toolchain-need-zicsr-zifencei) :=3D $(riscv-march-y)_zic=
sr_zifencei
>> +KBUILD_CFLAGS +=3D $(call cc-option,-misa-spec=3D2=2E2)
>> +KBUILD_AFLAGS +=3D $(call as-option,-Wa$(comma)-misa-spec=3D2=2E2)
>>=20
>> # Check if the toolchain supports Zihintpause extension
>> riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) :=3D $(riscv-march-y)_z=
ihintpause
>> --=20
>> 2=2E39=2E2
>>=20
>>=20
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists=2Einfradead=2Eorg
>> http://lists=2Einfradead=2Eorg/mailman/listinfo/linux-riscv
>
