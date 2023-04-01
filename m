Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968CB6D2C56
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjDABJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbjDABJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:09:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61351BF48;
        Fri, 31 Mar 2023 18:09:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CDBE62CD9;
        Sat,  1 Apr 2023 01:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0373C433A1;
        Sat,  1 Apr 2023 01:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680311355;
        bh=/LTUz3eEbeLJ0Mp6IRD/RWbRrFGs0YZv3TWcnSN0CV0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lqX2jOkISgAicmlN3IB0/2Xe7FK88Yr8f6O2Vcn1f7VBk92gJ34hJ03ZUjg2X1O2w
         MXyMILjQhdjZUGAN8EqK9PbxIXdOarz/nOStjk3jyujc64UrBY3NxliGICbkiWOLeD
         tESbK0fSdiitrGY8qn70TV3day/iRt7TQWxxLH6aeKyGIbEXQPDPfeLcOCKHBbRCGd
         kPtXKukgdaHmAbR62dbTXUDRHHWYFDqubsY023yacltLnh7xSTTFwGeWv8IRmcEofA
         ZgLx++fmhFB5xBUtIZ86Pca07pCzaG9Tn59xmMf1X57+SIGxgWeJtnDV7+SA5X+ro7
         sL9fm4QxIzRkA==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-17aeb49429eso24988399fac.6;
        Fri, 31 Mar 2023 18:09:15 -0700 (PDT)
X-Gm-Message-State: AAQBX9f3rMnV2r5jhcH/0zo+y+GYsA4fbQkGF17yNcZ29B0/yqx9vAq0
        4vH2qzPAUTKhw8J80r+yTb+MVgUJFDs2jK9d2c8=
X-Google-Smtp-Source: AKy350ZGV1y0Nf0JZUb3XIQPYwf+PbORdDoVmjq9Gbwo2taA1C6i3WK4Xuu0kG0Hz6DIl7RRQWz6KWjQN65WQgfG23k=
X-Received: by 2002:a05:6870:d20f:b0:16e:8993:9d7c with SMTP id
 g15-20020a056870d20f00b0016e89939d7cmr5363652oac.1.1680311354924; Fri, 31 Mar
 2023 18:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230330182223.181775-1-hi@alyssa.is> <20230330222928.GA644044@dev-arch.thelio-3990X>
 <CAK7LNARU444UrZXVodNftud-scy5KKUjdtTM0GOrxHB9pyKmkg@mail.gmail.com> <20230331202716.mvny65ybaat3wsmm@x220>
In-Reply-To: <20230331202716.mvny65ybaat3wsmm@x220>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 1 Apr 2023 10:08:37 +0900
X-Gmail-Original-Message-ID: <CAK7LNATN7hQFXx+Y5PguD9mvcP0-jadXxU_5WP4YQuHgKeyD1w@mail.gmail.com>
Message-ID: <CAK7LNATN7hQFXx+Y5PguD9mvcP0-jadXxU_5WP4YQuHgKeyD1w@mail.gmail.com>
Subject: Re: [PATCH v3] purgatory: fix disabling debug info
To:     Alyssa Ross <hi@alyssa.is>
Cc:     Nathan Chancellor <nathan@kernel.org>, Nick Cao <nickcao@nichi.co>,
        linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 1, 2023 at 5:27=E2=80=AFAM Alyssa Ross <hi@alyssa.is> wrote:
