Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF0C3E5C39
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhHJNxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 09:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhHJNxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 09:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A5C60295;
        Tue, 10 Aug 2021 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628603562;
        bh=0pxQiHwlv5O2WEojRWriWbYYkFrCPIve7BAoLdArVsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qEEtohrcG1EUKK2c+wB0W2pTvC4aR1XmtTsnjb9xWBkWW74Fk2pW2uSiJaHF+0rN5
         OSJShqFkjO9TB7gOsQWqAJ2IosfcaoTjlUyZSVKnsdeOmOS98Z93k3RT3pgIbU7OFJ
         gQwoug16z4QgKF2v1DzrAiu+mCRfXJtQjf4pd34JniFShMTHb3pzt49plBR0nqofZM
         p0mTyParYgNuvP26wXI4DWQ6Blfue4+TewnBPKxSPG52VEr6d60WbsJlHJlo8pxd8r
         InsgZRkA4JRAFp/f0KQYl0G+RiXekkHg/Hx0M25lX01RHBFV84m7nrjz+C5OqNo2Y3
         MawnrvY5x7sTg==
Date:   Tue, 10 Aug 2021 14:52:36 +0100
From:   Will Deacon <will@kernel.org>
To:     Andrew Delgadillo <adelg@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, masahiroy@kernel.org
Subject: Re: [PATCH] arm64: clean vdso files
Message-ID: <20210810135236.GA3101@willie-the-truck>
References: <20210809191414.3572827-1-adelg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809191414.3572827-1-adelg@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+Masahiro]

On Mon, Aug 09, 2021 at 07:14:14PM +0000, Andrew Delgadillo wrote:
> commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
> changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
> vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':
> 
> $ make defconfig ARCH=arm64
> $ make ARCH=arm64
> $ make mrproper ARCH=arm64
> $ git clean -nxdf
> Would remove arch/arm64/kernel/vdso/vdso.lds
> Would remove arch/arm64/kernel/vdso/vdso.so
> Would remove arch/arm64/kernel/vdso/vdso.so.dbg
> 
> To remedy this, manually descend into arch/arm64/kernel/vdso upon
> cleaning.
> 
> After this commit:
> $ make defconfig ARCH=arm64
> $ make ARCH=arm64
> $ make mrproper ARCH=arm64
> $ git clean -nxdf
> <empty>

Well spotted!

> Signed-off-by: Andrew Delgadillo <adelg@google.com>
> ---
>  arch/arm64/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index b52481f0605d..ef6598cb5a9b 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -181,6 +181,7 @@ archprepare:
>  # We use MRPROPER_FILES and CLEAN_FILES now
>  archclean:
>  	$(Q)$(MAKE) $(clean)=$(boot)
> +	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso

I think we also need to clean the vdso32 directory here. Please can you
send a v2 with that added?

Cheers,

Will
