Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C87169776
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbfGONzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732588AbfGONyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:54:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45EC7212F5;
        Mon, 15 Jul 2019 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198893;
        bh=MZoTV+b3HU5dLeKehg1HKEB6/ZWx9+HGjcpWGQKcmWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHK2nerEL0cDcpawpofrmme+tt2WtkYzgKQNcM4Cgn4L7L5S0jBhyNUA/rGEXXscF
         o2kdh2zAzyY7DTkoNKCUGPdoCyS/FbATUceBDXZVU1AqK0KQXnUgW1QzEwhpjsqLPm
         qCS1y8bTb94nnZtQ9P4HyyVxE33D0u4O663FXvpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 131/249] spi: fix ctrl->num_chipselect constraint
Date:   Mon, 15 Jul 2019 09:44:56 -0400
Message-Id: <20190715134655.4076-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit f9481b08220d7dc1ff21e296a330ee8b721b44e4 ]

at91sam9g25ek showed the following error at probe:
atmel_spi f0000000.spi: Using dma0chan2 (tx) and dma0chan3 (rx)
for DMA transfers
atmel_spi: probe of f0000000.spi failed with error -22

Commit 0a919ae49223 ("spi: Don't call spi_get_gpio_descs() before device name is set")
moved the calling of spi_get_gpio_descs() after ctrl->dev is set,
but didn't move the !ctrl->num_chipselect check. When there are
chip selects in the device tree, the spi-atmel driver lets the
SPI core discover them when registering the SPI master.
The ctrl->num_chipselect is thus expected to be set by
spi_get_gpio_descs().

Move the !ctlr->num_chipselect after spi_get_gpio_descs() as it was
before the aforementioned commit. While touching this block, get rid
of the explicit comparison with 0 and update the commenting style.

Fixes: 0a919ae49223 ("spi: Don't call spi_get_gpio_descs() before device name is set")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5e4654032bfa..29916e446143 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2286,11 +2286,6 @@ int spi_register_controller(struct spi_controller *ctlr)
 	if (status)
 		return status;
 
-	/* even if it's just one always-selected device, there must
-	 * be at least one chipselect
-	 */
-	if (ctlr->num_chipselect == 0)
-		return -EINVAL;
 	if (ctlr->bus_num >= 0) {
 		/* devices with a fixed bus num must check-in with the num */
 		mutex_lock(&board_lock);
@@ -2361,6 +2356,13 @@ int spi_register_controller(struct spi_controller *ctlr)
 		}
 	}
 
+	/*
+	 * Even if it's just one always-selected device, there must
+	 * be at least one chipselect.
+	 */
+	if (!ctlr->num_chipselect)
+		return -EINVAL;
+
 	status = device_add(&ctlr->dev);
 	if (status < 0) {
 		/* free bus id */
-- 
2.20.1

