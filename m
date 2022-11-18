Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472F762F708
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 15:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242376AbiKRORn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 09:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242298AbiKRORK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 09:17:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2A66D48F;
        Fri, 18 Nov 2022 06:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72D1A6257A;
        Fri, 18 Nov 2022 14:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E66C433D7;
        Fri, 18 Nov 2022 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668780989;
        bh=+VWgwc6Cv21GOSko5yeeeSuThRGjhJB4uSk3EPnNBlw=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=K59dSKmhhZEgSVeAs3nsLfliSjVR+4wIiJHvN9VtXYfsilyc5DFHozkPNfDbrKqTH
         zbQfIXNxXBxxI6/13Jb3k+ELsscXPApwwWIZhS4RJDSuTIiLTikA6CHUxtR7tLeAEe
         3Rl92YK0Pmtd6HEj5PfHUKcrYvhfrCl9gwDHCvok0U5wJJUx2rsngCeXAcX0CiT3cs
         b3u3OcqX++INq+gm5iIv/PC6Mp/HHgDQWXoDu94ACTbxg5QI/z+e7jGwcD5HiFPc9q
         BTmP5+Oiz9DnSVQHStI1g+JmQXPZSzuj3W3dz23Z4KGxljxX6lIKe6CCRZaqcKrPGo
         bUND9sJkd09wA==
From:   Mark Brown <broonie@kernel.org>
To:     linux-spi@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     stable@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        David Jander <david@protonic.nl>,
        NXP Linux Team <linux-imx@nxp.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        kernel@pengutronix.de
In-Reply-To: <20221116164930.855362-1-mkl@pengutronix.de>
References: <20221116164930.855362-1-mkl@pengutronix.de>
Subject: Re: [PATCH] spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first
Message-Id: <166878098696.885585.12678167389874876535.b4-ty@kernel.org>
Date:   Fri, 18 Nov 2022 14:16:26 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-8af31
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 16 Nov 2022 17:49:30 +0100, Marc Kleine-Budde wrote:
> The SPI framework checks for each transfer (with the struct
> spi_controller::can_dma callback) whether the driver wants to use DMA
> for the transfer. If the driver returns true, the SPI framework will
> map the transfer's data to the device, start the actual transfer and
> map the data back.
> 
> In commit 07e759387788 ("spi: spi-imx: add PIO polling support") the
> spi-imx driver's spi_imx_transfer_one() function was extended. If the
> estimated duration of a transfer does not exceed a configurable
> duration, a polling transfer function is used. This check happens
> before checking if the driver decided earlier for a DMA transfer.
> 
> [...]

Applied to

   broonie/spi.git for-next

Thanks!

[1/1] spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first
      commit: e85e9e0d8cb759013d6474011c227f92e442d746

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
