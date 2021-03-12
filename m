Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417233389C2
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhCLKM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhCLKM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:12:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D95164FC9;
        Fri, 12 Mar 2021 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615543947;
        bh=szU/tGZ5C03a+0bwnOIPWWvKSVxgqid8m0TghrlLUKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtQGEfdHMK9QjmaY3RfCbo8U5qIXE4NVcaoENk1+aZMf1zIqltxDo1g98HBNzXGZM
         cMuvaMi080oGMPExtmYB4Uah/RHFIgjjb+yISQA4aKUEFs1wFWWPQJDiPzlFlkH4zQ
         R1c1YIk/cxjBOJUnnont3StFjZ7IzQZYClYGWjsw=
Date:   Fri, 12 Mar 2021 11:12:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YEs+iaQzEQYNgXcw@kroah.com>
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 11:32:22AM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider merging the following patch series'.  They enable
> clang's integrated assembler to be used to assemble ARCH=arm kernels
> back to linux-4.19.y.  This is analogous to previous series' sent for
> LLVM_IAS=1 support, but focused on ARM (32b).
> 
> Below is the list of commits in each series, in the form
> <first tag of mainline containing sha> <sha12> <commit oneline>
> 
> For 5.10:
> v5.11-rc1 3c9f5708b7ae ("ARM: 9029/1: Make iwmmxt.S support Clang's
> integrated assembler")
> v5.11-rc1 0b1674638a5c ("ARM: assembler: introduce adr_l, ldr_l and
> str_l macros")
> v5.11-rc1 67e3f828bd4b ("ARM: efistub: replace adrl pseudo-op with
> adr_l macro invocation")
> 
> For 5.4:
> v5.5-rc1 b4d0c0aad57a ("crypto: arm - use Kconfig based compiler
> checks for crypto opcodes")
> v5.5-rc1 9f1984c6ae30 ("ARM: 8929/1: use APSR_nzcv instead of r15 as
> mrc operand")
> v5.5-rc1 790756c7e022 ("ARM: 8933/1: replace Sun/Solaris style flag on
> section directive")
> v5.6-rc1 42d519e3d0c0 ("kbuild: Add support for 'as-instr' to be used
> in Kconfig files")
> v5.7-rc1 7548bf8c17d8 ("crypto: arm/ghash-ce - define fpu before fpu
> registers are referenced")
> v5.8-rc1 d85d5247885e ("ARM: OMAP2+: drop unnecessary adrl")
> v5.8-rc1 a780e485b576 ("ARM: 8971/1: replace the sole use of a symbol
> with its definition")
> v5.8-rc1 b744b43f79cc ("kbuild: add CONFIG_LD_IS_LLD")
> v5.9-rc1 a6c30873ee4a ("ARM: 8989/1: use .fpu assembler directives
> instead of assembler arguments")
> v5.9-rc1 ee440336e5ef ("ARM: 8990/1: use VFP assembler mnemonics in
> register load/store macros")
> v5.9-rc1 2cbd1cc3dcd3 ("ARM: 8991/1: use VFP assembler mnemonics if available")
> v5.10-rc1 54781938ec34 ("crypto: arm/sha256-neon - avoid ADRL pseudo
> instruction")
> v5.10-rc1 0f5e8323777b ("crypto: arm/sha512-neon - avoid ADRL pseudo
> instruction")
> v5.11-rc1 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends
> on !LD_IS_LLD")
> 
> Then 3c9f5708b7ae from the 5.10 series is applied (0b1674638a5c and
> 67e3f828bd4b were not necessary). 28187dc8ebd9 had previously been
> picked up into 5.10 automatically. There was a minor conflict in
> 2cbd1cc3dcd3 due to 5.10 missing 8a90a3228b6a ("arm: Unplug KVM from
> the build system").
> 
> b744b43f79cc and 28187dc8ebd9 are more specifically for allmodconfig
> support than strictly LLVM_IAS=1.
> 
> For 4.19:
> v4.20-rc1 d3c61619568c ("ARM: 8788/1: ftrace: remove old mcount support")
> v4.20-rc1 f9b58e8c7d03 ("ARM: 8800/1: use choice for kernel unwinders")
> v5.1-rc1 baf2df8e15be ("ARM: 8827/1: fix argument count to match macro
> definition")
> v5.1-rc1 32fdb046ac43 ("ARM: 8828/1: uaccess: use unified assembler
> language syntax")
> v5.1-rc1 eb7ff9023e4f ("ARM: 8829/1: spinlock: use unified assembler
> language syntax")
> v5.1-rc1 a216376add73 ("ARM: 8841/1: use unified assembler in macros")
> v5.1-rc1 e44fc38818ed ("ARM: 8844/1: use unified assembler in assembly files")
> v5.2-rc1 fe09d9c641f2 ("ARM: 8852/1: uaccess: use unified assembler
> language syntax")
> v5.2-rc1 3ab2b5fdd1d8 ("ARM: mvebu: drop unnecessary label")
> v5.2-rc1 969ad77c14ab ("ARM: mvebu: prefix coprocessor operand with p")
> v5.3-rc1 3fe1ee40b2a2 ("ARM: use arch_extension directive instead of
> arch argument")
> v5.4-rc3 3aa6d4abd4eb ("crypto: arm/aes-ce - build for v8 architecture
> explicitly")
> 
> Then the entire 5.4 series is applied on top. 3fe1ee40b2a2 had a minor
> conflict due to 4.19 missing 2997520c2d4e ("ARM: exynos: Set MCPM as
> mandatory for Exynos542x/5800 SoCs").
> 
> I plan to send some follow ups; I need to do another pass to find what
> we may need in addition when setting CONFIG_THUMB2_KERNEL=y
> (non-default), there are two patches working their way through the ARM
> maintainer's tree needed for allmodconfig
> (https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9061/1
> and https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9062/1)
> and v4.19.y has one more issue I need to look into
> (https://github.com/ClangBuiltLinux/linux/issues/1329) that has been
> cleaned up by a 7 patch series that landed in v5.2-rc1, but on first
> glance I suspect might be an assembler bug for us to fix.
> 
> These series will be used in Android and ChromeOS. We're also ready to
> wire up CI coverage for LLVM_IAS=1 ARCH=arm for these branches.

You still have odd Android/ChromeOS things in these patches ("FROMLIST",
Change-ID, etc.)

Please fix them up, as-is, we can't take these.

thanks,

greg k-h
