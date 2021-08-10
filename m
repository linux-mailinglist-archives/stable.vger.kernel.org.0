Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256933E5527
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhHJI2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:28:08 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52811 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbhHJI2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 04:28:06 -0400
Received: (Authenticated sender: alex@ghiti.fr)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id EC1B960005;
        Tue, 10 Aug 2021 08:27:41 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] Revert "riscv: Remove
 CONFIG_PHYS_RAM_BASE_FIXED"" failed to apply to 5.13-stable tree
To:     gregkh@linuxfoundation.org, jszhang@kernel.org, kernel@esmil.dk,
        palmerdabbelt@google.com
Cc:     stable@vger.kernel.org
References: <16285057241800@kroah.com>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <950e0318-300b-5915-aace-be679f3ba2d0@ghiti.fr>
Date:   Tue, 10 Aug 2021 10:27:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <16285057241800@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Le 9/08/2021 à 12:42, gregkh@linuxfoundation.org a écrit :
> 
> The patch below does not apply to the 5.13-stable tree.

The same for this one too, it can't be applied to 5.13 since it fixes a 
mistake introduced in 5.14-rc1.

Sorry again for the noise,

Thanks,

Alex

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 867432bec1c6e7df21a361d7f12022a8c5f54022 Mon Sep 17 00:00:00 2001
> From: Alexandre Ghiti <alex@ghiti.fr>
> Date: Wed, 21 Jul 2021 09:59:36 +0200
> Subject: [PATCH] Revert "riscv: Remove CONFIG_PHYS_RAM_BASE_FIXED"
> 
> This reverts commit 9b79878ced8f7ab85c57623f8b1f6882e484a316.
> 
> The removal of this config exposes CONFIG_PHYS_RAM_BASE for all kernel
> types: this value being implementation-specific, this breaks the
> genericity of the RISC-V kernel so revert it.
> 
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Tested-by: Emil Renner Berthing <kernel@esmil.dk>
> Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 31f9e92f1402..4f7b70ae7c31 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -495,8 +495,13 @@ config STACKPROTECTOR_PER_TASK
>   	depends on !GCC_PLUGIN_RANDSTRUCT
>   	depends on STACKPROTECTOR && CC_HAVE_STACKPROTECTOR_TLS
>   
> +config PHYS_RAM_BASE_FIXED
> +	bool "Explicitly specified physical RAM address"
> +	default n
> +
>   config PHYS_RAM_BASE
>   	hex "Platform Physical RAM address"
> +	depends on PHYS_RAM_BASE_FIXED
>   	default "0x80000000"
>   	help
>   	  This is the physical address of RAM in the system. It has to be
> @@ -509,6 +514,7 @@ config XIP_KERNEL
>   	# This prevents XIP from being enabled by all{yes,mod}config, which
>   	# fail to build since XIP doesn't support large kernels.
>   	depends on !COMPILE_TEST
> +	select PHYS_RAM_BASE_FIXED
>   	help
>   	  Execute-In-Place allows the kernel to run from non-volatile storage
>   	  directly addressable by the CPU, such as NOR flash. This saves RAM
> 
