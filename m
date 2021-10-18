Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20332431E20
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhJRN55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234381AbhJRNz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB7861A03;
        Mon, 18 Oct 2021 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564417;
        bh=DTVAeuq2AdtyIHNnOObDtjxX+Zf6lc5YAEEVS2lGK80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6FDdw2PkgwjUjoWDaE+x74jBI+oVaeEulST4QeH2OIP4VlVCao3yfuHddRt4CnrA
         OWSwcelUXgyJSXVLfhO63nSVaupnFG4Aqp+K1pQJpCZO0KccJLqh+IygCktxQw1Xc9
         CnIEsJrmREqNw5Gm5QVJ25/zBDtITOsnxfhmfC3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 082/151] eeprom: 93xx46: Add SPI device ID table
Date:   Mon, 18 Oct 2021 15:24:21 +0200
Message-Id: <20211018132343.355899156@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 137879f7ff23c635d2c6b2e43f4b39e2d305c3e2 upstream.

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding a SPI device ID table.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210922184048.34770-1-broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -406,6 +406,23 @@ static const struct of_device_id eeprom_
 };
 MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);
 
+static const struct spi_device_id eeprom_93xx46_spi_ids[] = {
+	{ .name = "eeprom-93xx46",
+	  .driver_data = (kernel_ulong_t)&at93c46_data, },
+	{ .name = "at93c46",
+	  .driver_data = (kernel_ulong_t)&at93c46_data, },
+	{ .name = "at93c46d",
+	  .driver_data = (kernel_ulong_t)&atmel_at93c46d_data, },
+	{ .name = "at93c56",
+	  .driver_data = (kernel_ulong_t)&at93c56_data, },
+	{ .name = "at93c66",
+	  .driver_data = (kernel_ulong_t)&at93c66_data, },
+	{ .name = "93lc46b",
+	  .driver_data = (kernel_ulong_t)&microchip_93lc46b_data, },
+	{}
+};
+MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);
+
 static int eeprom_93xx46_probe_dt(struct spi_device *spi)
 {
 	const struct of_device_id *of_id =
@@ -555,6 +572,7 @@ static struct spi_driver eeprom_93xx46_d
 	},
 	.probe		= eeprom_93xx46_probe,
 	.remove		= eeprom_93xx46_remove,
+	.id_table	= eeprom_93xx46_spi_ids,
 };
 
 module_spi_driver(eeprom_93xx46_driver);


