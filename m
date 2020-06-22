Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AF203A27
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 16:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgFVO74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 10:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgFVO7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 10:59:55 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48ED20739;
        Mon, 22 Jun 2020 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592837995;
        bh=Wuy/dhoWTkQKY+x3mNmqCgJv2Yjz1aRkbR8ZJbLfngs=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=QrAtUr2XMX85mkEWwXRcDzb8eU1cmXepVk8hxeZXcLutDiwXjOkEC3dMaglG8EZIU
         vYKg0LZ3UEjHfGsmrlkxP2rcqD2UmVwrEm6Rgu0/ofDgBmX1+rAecXVI0iU8LfBqeb
         yiOLPEeabBpHekQ/fx/dMGA88K5QuNaLH433oDd0=
Date:   Mon, 22 Jun 2020 15:59:53 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org, Peng Ma <peng.ma@nxp.com>,
        linux-spi@vger.kernel.org
Cc:     stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
In-Reply-To: <20200622110543.5035-1-krzk@kernel.org>
References: <20200622110543.5035-1-krzk@kernel.org>
Subject: Re: [PATCH v4 1/4] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
Message-Id: <159283798285.27744.12351054225935649582.b4-ty@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Jun 2020 13:05:40 +0200, Krzysztof Kozlowski wrote:
> During device removal, the driver should unregister the SPI controller
> and stop the hardware.  Otherwise the dspi_transfer_one_message() could
> wait on completion infinitely.
> 
> Additionally, calling spi_unregister_controller() first in device
> removal reverse-matches the probe function, where SPI controller is
> registered at the end.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[1/4] spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
      commit: 7684580d45bd3d84ed9b453a4cadf7a9a5605a3f
[2/4] spi: spi-fsl-dspi: Fix lockup if device is shutdown during SPI transfer
      commit: 3c525b69e8c1a9a6944e976603c7a1a713e728f9
[3/4] spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths
      commit: 3d87b613d6a3c6f0980e877ab0895785a2dde581
[4/4] spi: spi-fsl-dspi: Initialize completion before possible interrupt
      commit: f148915f91fccd8c3df1b0bff7d1c8458cad3be5

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
