Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD2333DC1
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhCJNYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232831AbhCJNYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC6064FE0;
        Wed, 10 Mar 2021 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382670;
        bh=0ZhR5sqCxzINWr7OlVluAT0KqxeEpRShcU9go6bln0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yaS+iGV/ml/v0y3rSd5A0ZAmP92ZU5chenFasQWH5Q84nWVwLZPXvcWscrdviIVef
         hOmzgsv+FV47/AgD5cxCn45/ZEDghJkxBhi+RivE/FzEQATt1u/SGKaXBjl9zo/bm+
         GH0qI4TccflrClNMLmgA5aCUcQaX1UciyjuJqUYY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 20/36] misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom
Date:   Wed, 10 Mar 2021 14:23:33 +0100
Message-Id: <20210310132321.145822303@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit f6f1f8e6e3eea25f539105d48166e91f0ab46dd1 ]

A dummy zero bit is sent preceding the data during a read transfer by the
Microchip 93LC46B eeprom (section 2.7 of[1]). This results in right shift
of data during a read. In order to ignore this bit a quirk can be added to
send an extra zero bit after the read address.

Add a quirk to ignore the zero bit sent before data by adding a zero bit
after the read address.

[1] - https://www.mouser.com/datasheet/2/268/20001749K-277859.pdf

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20210105105817.17644-3-a-govindraju@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c | 15 +++++++++++++++
 include/linux/eeprom_93xx46.h       |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index d92c4d2c521a..6e5f544c9c73 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -35,6 +35,10 @@ static const struct eeprom_93xx46_devtype_data atmel_at93c46d_data = {
 		  EEPROM_93XX46_QUIRK_INSTRUCTION_LENGTH,
 };
 
+static const struct eeprom_93xx46_devtype_data microchip_93lc46b_data = {
+	.quirks = EEPROM_93XX46_QUIRK_EXTRA_READ_CYCLE,
+};
+
 struct eeprom_93xx46_dev {
 	struct spi_device *spi;
 	struct eeprom_93xx46_platform_data *pdata;
@@ -55,6 +59,11 @@ static inline bool has_quirk_instruction_length(struct eeprom_93xx46_dev *edev)
 	return edev->pdata->quirks & EEPROM_93XX46_QUIRK_INSTRUCTION_LENGTH;
 }
 
+static inline bool has_quirk_extra_read_cycle(struct eeprom_93xx46_dev *edev)
+{
+	return edev->pdata->quirks & EEPROM_93XX46_QUIRK_EXTRA_READ_CYCLE;
+}
+
 static int eeprom_93xx46_read(void *priv, unsigned int off,
 			      void *val, size_t count)
 {
@@ -96,6 +105,11 @@ static int eeprom_93xx46_read(void *priv, unsigned int off,
 		dev_dbg(&edev->spi->dev, "read cmd 0x%x, %d Hz\n",
 			cmd_addr, edev->spi->max_speed_hz);
 
+		if (has_quirk_extra_read_cycle(edev)) {
+			cmd_addr <<= 1;
+			bits += 1;
+		}
+
 		spi_message_init(&m);
 
 		t[0].tx_buf = (char *)&cmd_addr;
@@ -363,6 +377,7 @@ static void select_deassert(void *context)
 static const struct of_device_id eeprom_93xx46_of_table[] = {
 	{ .compatible = "eeprom-93xx46", },
 	{ .compatible = "atmel,at93c46d", .data = &atmel_at93c46d_data, },
+	{ .compatible = "microchip,93lc46b", .data = &microchip_93lc46b_data, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);
diff --git a/include/linux/eeprom_93xx46.h b/include/linux/eeprom_93xx46.h
index eec7928ff8fe..99580c22f91a 100644
--- a/include/linux/eeprom_93xx46.h
+++ b/include/linux/eeprom_93xx46.h
@@ -16,6 +16,8 @@ struct eeprom_93xx46_platform_data {
 #define EEPROM_93XX46_QUIRK_SINGLE_WORD_READ		(1 << 0)
 /* Instructions such as EWEN are (addrlen + 2) in length. */
 #define EEPROM_93XX46_QUIRK_INSTRUCTION_LENGTH		(1 << 1)
+/* Add extra cycle after address during a read */
+#define EEPROM_93XX46_QUIRK_EXTRA_READ_CYCLE		BIT(2)
 
 	/*
 	 * optional hooks to control additional logic
-- 
2.30.1



