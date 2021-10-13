Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75ADE42B640
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 07:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhJMGBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 02:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhJMGBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 02:01:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F5760C4A;
        Wed, 13 Oct 2021 05:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634104743;
        bh=/qus41ilY6w21Ca2R+0Q6xIAZtlILxDno5T19N3Hbh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SpDIVM2VGBPZsKjcC97qrSMhyUjATK0iwjm1dmQcPw52HWoSMTiTYciSLUQ/Ss92d
         h/EQyXwbDzuXxR5uHYtTdFICsob4rzONLe6Tgq0VLdp50etPD0ZuBDSRx3eRhtpxfH
         FWtL2YaYFXH1YFJzanaKq6d4doBz3WR0T9JnQV5I=
Date:   Wed, 13 Oct 2021 07:58:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Simon Trimmer <simont@opensource.cirrus.com>,
        Michael Ellerman <mpe@ellerman.id.au>, linux@armlinux.org.uk,
        catalin.marinas@arm.com, tsbogend@alpha.franken.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, linus.walleij@linaro.org,
        geert+renesas@glider.be, rmk+kernel@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        mark.rutland@arm.com, ardb@kernel.org,
        u.kleine-koenig@pengutronix.de, rppt@kernel.org,
        lukas.bulwahn@gmail.com, wangkefeng.wang@huawei.com,
        slyfox@gentoo.org, axboe@kernel.dk, ben.widawsky@intel.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 11/11] firmware: include
 drivers/firmware/Kconfig unconditionally
Message-ID: <YWZ1om+pLmV3atTd@kroah.com>
References: <20211013005532.700190-1-sashal@kernel.org>
 <20211013005532.700190-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013005532.700190-11-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 12, 2021 at 08:55:31PM -0400, Sasha Levin wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> [ Upstream commit 951cd3a0866d29cb9c01ebc1d9c17590e598226e ]
> 
> Compile-testing drivers that require access to a firmware layer
> fails when that firmware symbol is unavailable. This happened
> twice this week:
> 
>  - My proposed to change to rework the QCOM_SCM firmware symbol
>    broke on ppc64 and others.
> 
>  - The cs_dsp firmware patch added device specific firmware loader
>    into drivers/firmware, which broke on the same set of
>    architectures.
> 
> We should probably do the same thing for other subsystems as well,
> but fix this one first as this is a dependency for other patches
> getting merged.
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> Acked-by: Will Deacon <will@kernel.org>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Charles Keepax <ckeepax@opensource.cirrus.com>
> Cc: Simon Trimmer <simont@opensource.cirrus.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/Kconfig    | 2 --
>  arch/arm64/Kconfig  | 2 --
>  arch/ia64/Kconfig   | 2 --
>  arch/mips/Kconfig   | 2 --
>  arch/parisc/Kconfig | 2 --
>  arch/riscv/Kconfig  | 2 --
>  arch/x86/Kconfig    | 2 --
>  drivers/Kconfig     | 2 ++
>  8 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 002e0cf025f5..d4c6b95b24d7 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2043,8 +2043,6 @@ config ARCH_HIBERNATION_POSSIBLE
>  
>  endmenu
>  
> -source "drivers/firmware/Kconfig"
> -
>  if CRYPTO
>  source "arch/arm/crypto/Kconfig"
>  endif
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 5e5cf3af6351..f4809760a806 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1933,8 +1933,6 @@ source "drivers/cpufreq/Kconfig"
>  
>  endmenu
>  
> -source "drivers/firmware/Kconfig"
> -
>  source "drivers/acpi/Kconfig"
>  
>  source "arch/arm64/kvm/Kconfig"
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 39b25a5a591b..e8014d2e36c0 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -426,8 +426,6 @@ config CRASH_DUMP
>  	  help
>  	    Generate crash dump after being started by kexec.
>  
> -source "drivers/firmware/Kconfig"
> -
>  endmenu
>  
>  menu "Power management and ACPI options"
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 1a63f592034e..3bd3a01a2a2b 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -3328,8 +3328,6 @@ source "drivers/cpuidle/Kconfig"
>  
>  endmenu
>  
> -source "drivers/firmware/Kconfig"
> -
>  source "arch/mips/kvm/Kconfig"
>  
>  source "arch/mips/vdso/Kconfig"
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index 14f3252f2da0..ad13477fb40c 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -378,6 +378,4 @@ config KEXEC_FILE
>  
>  endmenu
>  
> -source "drivers/firmware/Kconfig"
> -
>  source "drivers/parisc/Kconfig"
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index f7abd118d23d..fcb8e5da148e 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -428,5 +428,3 @@ menu "Power management options"
>  source "kernel/power/Kconfig"
>  
>  endmenu
> -
> -source "drivers/firmware/Kconfig"
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f3c8a8110f60..499f3cc1e62f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2899,8 +2899,6 @@ config HAVE_ATOMIC_IOMAP
>  	def_bool y
>  	depends on X86_32
>  
> -source "drivers/firmware/Kconfig"
> -
>  source "arch/x86/kvm/Kconfig"
>  
>  source "arch/x86/Kconfig.assembler"
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index dcecc9f6e33f..493ac7ffd8d0 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -16,6 +16,8 @@ source "drivers/bus/Kconfig"
>  
>  source "drivers/connector/Kconfig"
>  
> +source "drivers/firmware/Kconfig"
> +
>  source "drivers/gnss/Kconfig"
>  
>  source "drivers/mtd/Kconfig"
> -- 
> 2.33.0
> 

This isn't for stable kernels, it should be dropped from all of your
AUTOSEL queues.

thanks,

greg k-h
