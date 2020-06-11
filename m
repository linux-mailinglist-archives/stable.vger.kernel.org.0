Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B7F1F6AFD
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgFKP3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgFKP3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 11:29:15 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB050207ED;
        Thu, 11 Jun 2020 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591889355;
        bh=ufEXvIwUNU84phxn4fdLQDTEOa+3mCwvua/d+FRq8+Y=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=q/+0Vbm0pDdriPQZBDhwQWB6K/UOS5VzAe+POFRuiPPG45yMVxJpd1Q+ZGLat5ht2
         sxmoZNF+yagyxbDBzTAQh3HyKkHVZEyBEqPsXtW6D/LbV2jrwNi4c3/DXA11VDw9C3
         ne+HfOiMw0W+7OHrv3vMvGDR14BPjTwcMfCU9fg8=
Date:   Thu, 11 Jun 2020 16:29:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
In-Reply-To: <1591803717-11218-1-git-send-email-krzk@kernel.org>
References: <1591803717-11218-1-git-send-email-krzk@kernel.org>
Subject: Re: [PATCH] spi: spi-fsl-dspi: Free DMA memory with matching function
Message-Id: <159188934188.47269.15444268053636073339.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Jun 2020 17:41:57 +0200, Krzysztof Kozlowski wrote:
> Driver allocates DMA memory with dma_alloc_coherent() but frees it with
> dma_unmap_single().
> 
> This causes DMA warning during system shutdown (with DMA debugging) on
> Toradex Colibri VF50 module:
> 
>     WARNING: CPU: 0 PID: 1 at ../kernel/dma/debug.c:1036 check_unmap+0x3fc/0xb04
>     DMA-API: fsl-edma 40098000.dma-controller: device driver frees DMA memory with wrong function
>       [device address=0x0000000087040000] [size=8 bytes] [mapped as coherent] [unmapped as single]
>     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
>       (unwind_backtrace) from [<8010bb34>] (show_stack+0x10/0x14)
>       (show_stack) from [<8011ced8>] (__warn+0xf0/0x108)
>       (__warn) from [<8011cf64>] (warn_slowpath_fmt+0x74/0xb8)
>       (warn_slowpath_fmt) from [<8017d170>] (check_unmap+0x3fc/0xb04)
>       (check_unmap) from [<8017d900>] (debug_dma_unmap_page+0x88/0x90)
>       (debug_dma_unmap_page) from [<80601d68>] (dspi_release_dma+0x88/0x110)
>       (dspi_release_dma) from [<80601e4c>] (dspi_shutdown+0x5c/0x80)
>       (dspi_shutdown) from [<805845f8>] (device_shutdown+0x17c/0x220)
>       (device_shutdown) from [<80143ef8>] (kernel_restart+0xc/0x50)
>       (kernel_restart) from [<801441cc>] (__do_sys_reboot+0x18c/0x210)
>       (__do_sys_reboot) from [<80100060>] (ret_fast_syscall+0x0/0x28)
>     DMA-API: Mapped at:
>      dma_alloc_attrs+0xa4/0x130
>      dspi_probe+0x568/0x7b4
>      platform_drv_probe+0x6c/0xa4
>      really_probe+0x208/0x348
>      driver_probe_device+0x5c/0xb4

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: spi-fsl-dspi: Free DMA memory with matching function
      commit: 03fe7aaf0c3d40ef7feff2bdc7180c146989586a

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
