Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7AC3E7FA1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhHJRlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhHJRjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2AC861185;
        Tue, 10 Aug 2021 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617054;
        bh=F5hw9f+wwEsdKWnp+ccOLt3/G5fELqQZjHbfTJzBbLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsoUCTACPC3shYVmJnF2uz00dAzbFsJ2YPAOXwLU6DliemWZhgIHnx+pcUA7WFr7z
         AFcOjfOaep+BSSDiecHifU8Gews3nw5MEoKyKsGKin5bv4V56KjfQS5RvalGgOnlcF
         aEFRumCDNIxgQLnT0w9n8sYvAZBnwsQTpyxUvXZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/135] spi: imx: mx51-ecspi: Fix low-speed CONFIGREG delay calculation
Date:   Tue, 10 Aug 2021 19:29:18 +0200
Message-Id: <20210810172956.498614101@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 53ca18acbe645656132fb5a329833db711067e54 ]

The spi_imx->spi_bus_clk may be uninitialized and thus also zero in
mx51_ecspi_prepare_message(), which would lead to division by zero
in kernel. Since bitbang .setup_transfer callback which initializes
the spi_imx->spi_bus_clk is called after bitbang prepare_message
callback, iterate over all the transfers in spi_message, find the
one with lowest bus frequency, and use that bus frequency for the
delay calculation.

Note that it is not possible to move this CONFIGREG delay back into
the .setup_transfer callback, because that is invoked too late, after
the GPIO chipselects were already configured.

Fixes: 135cbd378eab ("spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210726100102.5188-1-marex@denx.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 8c0a6ea941ad..0e3bc0b0a526 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -505,7 +505,9 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 				      struct spi_message *msg)
 {
 	struct spi_device *spi = msg->spi;
+	struct spi_transfer *xfer;
 	u32 ctrl = MX51_ECSPI_CTRL_ENABLE;
+	u32 min_speed_hz = ~0U;
 	u32 testreg, delay;
 	u32 cfg = readl(spi_imx->base + MX51_ECSPI_CONFIG);
 
@@ -577,8 +579,20 @@ static int mx51_ecspi_prepare_message(struct spi_imx_data *spi_imx,
 	 * be asserted before the SCLK polarity changes, which would disrupt
 	 * the SPI communication as the device on the other end would consider
 	 * the change of SCLK polarity as a clock tick already.
+	 *
+	 * Because spi_imx->spi_bus_clk is only set in bitbang prepare_message
+	 * callback, iterate over all the transfers in spi_message, find the
+	 * one with lowest bus frequency, and use that bus frequency for the
+	 * delay calculation. In case all transfers have speed_hz == 0, then
+	 * min_speed_hz is ~0 and the resulting delay is zero.
 	 */
-	delay = (2 * 1000000) / spi_imx->spi_bus_clk;
+	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+		if (!xfer->speed_hz)
+			continue;
+		min_speed_hz = min(xfer->speed_hz, min_speed_hz);
+	}
+
+	delay = (2 * 1000000) / min_speed_hz;
 	if (likely(delay < 10))	/* SCLK is faster than 100 kHz */
 		udelay(delay);
 	else			/* SCLK is _very_ slow */
-- 
2.30.2



