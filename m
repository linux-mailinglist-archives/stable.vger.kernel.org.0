Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B025409105
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbhIMN5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343570AbhIMNzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71653610FB;
        Mon, 13 Sep 2021 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540150;
        bh=+DF4tjaF8FS2639gQMFs4jZRbx16vKX0UdDNZKL22y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5GzmSwD0tw3BsEV6KmYcIQvqtjSZWU1Tg0ytUpAPs/JszKeE2wu4Y5m9NirbHr90
         zjnayK2hg+JbTZoRQVWXfijFidZKBX4LdzOEfkZFoWG5Dxi51C7uor5KErVFqEIZB1
         MJD+TB1w27zR0U7RzEQID6DLhZinFoqbq/cuqnO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/300] spi: davinci: invoke chipselect callback
Date:   Mon, 13 Sep 2021 15:12:14 +0200
Message-Id: <20210913131111.820758239@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>

[ Upstream commit ea4ab99cb58cc9f8d64c0961ff9a059825f304cf ]

Davinci needs to configure chipselect on transfer.

Fixes: 4a07b8bcd503 ("spi: bitbang: Make chipselect callback optional")
Signed-off-by: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nokia.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Link: https://lore.kernel.org/r/735fb7b0-82aa-5b9b-85e4-53f0c348cc0e@nokia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index e114e6fe5ea5..d112c2cac042 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -213,12 +213,6 @@ static void davinci_spi_chipselect(struct spi_device *spi, int value)
 	 * line for the controller
 	 */
 	if (spi->cs_gpiod) {
-		/*
-		 * FIXME: is this code ever executed? This host does not
-		 * set SPI_MASTER_GPIO_SS so this chipselect callback should
-		 * not get called from the SPI core when we are using
-		 * GPIOs for chip select.
-		 */
 		if (value == BITBANG_CS_ACTIVE)
 			gpiod_set_value(spi->cs_gpiod, 1);
 		else
@@ -945,7 +939,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = pdata->num_chipselect;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(2, 16);
-	master->flags = SPI_MASTER_MUST_RX;
+	master->flags = SPI_MASTER_MUST_RX | SPI_MASTER_GPIO_SS;
 	master->setup = davinci_spi_setup;
 	master->cleanup = davinci_spi_cleanup;
 	master->can_dma = davinci_spi_can_dma;
-- 
2.30.2



