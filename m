Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442AD6D243C
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 17:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCaPmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 11:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbjCaPmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 11:42:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312E01DFA6;
        Fri, 31 Mar 2023 08:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2B9FB83081;
        Fri, 31 Mar 2023 15:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82024C433AA;
        Fri, 31 Mar 2023 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680277370;
        bh=MDMgoc2IHS3flEDrGytsmQQeZFpux/6WiPc3RwT4puI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KWP9HPhTUvEN7mYuxZPxlkF9Hl4S+oz79fLOt03iQof2x7wP1wOPeSbl9oenZyFrQ
         fkDVPvQe5EUtdywvNQCWWcj7+r87TalOf+BPYuacQ2p1R6v/ePP33qPL8LzC+eU2xO
         s1W/QtS443bcYDdsN8uY5Cjvf3MzPXY5p4ZFjS3i1w306JKYM5VqXtdK6qe7ySxce9
         VJoiB1rjWIUZASVQBZeVMhZYDh00vVW1OSd4xWx1hf69M1b4sdmS+D+f/CinScQgcb
         xFZ+rNIpK+I1kT7u0Wj87x17ousfsfA6X04sI5JZXryQjh5NiOquyoDPdKlC+l22La
         aywDmtF2nKWAg==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-177b78067ffso23580301fac.7;
        Fri, 31 Mar 2023 08:42:50 -0700 (PDT)
X-Gm-Message-State: AAQBX9fA7tpbx/KjWdeDjSIzvx6WmuwCGaYF9EqLG0PYYcIQBWtM2R5a
        zvATw8pv9tw/Tp/vXIsJoWuOQlgBI5yDwUZCYm0=
X-Google-Smtp-Source: AKy350ZKdZjJtD7mXFXhuBEd3X3QxuVbk6K1rSdL3mLEnsD4V+CltTewuKSddNWpcoR4U4lyRHFFTL+c+TbiUqnDZcc=
X-Received: by 2002:a05:6871:2797:b0:17e:9b69:3ee5 with SMTP id
 zd23-20020a056871279700b0017e9b693ee5mr9426869oab.11.1680277369598; Fri, 31
 Mar 2023 08:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230330182223.181775-1-hi@alyssa.is> <20230330222928.GA644044@dev-arch.thelio-3990X>
In-Reply-To: <20230330222928.GA644044@dev-arch.thelio-3990X>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 1 Apr 2023 00:42:13 +0900
X-Gmail-Original-Message-ID: <CAK7LNARU444UrZXVodNftud-scy5KKUjdtTM0GOrxHB9pyKmkg@mail.gmail.com>
Message-ID: <CAK7LNARU444UrZXVodNftud-scy5KKUjdtTM0GOrxHB9pyKmkg@mail.gmail.com>
Subject: Re: [PATCH v3] purgatory: fix disabling debug info
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Alyssa Ross <hi@alyssa.is>, Nick Cao <nickcao@nichi.co>,
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

On Fri, Mar 31, 2023 at 7:29=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> On Thu, Mar 30, 2023 at 06:22:24PM +0000, Alyssa Ross wrote:
> > Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> > Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> > -Wa versions of both of those if building with Clang and GNU as.  As a
> > result, debug info was being generated for the purgatory objects, even
> > though the intention was that it not be.
> >
> > Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files=
")
> > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > Cc: stable@vger.kernel.org
> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
>
> This is definitely more future proof.
>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>



I prefer v3 since it is cleaner, but unfortunately
it does not work for Clang+GAS.


With v3 applied, I still see the debug info.



$ make LLVM=3D1 LLVM_IAS=3D0  arch/x86/purgatory/setup-x86_64.o
  UPD     include/config/kernel.release
  UPD     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
  INSTALL libsubcmd_headers
  AS      arch/x86/purgatory/setup-x86_64.o
$ readelf -S arch/x86/purgatory/setup-x86_64.o
There are 18 section headers, starting at offset 0x14d8:

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .text             PROGBITS         0000000000000000  00000040
       0000000000000027  0000000000000000  AX       0     0     16
  [ 2] .rela.text        RELA             0000000000000000  000012f8
       0000000000000060  0000000000000018   I      15     1     8
  [ 3] .data             PROGBITS         0000000000000000  00000067
       0000000000000000  0000000000000000  WA       0     0     1
  [ 4] .bss              NOBITS           0000000000000000  00001000
       0000000000001000  0000000000000000  WA       0     0     4096
  [ 5] .rodata           PROGBITS         0000000000000000  00001000
       0000000000000020  0000000000000000   A       0     0     16
  [ 6] .rela.rodata      RELA             0000000000000000  00001358
       0000000000000018  0000000000000018   I      15     5     8
  [ 7] .debug_line       PROGBITS         0000000000000000  00001020
       000000000000005f  0000000000000000           0     0     1
  [ 8] .rela.debug_line  RELA             0000000000000000  00001370
       0000000000000018  0000000000000018   I      15     7     8
  [ 9] .debug_info       PROGBITS         0000000000000000  0000107f
       0000000000000027  0000000000000000           0     0     1
  [10] .rela.debug_info  RELA             0000000000000000  00001388
       0000000000000090  0000000000000018   I      15     9     8
  [11] .debug_abbrev     PROGBITS         0000000000000000  000010a6
       0000000000000014  0000000000000000           0     0     1
  [12] .debug_aranges    PROGBITS         0000000000000000  000010c0
       0000000000000030  0000000000000000           0     0     16
  [13] .rela.debug_[...] RELA             0000000000000000  00001418
       0000000000000030  0000000000000018   I      15    12     8
  [14] .debug_str        PROGBITS         0000000000000000  000010f0
       0000000000000054  0000000000000001  MS       0     0     1
  [15] .symtab           SYMTAB           0000000000000000  00001148
       0000000000000168  0000000000000018          16    12     8
  [16] .strtab           STRTAB           0000000000000000  000012b0
       0000000000000041  0000000000000000           0     0     1
  [17] .shstrtab         STRTAB           0000000000000000  00001448
       000000000000008d  0000000000000000           0     0     1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)






With -g0 given, GCC stops passing -g -gdwarf-4 down to GAS.


Clang does not do anything about -g0 for the external assembler.




I was thinking of dropping LLVM_IAS=3D0 support.
When we decide to give up -fno-integrated-as,
we can clean up the code in various places.


Anyway, v3 does not work in the current situation.


V2 works for all usecases.




--=20
Best Regards
Masahiro Yamada
