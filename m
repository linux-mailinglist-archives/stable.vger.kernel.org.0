Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3072F7764
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbhAOLQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 06:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbhAOLQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 06:16:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C690224F9;
        Fri, 15 Jan 2021 11:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610709325;
        bh=l6kjuUdwH1J+0RSW3wOI8b+Ktrck5Pp8whJGF52QkIE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PD/jyBuFD2zBhD/OKowdt7KUWwTIyVCxfiXOKXd/u8LnOCRaTxgyl0c/dKc204zAl
         MFkS1prtkZoWd3JY6bRSz/ESUYjdsatSAcWeMzMHV59Q/wnhLbOpLX/lMeE3Jn9klf
         egE12hfzBfcmhrBKz4x3+iE3T3GOTBQFJ0HiknW3CrCy4rRoezLB2RrvfYhgGqCx3R
         hhXh4Iv8/qru2WVCA4LYvShzcB65v04yIFSfIea8fl1D+3k+HIqOPNJzF2AWaEzAwG
         nIWjSQkSF1Vgw68u8WIzLjnokG/XNLsi2h8F7A8tpZBhS7M27y0iqLGi1JIn412d10
         Q3nXe7uVrMHSw==
Received: by mail-ot1-f53.google.com with SMTP id n42so8140977ota.12;
        Fri, 15 Jan 2021 03:15:25 -0800 (PST)
X-Gm-Message-State: AOAM531V9ZeU814aJUIXp/MKTtAvb8T+qa7j9cLE3DbJkgyNRsw6bdYK
        QWLqDrxXYOrLWE3vPox/fB8QtIgkDS9Tw1tQ7oU=
X-Google-Smtp-Source: ABdhPJxdT2yiEyJyQ1PSbCV6Z82EpynBxTRjdqIE6EVKUyyA7+bqwnepWK2E/W6nJKmTGyHoKeCVn1KG1j/QiHnz1v0=
X-Received: by 2002:a9d:741a:: with SMTP id n26mr615881otk.210.1610709324684;
 Fri, 15 Jan 2021 03:15:24 -0800 (PST)
MIME-Version: 1.0
References: <20210110115245.30762-1-alobakin@pm.me> <202101111153.AE5123B6@keescook>
 <20210111205649.18263-1-alobakin@pm.me> <20210111224305.GA22825@alpha.franken.de>
In-Reply-To: <20210111224305.GA22825@alpha.franken.de>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 15 Jan 2021 12:15:08 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2oUzcmN01RN==2zzhAiHHP-1rAScsp=nN=v6rWP+eekg@mail.gmail.com>
Message-ID: <CAK8P3a2oUzcmN01RN==2zzhAiHHP-1rAScsp=nN=v6rWP+eekg@mail.gmail.com>
Subject: Re: [PATCH v5 mips-next 0/9] MIPS: vmlinux.lds.S sections fixes & cleanup
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 11:44 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
> On Mon, Jan 11, 2021 at 08:57:25PM +0000, Alexander Lobakin wrote:
> > From: Kees Cook <keescook@chromium.org>
> > Date: Mon, 11 Jan 2021 11:53:39 -0800
> >
> > > On Sun, Jan 10, 2021 at 11:53:50AM +0000, Alexander Lobakin wrote:
> > >> This series hunts the problems discovered after manual enabling of
> > >> ARCH_WANT_LD_ORPHAN_WARN. Notably:
> > >>  - adds the missing PAGE_ALIGNED_DATA() section affecting VDSO
> > >>    placement (marked for stable);
> > >>  - stops blind catching of orphan text sections with .text.*
> > >>    directive;
> > >>  - properly stops .eh_frame section generation.
> > >>
> > >> Compile and runtime tested on MIPS32R2 CPS board with no issues
> > >> using two different toolkits:
> > >>  - Binutils 2.35.1, GCC 10.2.1 (with Alpine patches);
> > >>  - LLVM stack: 11.0.0 and from latest Git snapshot.
> > >>
> > >> Since v4 [3]:
> > >>  - new: drop redundant .text.cps-vec creation and blind inclusion
> > >>    of orphan text sections via .text.* directive in vmlinux.lds.S;
> > >>  - don't assert SIZEOF(.rel.dyn) as it's reported that it may be not
> > >>    empty on certain machines and compilers (Thomas);
> > >>  - align GOT table like it's done for ARM64;
> > >>  - new: catch UBSAN's "unnamed data" sections in generic definitions
> > >>    when building with LD_DEAD_CODE_DATA_ELIMINATION;
> > >>  - collect Reviewed-bys (Kees, Nathan).
> > >
> > > Looks good; which tree will this land through?
> >
> > linux-mips/mips-next I guess, since 7 of 9 patches are related only
> > to this architecture.
> > This might need Arnd's Acked-bys or Reviewed-by for the two that
> > refer include/asm-generic, let's see what Thomas think.
>
> Looks good from my side and I have it already sitting in branch for
> submission.
>
> Arnd, are you ok with the changes in include/asm-generic ?

Yes, I'm never quite sure about what to make of linker script changes,
but I trust Kees on the review. For merging it through your tree:

Acked-by: Arnd Bergmann <arnd@arndb.de>
