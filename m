Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A285034197B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 11:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhCSKGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 06:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhCSKGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 06:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 790F060235;
        Fri, 19 Mar 2021 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616148368;
        bh=eWp5lAd1gpODtQ3dSZ/byW9xDrUbf5BEL+KEP2hOUuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MJKkK5+ALYme9v95Tf1I20ihxhqcYVcgi1wOgMvwg3S3nytFQ/KiqEyuyBMV+7wWo
         IO2kypRzFSX4egDTvxkvrRYWhoaV+gBpMl4sEHBM+mHCIjxVHHld+UnIlFPfxo4n+v
         vrmrnwkLg+Tn3Buoc8P2hDgCyTVcUk7wUh8Sj07c=
Date:   Fri, 19 Mar 2021 11:06:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     sashal@kernel.org, ardb@kernel.org, candle.sun@unisoc.com,
        catalin.marinas@arm.com, clang-built-linux@googlegroups.com,
        digetx@gmail.com, jiancai@google.com, keescook@chromium.org,
        linus.walleij@linaro.org, llozano@google.com, maz@kernel.org,
        miles.chen@mediatek.com, rmk+kernel@armlinux.org.uk,
        samitolvanen@google.com, srhines@google.com, sspatil@google.com,
        stable@vger.kernel.org, stefan@agner.ch,
        "kernelci.org bot" <bot@kernelci.org>
Subject: Re: [PATCH 5.4 2/2] ARM: 9044/1: vfp: use undef hook for VFP support
 detection
Message-ID: <YFR3jWxAdb7gJ1Cu@kroah.com>
References: <CAMj1kXGT8Zgz3Pn+DDJnY6HRz3ugbkFozJycGBW+Cm6RvyYBHA@mail.gmail.com>
 <20210316165918.1794549-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316165918.1794549-1-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 09:59:18AM -0700, Nick Desaulniers wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> commit 3cce9d44321e460e7c88cdec4e4537a6e9ad7c0d upstream.
> 
> Commit f77ac2e378be9dd6 ("ARM: 9030/1: entry: omit FP emulation for UND
> exceptions taken in kernel mode") failed to take into account that there
> is in fact a case where we relied on this code path: during boot, the
> VFP detection code issues a read of FPSID, which will trigger an undef
> exception on cores that lack VFP support.
> 
> So let's reinstate this logic using an undef hook which is registered
> only for the duration of the initcall to vpf_init(), and which sets
> VFP_arch to a non-zero value - as before - if no VFP support is present.
> 
> Fixes: f77ac2e378be9dd6 ("ARM: 9030/1: entry: omit FP emulation for UND ...")
> Reported-by: "kernelci.org bot" <bot@kernelci.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> This is meant to be applied on top of
> https://lore.kernel.org/stable/20210315231952.1482097-1-ndesaulniers@google.com/.
> If it's preferrable to send an .mbox file or a series with cover letter,
> I'm happy to resend it as such, just let me know.

Please resend it that way, makes it easier to figure out what is going
on here...

thanks,

greg k-h
