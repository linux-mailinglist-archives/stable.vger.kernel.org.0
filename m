Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB6D4570AC
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhKSObn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235888AbhKSObn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CD95619E3;
        Fri, 19 Nov 2021 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637332121;
        bh=1zPtGrRf73UpcTrvCjdzZojjth0LO3Mk7zMhuvz4ttY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=va1+bO8BMaFAuBvkg7XFi6V0mSzsbdis7w0FY3zFzR2mkwA/XXNK8qRNhMeJc9BGS
         tdxh0ekdAw5HAKxIjRfWLtl+EO7xps70ONfsbDUOHPsA5MZmjTB2rbkXqlnAItW1e+
         VLfNoLzLzflGSOIMdrY+kVNjzfqba/Le5sH7Hbz4=
Date:   Fri, 19 Nov 2021 15:28:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH 5.10] scripts/lld-version.sh: Rewrite based on upstream
 ld-version.sh
Message-ID: <YZe0lxrHLICffsUC@kroah.com>
References: <20211115164322.560965-1-nathan@kernel.org>
 <CAKwvOdnXGSkh4VM9Frn_OHMvdMpaXAH9dVsap34mKv7PcurrZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnXGSkh4VM9Frn_OHMvdMpaXAH9dVsap34mKv7PcurrZQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:50:01AM -0800, Nick Desaulniers wrote:
> On Mon, Nov 15, 2021 at 8:46 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > This patch is for linux-5.10.y only.
> >
> > When scripts/lld-version.sh was initially written, it did not account
> > for the LLD_VENDOR cmake flag, which changes the output of ld.lld's
> > --version flag slightly.
> >
> > Without LLD_VENDOR:
> >
> > $ ld.lld --version
> > LLD 14.0.0 (compatible with GNU linkers)
> >
> > With LLD_VENDOR:
> >
> > $ ld.lld --version
> > Debian LLD 14.0.0 (compatible with GNU linkers)
> >
> > As a result, CONFIG_LLD_VERSION is messed up and configuration values
> > that are dependent on it cannot be selected:
> >
> > scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> > scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> > scripts/lld-version.sh: 20: printf: LLD: expected numeric value
> > init/Kconfig:52:warning: 'LLD_VERSION': number is invalid
> > .config:11:warning: symbol value '00000' invalid for LLD_VERSION
> > .config:8800:warning: override: CPU_BIG_ENDIAN changes choice state
> >
> > This was fixed upstream by commit 1f09af062556 ("kbuild: Fix
> > ld-version.sh script if LLD was built with LLD_VENDOR") in 5.12 but that
> > was done to ld-version.sh after it was massively rewritten in
> > commit 02aff8592204 ("kbuild: check the minimum linker version in
> > Kconfig").
> >
> > To avoid bringing in that change plus its prerequisites and fixes, just
> > modify lld-version.sh to make it similar to the upstream ld-version.sh,
> > which handles ld.lld with or without LLD_VENDOR and ld.bfd without any
> > errors.
> >
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for the fix.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>

Now queued up, thanks.

greg k-h
