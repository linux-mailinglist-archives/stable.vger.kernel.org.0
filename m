Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1778E62BFD6
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 14:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbiKPNnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 08:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiKPNnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 08:43:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8FB4385E;
        Wed, 16 Nov 2022 05:43:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34D92CE1B84;
        Wed, 16 Nov 2022 13:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082FDC433C1;
        Wed, 16 Nov 2022 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668606180;
        bh=h1Q+3253C/CfZZ5+xtcyGSuDjss8dRnKrUS3zFTouNA=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=hKDupV1vZKWH5pUKuwqxZ2NOybhJOGgDdxmisnntd747AE7Z1eVWiBT/XNi4MkHiu
         y63/16HL8cpyHf7ykpWj+v1dfIuH2p6Qp0scWzqywGsr46m9CSy4zHLNnVadkiq/5Z
         rjrSfl6J4jxiB1hy0L11AFcNoY35M/x8macpLBAZNJ/pg1d49lJicgTZICkIqd3aup
         vV0T+j9J2XKcAqQroZZ7pOdyVh2e83MdceESRgKTsErSQJSZmgkybh38sD1nlMCUSa
         4D5JvrSkrNiF/Tvf41RFMtKHmdOyzvAWiTD+Ryb1Jh/G43qeb4iLHOdzS638IlWOWw
         Q2TdX6TpVkwcQ==
From:   Mark Brown <broonie@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-spi@vger.kernel.org, Frieder Schrempf <frieder@fris.de>,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>, linux-kernel@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org, Baruch Siach <baruch.siach@siklu.com>
In-Reply-To: <20221115181002.2068270-1-frieder@fris.de>
References: <20221115181002.2068270-1-frieder@fris.de>
Subject: Re: [PATCH v3] spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock
Message-Id: <166860617673.408509.6245809939301847607.b4-ty@kernel.org>
Date:   Wed, 16 Nov 2022 13:42:56 +0000
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

On Tue, 15 Nov 2022 19:10:00 +0100, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> In case the requested bus clock is higher than the input clock, the correct
> dividers (pre = 0, post = 0) are returned from mx51_ecspi_clkdiv(), but
> *fres is left uninitialized and therefore contains an arbitrary value.
> 
> This causes trouble for the recently introduced PIO polling feature as the
> value in spi_imx->spi_bus_clk is used there to calculate for which
> transfers to enable PIO polling.
> 
> [...]

Applied to

   broonie/spi.git for-next

Thanks!

[1/1] spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock
      commit: db2d2dc9a0b58c6faefb6b002fdbed4f0362d1a4

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
