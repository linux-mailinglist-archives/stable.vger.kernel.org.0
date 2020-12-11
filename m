Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3592D789A
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436890AbgLKPA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436864AbgLKPAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:00:22 -0500
Date:   Fri, 11 Dec 2020 15:41:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607697619;
        bh=YZWjG44tGHvKO4V9UjSaMioY/KvLVesdB8kNjXXecx4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=E9cc2Uo11xdOwB6RLHYaLVlzlGN8GX2k23GEaoZYi/b4qJdisv6fRzOCBOO6hTDvX
         +OXUTOhSzRoqb1GYB4OrQiUAWiKnTO1nMkA9yxGZc17uInGzuUbvsABDLswWLuFVTf
         AmnIlg/T0RIjwAHkM5ozy1vOfJ4OIKwM4tVv0h80=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: 5.4 and 4.19 fix for LLVM_IAS/clang-12
Message-ID: <X9OFFjzAQQVN+qgm@kroah.com>
References: <CAKwvOdkK1LgLC4ChptzUTC45WvE9-Sn0OqtgF7-odNSw8xLTYA@mail.gmail.com>
 <a3b89f95-2635-ff9d-4248-4e5e3065ff85@kernel.org>
 <e9695da9-8b83-39a5-8781-47ae4c7d2e51@kernel.org>
 <CAKwvOdnUe3_fVCoxx2=bF=E8vsuOJMoZHzCfB0ES1dPU7q_PDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnUe3_fVCoxx2=bF=E8vsuOJMoZHzCfB0ES1dPU7q_PDw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 01:15:29PM -0800, Nick Desaulniers wrote:
> On Tue, Dec 8, 2020 at 11:21 PM Jiri Slaby <jirislaby@kernel.org> wrote:
> >
> > On 09. 12. 20, 8:20, Jiri Slaby wrote:
> > > On 09. 12. 20, 1:12, Nick Desaulniers wrote:
> > >> Dear stable kernel maintainers,
> > >> Please consider accepting the following backport to 5.4 and 4.19 of
> > >> commit 4d6ffa27b8e5 ("x86/lib: Change .weak to SYM_FUNC_START_WEAK for
> > >> arch/x86/lib/mem*_64.S"), attached.
> 
> Also, first landed in v5.10-rc3. Exists in v5.9.7 as
> 305da744c138487864a46b2fb0bd7cf54e1e03b4.
> 
> > >>
> > >> The patch to 5.4 had a conflict due to 5.4 missing upstream commit
> > >> e9b9d020c487 ("x86/asm: Annotate aliases") which first landed in
> > >> v5.5-rc1.
> > >>
> > >> The patch to 4.19 had a conflict due to 4.19 missing the above commit
> > >> and ffedeeb780dc ("linkage: Introduce new macros for assembler
> > >> symbols") which also first landed in v5.5-rc1 but was backported to
> > >> linux-5.4.y as commit 840d8c9b3e5f ("linkage: Introduce new macros for
> > >> assembler symbols") which shipped in v5.4.76.
> > >>
> > >> This patch fixes a build error from clang's assembler when building
> > >> with Clang-12, which now errors when symbols are redeclared with
> > >> different bindings.  We're using clang's assembler in Android and
> > >> ChromeOS for 4.19+.
> > >>
> > >> Jiri, would you mind reviewing the 4.19 patch (or both)?  It simply
> > >> open codes what the upstream macros would expand to; this can be and
> > >> was observed from running:
> > >
> > > You don't have to touch (expand) __memcpy, __memmove, and __memset, right?
> 
> Sure, attached a v2.  It's actually a little cleaner (smaller
> diffstat) that way.

Applied, thanks.

greg k-h
