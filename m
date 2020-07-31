Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2E233F6B
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 08:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgGaGt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 02:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731365AbgGaGt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 02:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAE620829;
        Fri, 31 Jul 2020 06:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596178167;
        bh=xPd3z35wKS3rDjjx7Vmt9THjpc672VJ9ztW3nUpT64Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Q3ICI1V39uoTR2bahOLTiWRuZyStsuQCSxAxlu3tuLNDDdxXkZye4aTApfmI09oP
         mHeFkactbMxsGxOovfmNKBOEAIKsfLtXqMC8MYm5S6d+4VpFoyQ4kKVEHJXVQtgTz7
         tfmLFxdi77Lk/PFCuX5bsTfFP/eQ6cIbQf7fE7HU=
Date:   Fri, 31 Jul 2020 08:49:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64/alternatives: move length validation inside the
 subsection
Message-ID: <20200731064915.GI1508201@kroah.com>
References: <20200729215152.662225-1-samitolvanen@google.com>
 <20200730122201.GM25149@gaia>
 <CABCJKucS-DXPkHMCPKpbFduZApRdw=1DL4+YhULAsUNn=o-dTA@mail.gmail.com>
 <20200730152330.GA3128@gaia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730152330.GA3128@gaia>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 04:23:31PM +0100, Catalin Marinas wrote:
> On Thu, Jul 30, 2020 at 08:13:05AM -0700, Sami Tolvanen wrote:
> > On Thu, Jul 30, 2020 at 5:22 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > >
> > > On Wed, Jul 29, 2020 at 02:51:52PM -0700, Sami Tolvanen wrote:
> > > > Commit f7b93d42945c ("arm64/alternatives: use subsections for replacement
> > > > sequences") breaks LLVM's integrated assembler, because due to its
> > > > one-pass design, it cannot compute instruction sequence lengths before the
> > > > layout for the subsection has been finalized. This change fixes the build
> > > > by moving the .org directives inside the subsection, so they are processed
> > > > after the subsection layout is known.
> > > >
> > > > Link: https://github.com/ClangBuiltLinux/linux/issues/1078
> > > > Cc: <stable@vger.kernel.org> # 4.14+
> > >
> > > Commit f7b93d42945c went in 5.8-rc4. Why is this cc stable from 4.14? If
> > > Will picks it up for 5.8, it doesn't even need a cc stable.
> > 
> > Greg or Sasha can probably answer why, but this patch is in 4.14.189,
> > 4.19.134, 5.4.53, and 5.7.10, which ended up breaking some downstream
> > Android kernel builds.
> 
> I see but I don't think we need the explicit cc stable for 4.14. That's
> why the Fixes tag is important. If a patch was back-ported, the
> subsequent fixes should be picked by the stable maintainers as well.

If you know it ahead of time, the explict "# kernel.version" hint is
always nice to have as it ensures I will try to backport it that far,
and if I have problems, I will ask for help.

thanks,

greg k-h
