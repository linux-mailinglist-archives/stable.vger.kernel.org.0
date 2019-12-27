Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2574912B901
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfL0R7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbfL0RlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1117021927;
        Fri, 27 Dec 2019 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468461;
        bh=S51rkQSe3fqX9zTUh2WQGGWKBoj1jAt3CYqQB7zmTNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RC1APEvjtlU+fAHCf5P/U/bNTqXmcr3kjuzErHq1sRglLFOSR3eFR4TcBaTb7y4RO
         c9aVvh+uMUX0tc6i3SaBUpj4bluxbUWOdzqwac9Ox3qmXtmn+eIYjvsexGTPtqsmZv
         RLubsu+fTBdm5ow7/Fwhb11LtKPpmjjeC/tf4LLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 004/187] spi: cadence: Correct handling of native chipselect
Date:   Fri, 27 Dec 2019 12:37:52 -0500
Message-Id: <20191227174055.4923-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 61acd19f9c56fa0809285346bd0bd4a926ab0da0 ]

To fix a regression on the Cadence SPI driver, this patch reverts
commit 6046f5407ff0 ("spi: cadence: Fix default polarity of native
chipselect").

This patch was not the correct fix for the issue. The SPI framework
calls the set_cs line with the logic level it desires on the chip select
line, as such the old is_high handling was correct. However, this was
broken by the fact that before commit 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH
setting when using native and GPIO CS") all controllers that offered
the use of a GPIO chip select had SPI_CS_HIGH applied, even for hardware
chip selects. This caused the value passed into the driver to be inverted.
Which unfortunately makes it look like a logical enable the chip select
value.

Since the core was corrected to not unconditionally apply SPI_CS_HIGH,
the Cadence driver, whilst using the hardware chip select, will deselect
the chip select every time we attempt to communicate with the device,
which results in failed communications.

Fixes: 3e5ec1db8bfe ("spi: Fix SPI_CS_HIGH setting when using native and GPIO CS")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20191126164140.6240-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index c36587b42e95..82a0ee09cbe1 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -168,16 +168,16 @@ static void cdns_spi_init_hw(struct cdns_spi *xspi)
 /**
  * cdns_spi_chipselect - Select or deselect the chip select line
  * @spi:	Pointer to the spi_device structure
- * @enable:	Select (1) or deselect (0) the chip select line
+ * @is_high:	Select(0) or deselect (1) the chip select line
  */
-static void cdns_spi_chipselect(struct spi_device *spi, bool enable)
+static void cdns_spi_chipselect(struct spi_device *spi, bool is_high)
 {
 	struct cdns_spi *xspi = spi_master_get_devdata(spi->master);
 	u32 ctrl_reg;
 
 	ctrl_reg = cdns_spi_read(xspi, CDNS_SPI_CR);
 
-	if (!enable) {
+	if (is_high) {
 		/* Deselect the slave */
 		ctrl_reg |= CDNS_SPI_CR_SSCTRL;
 	} else {
-- 
2.20.1

