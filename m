Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1132AFB5
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhCCA2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350714AbhCBM2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D2C64FCA;
        Tue,  2 Mar 2021 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686372;
        bh=VPRE832pU0+LBG5pWKgG1aQ+yt+O0wX0qot67RDjVa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RalFa7TDSIMnawl/3mKoRCf682EYRYV1ekAnqATjOvQHCy3UKL/D0pcroKzcoKmSy
         IEM1J+eJGvc3XooWDrgG27+xXooCuM3s/0zk4vvs+QuBI/6lKcbS1B5YRfmz+bgtbP
         jQXjV289Cmhpq/90Pji75x0zv3uOjv1f5z/zxKJhfeZctqqaspsn7txezTA44yH79k
         6PpEM9I1DlCuRIkZqF9HQv48kO0KS+zyBUzIFNmPpr/AqiO4h9ZlxsXjhAcTE1IKf+
         5QA6NcbrIvc5acdAB7COQy5aCbs1NQ3Lq5FvWTxl45sAB8w5yrfff+h1GV7rBclb9f
         Pczyv5bErj2xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aswath Govindraju <a-govindraju@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 08/10] misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom
Date:   Tue,  2 Mar 2021 06:59:19 -0500
Message-Id: <20210302115921.63636-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115921.63636-1-sashal@kernel.org>
References: <20210302115921.63636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 94cc035aa841..a6409a362eb3 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -38,6 +38,10 @@ static const struct eeprom_93xx46_devtype_data atmel_at93c46d_data = {
 		  EEPROM_93XX46_QUIRK_INSTRUCTION_LENGTH,
 };
 
+static const struct eeprom_93xx46_devtype_data microchip_93lc46b_data = {
+	.quirks = EEPROM_93XX46_QUIRK_EXTRA_READ_CYCLE,
+};
+
 struct eeprom_93xx46_dev {
 	struct spi_device *spi;
 	struct eeprom_93xx46_platform_data *pdata;
@@ -58,6 +62,11 @@ static inline bool has_quirk_instruction_length(struct eeprom_93xx46_dev *edev)
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
@@ -99,6 +108,11 @@ static int eeprom_93xx46_read(void *priv, unsigned int off,
 		dev_dbg(&edev->spi->dev, "read cmd 0x%x, %d Hz\n",
 			cmd_addr, edev->spi->max_speed_hz);
 
+		if (has_quirk_extra_read_cycle(edev)) {
+			cmd_addr <<= 1;
+			bits += 1;
+		}
+
 		spi_message_init(&m);
 
 		t[0].tx_buf = (char *)&cmd_addr;
@@ -366,6 +380,7 @@ static void select_deassert(void *context)
 static const struct of_device_id eeprom_93xx46_of_table[] = {
 	{ .compatible = "eeprom-93xx46", },
 	{ .compatible = "atmel,at93c46d", .data = &atmel_at93c46d_data, },
+	{ .compatible = "microchip,93lc46b", .data = &microchip_93lc46b_data, },
 	{}
 };
 MODULE_DEVICE_TABLE(of, eeprom_93xx46_of_table);
diff --git a/include/linux/eeprom_93xx46.h b/include/linux/eeprom_93xx46.h
index 885f587a3555..affe4d1d7d4a 100644
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