>
> On Sat, Apr 01, 2023 at 12:42:13AM +0900, Masahiro Yamada wrote:
> > On Fri, Mar 31, 2023 at 7:29=E2=80=AFAM Nathan Chancellor <nathan@kerne=
l.org> wrote:
> > >
> > > On Thu, Mar 30, 2023 at 06:22:24PM +0000, Alyssa Ross wrote:
> > > > Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAG=
S.
> > > > Instead, it includes -g, the appropriate -gdwarf-* flag, and also t=
he
> > > > -Wa versions of both of those if building with Clang and GNU as.  A=
s a
> > > > result, debug info was being generated for the purgatory objects, e=
ven
> > > > though the intention was that it not be.
> > > >
> > > > Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S f=
iles")
> > > > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > > > Cc: stable@vger.kernel.org
> > > > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > >
> > > This is definitely more future proof.
> > >
> > > Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> > > Tested-by: Nathan Chancellor <nathan@kernel.org>
> >
> >
> >
> > I prefer v3 since it is cleaner, but unfortunately
> > it does not work for Clang+GAS.
> >
> >
> > With v3 applied, I still see the debug info.
> >
> >
> >
> > $ make LLVM=3D1 LLVM_IAS=3D0  arch/x86/purgatory/setup-x86_64.o
> >   UPD     include/config/kernel.release
> >   UPD     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   DESCEND objtool
> >   INSTALL libsubcmd_headers
> >   AS      arch/x86/purgatory/setup-x86_64.o
> > $ readelf -S arch/x86/purgatory/setup-x86_64.o
> > There are 18 section headers, starting at offset 0x14d8:
> >
> > Section Headers:
> >   [Nr] Name              Type             Address           Offset
> >        Size              EntSize          Flags  Link  Info  Align
> >   [ 0]                   NULL             0000000000000000  00000000
> >        0000000000000000  0000000000000000           0     0     0
> >   [ 1] .text             PROGBITS         0000000000000000  00000040
> >        0000000000000027  0000000000000000  AX       0     0     16
> >   [ 2] .rela.text        RELA             0000000000000000  000012f8
> >        0000000000000060  0000000000000018   I      15     1     8
> >   [ 3] .data             PROGBITS         0000000000000000  00000067
> >        0000000000000000  0000000000000000  WA       0     0     1
> >   [ 4] .bss              NOBITS           0000000000000000  00001000
> >        0000000000001000  0000000000000000  WA       0     0     4096
> >   [ 5] .rodata           PROGBITS         0000000000000000  00001000
> >        0000000000000020  0000000000000000   A       0     0     16
> >   [ 6] .rela.rodata      RELA             0000000000000000  00001358
> >        0000000000000018  0000000000000018   I      15     5     8
> >   [ 7] .debug_line       PROGBITS         0000000000000000  00001020
> >        000000000000005f  0000000000000000           0     0     1
> >   [ 8] .rela.debug_line  RELA             0000000000000000  00001370
> >        0000000000000018  0000000000000018   I      15     7     8
> >   [ 9] .debug_info       PROGBITS         0000000000000000  0000107f
> >        0000000000000027  0000000000000000           0     0     1
> >   [10] .rela.debug_info  RELA             0000000000000000  00001388
> >        0000000000000090  0000000000000018   I      15     9     8
> >   [11] .debug_abbrev     PROGBITS         0000000000000000  000010a6
> >        0000000000000014  0000000000000000           0     0     1
> >   [12] .debug_aranges    PROGBITS         0000000000000000  000010c0
> >        0000000000000030  0000000000000000           0     0     16
> >   [13] .rela.debug_[...] RELA             0000000000000000  00001418
> >        0000000000000030  0000000000000018   I      15    12     8
> >   [14] .debug_str        PROGBITS         0000000000000000  000010f0
> >        0000000000000054  0000000000000001  MS       0     0     1
> >   [15] .symtab           SYMTAB           0000000000000000  00001148
> >        0000000000000168  0000000000000018          16    12     8
> >   [16] .strtab           STRTAB           0000000000000000  000012b0
> >        0000000000000041  0000000000000000           0     0     1
> >   [17] .shstrtab         STRTAB           0000000000000000  00001448
> >        000000000000008d  0000000000000000           0     0     1
> > Key to Flags:
> >   W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
> >   L (link order), O (extra OS processing required), G (group), T (TLS),
> >   C (compressed), x (unknown), o (OS specific), E (exclude),
> >   D (mbind), l (large), p (processor specific)
> >
> >
> >
> >
> >
> >
> > With -g0 given, GCC stops passing -g -gdwarf-4 down to GAS.
> >
> >
> > Clang does not do anything about -g0 for the external assembler.
>
> You're right.  Thank you for your thoughtful testing =E2=80=94 I forgot t=
o check
> LLVM for v3.  I thought maybe adding -Wa,-g0 would be enough, but it
> turns out that GAS doesn't support that.  If -g has been specified,
> there doesn't seem to be any way to disable debug info again later in
> the command line.
>
> So we probably can't do better than v2 while LLVM_IAS=3D0 is supported.
> The only other option I see is (untested):
>
> asflags-y                       +=3D -g0
> asflags-remove-y                +=3D -Wa,-g -Wa,-gdwarf-4 -Wa,-gdwarf-5
>
> But I don't like that option, because it means there are two completely
> different ways of doing it depending on the compiler setup, and it makes
> it even less likely anybody would remember to update asflags-remove-y
> when DWARF 6 comes around or whatever.


Agree.
This is uglier than v2.



If nobody comes up with a better idea,
I will pick up v2.





--=20
Best Regards
Masahiro Yamada
