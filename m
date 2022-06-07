Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E40541332
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357473AbiFGT4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357763AbiFGTzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:55:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B4A7E18;
        Tue,  7 Jun 2022 11:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9634611B9;
        Tue,  7 Jun 2022 18:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEFFC385A2;
        Tue,  7 Jun 2022 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626227;
        bh=TY/+PwTvpEYxQkMo3I5D4CqBoTzcVkJcSgad3CTPxNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxceSfW42WgyQccB8xvLyLC4UWKY3KVe5d4ll6F34PA8ahd0PR0D0O/JHykOpbLRr
         18Y+fftaMi6szTNbpNj6+uDtTS4oZFz0jXf2le82BkerlVrGCILA0gue4rLT+y2HkA
         QMhj2TSdI5hIjcUl/uHYqW8mQiTtQXie932mnxk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Lin <jon.lin@rock-chips.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 295/772] spi: rockchip: Preset cs-high and clk polarity in setup progress
Date:   Tue,  7 Jun 2022 18:58:07 +0200
Message-Id: <20220607164957.716198963@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 3a4bf922d42efa4e9a3dc803d1fd786d43e8a501 ]

After power up, the cs and clock is in default status, and the cs-high
and clock polarity dts property configuration will take no effect until
the calling of rockchip_spi_config in the first transmission.
So preset them to make sure a correct voltage before the first
transmission coming.

Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20220216014028.8123-5-jon.lin@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 5ecd0692cca1..83da8fdb3c02 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -713,6 +713,29 @@ static bool rockchip_spi_can_dma(struct spi_controller *ctlr,
 	return xfer->len / bytes_per_word >= rs->fifo_len;
 }
 
+static int rockchip_spi_setup(struct spi_device *spi)
+{
+	struct rockchip_spi *rs = spi_controller_get_devdata(spi->controller);
+	u32 cr0;
+
+	pm_runtime_get_sync(rs->dev);
+
+	cr0 = readl_relaxed(rs->regs + ROCKCHIP_SPI_CTRLR0);
+
+	cr0 &= ~(0x3 << CR0_SCPH_OFFSET);
+	cr0 |= ((spi->mode & 0x3) << CR0_SCPH_OFFSET);
+	if (spi->mode & SPI_CS_HIGH && spi->chip_select <= 1)
+		cr0 |= BIT(spi->chip_select) << CR0_SOI_OFFSET;
+	else if (spi->chip_select <= 1)
+		cr0 &= ~(BIT(spi->chip_select) << CR0_SOI_OFFSET);
+
+	writel_relaxed(cr0, rs->regs + ROCKCHIP_SPI_CTRLR0);
+
+	pm_runtime_put(rs->dev);
+
+	return 0;
+}
+
 static int rockchip_spi_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -840,6 +863,7 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 	ctlr->min_speed_hz = rs->freq / BAUDR_SCKDV_MAX;
 	ctlr->max_speed_hz = min(rs->freq / BAUDR_SCKDV_MIN, MAX_SCLK_OUT);
 
+	ctlr->setup = rockchip_spi_setup;
 	ctlr->set_cs = rockchip_spi_set_cs;
 	ctlr->transfer_one = rockchip_spi_transfer_one;
 	ctlr->max_transfer_size = rockchip_spi_max_transfer_size;
-- 
2.35.1



