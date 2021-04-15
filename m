Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D999361092
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhDOQ6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 12:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhDOQ6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 12:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EB1B60231;
        Thu, 15 Apr 2021 16:57:51 +0000 (UTC)
Date:   Thu, 15 Apr 2021 17:57:48 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jian Cai <jiancai@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: alternatives: Move length validation in
 alternative_{insn,endif}
Message-ID: <20210415165748.GG1015@arm.com>
References: <20210414000803.662534-1-nathan@kernel.org>
 <20210415091743.GB1015@arm.com>
 <YHg+5RSG4XPLlZD8@archlinux-ax161>
 <20210415140224.GE1015@arm.com>
 <CABCJKufDUgPSRQi1ZQRk=upNtziKDJ8rTBHgq2oQpPWS=utrvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufDUgPSRQi1ZQRk=upNtziKDJ8rTBHgq2oQpPWS=utrvg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 08:50:25AM -0700, Sami Tolvanen wrote:
> On Thu, Apr 15, 2021 at 7:02 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > On Thu, Apr 15, 2021 at 06:25:57AM -0700, Nathan Chancellor wrote:
> > > On Thu, Apr 15, 2021 at 10:17:43AM +0100, Catalin Marinas wrote:
> > > > On Tue, Apr 13, 2021 at 05:08:04PM -0700, Nathan Chancellor wrote:
> > > > > After commit 2decad92f473 ("arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
> > > > > set atomically"), LLVM's integrated assembler fails to build entry.S:
> > > > >
> > > > > <instantiation>:5:7: error: expected assembly-time absolute expression
> > > > >  .org . - (664b-663b) + (662b-661b)
> > > > >       ^
> > > > > <instantiation>:6:7: error: expected assembly-time absolute expression
> > > > >  .org . - (662b-661b) + (664b-663b)
> > > > >       ^
> > > >
> > > > I tried the latest Linus' tree and linux-next (defconfig) with this
> > > > commit in and I can't get your build error. I used both clang-10 from
> > > > Debian stable and clang-11 from Debian sid. So, which clang version did
> > > > you use or which kernel config options?
> > >
> > > Interesting, this reproduces for me with LLVM 12 or newer with just
> > > defconfig.
> >
> > It fails for me as well with clang-12. Do you happen to know why it
> > works fine with previous clang versions?
> 
> It looks like CONFIG_ARM64_AS_HAS_MTE is not set when we use the
> integrated assembler with LLVM 11, and the code that breaks later
> versions is gated behind CONFIG_ARM64_MTE.

That explains it, thanks.

-- 
Catalin
