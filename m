Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478E930ACF9
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhBAQse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 11:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhBAQs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 11:48:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63AAE64EA4;
        Mon,  1 Feb 2021 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612198065;
        bh=CZeI2uMdSKtpN0SRrNo9xb71YONUgiAnGU2LY/NNQPM=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Y5e3GDx4v1reTzZTfDxboTTMXlgDnVr260B7MFwsxh/z9IxzKHcfFuLp0fxEmVvhc
         SphstRbgVGkRKtApThDg/e1Paorx+QdEuSkmETfw39wwwacIh3a32VwO2Rfxnc30ab
         R4EtTnikzy5cXbp2X6PVghNqKkdjx7jVXPZ95AqTVojGBWhwY2pJ4LlPqV0htsrrP0
         FNqBdJeTkBsLJSJ+pmtPIe+xXudKHGuyUb8nkTsvY6uzq4WsB5D78Ld3qYOiAA/eMw
         bsfuMzQShErOfHqB+edFMSfAQZjnbGVZV5a2OG/f8isR4DJAXTP63Bc23xSnZG0eGH
         +2dszkicu5ddg==
From:   Mark Brown <broonie@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20210130143545.505613-1-rasmus.villemoes@prevas.dk>
References: <20210130143545.505613-1-rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] spi: fsl: invert spisel_boot signal on MPC8309
Message-Id: <161219801882.46355.10875207480645821949.b4-ty@kernel.org>
Date:   Mon, 01 Feb 2021 16:46:58 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 30 Jan 2021 15:35:45 +0100, Rasmus Villemoes wrote:
> Commit 7a2da5d7960a ("spi: fsl: Fix driver breakage when SPI_CS_HIGH
> is not set in spi->mode") broke our MPC8309 board by effectively
> inverting the boolean value passed to fsl_spi_cs_control. The
> SPISEL_BOOT signal is used as chipselect, but it's not a gpio, so
> we cannot rely on gpiolib handling the polarity.
> 
> Adapt to the new world order by inverting the logic here. This does
> assume that the slave sitting at the SPISEL_BOOT is active low, but
> should that ever turn out not to be the case, one can create a stub
> gpiochip driver controlling a single gpio (or rather, a single "spo",
> special-purpose output).

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/1] spi: fsl: invert spisel_boot signal on MPC8309
      commit: 9d2aa6dbf87af89c13cac2d1b4cccad83fb14a7e

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
