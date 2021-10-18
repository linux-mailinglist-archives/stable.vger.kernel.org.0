Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0D5431761
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhJRLeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:34:25 -0400
Received: from asav21.altibox.net ([109.247.116.8]:41662 "EHLO
        asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhJRLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:34:23 -0400
Received: from localhost.localdomain (211.81-166-168.customer.lyse.net [81.166.168.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: noralf.tronnes@ebnett.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id E8D8080052;
        Mon, 18 Oct 2021 13:26:20 +0200 (CEST)
From:   =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Jack Andersen <jackoalan@gmail.com>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: [PATCH] mfd: dln2: Add cell for initializing DLN2 ADC
Date:   Mon, 18 Oct 2021 13:25:41 +0200
Message-Id: <20211018112541.25466-1-noralf@tronnes.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=Yr0hubQX c=1 sm=1 tr=0
        a=OYZzhG0JTxDrWp/F2OJbnw==:117 a=OYZzhG0JTxDrWp/F2OJbnw==:17
        a=IkcTkHD0fZMA:10 a=M51BFTxLslgA:10 a=pGLkceISAAAA:8 a=OLL_FvSJAAAA:8
        a=VwQbUJbxAAAA:8 a=SJz97ENfAAAA:8 a=p1JdDOvq47JOlRMEupMA:9
        a=QEXdDO2ut3YA:10 a=QLaaOG07l1cA:10 a=3UZ-nZRERu8A:10
        a=oIrB72frpwYPwTMnlWqB:22 a=AjGcO6oz07-iQ99wixmX:22
        a=vFet0B0WnEQeilDPIY6i:22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Andersen <jackoalan@gmail.com>

This patch extends the DLN2 driver; adding cell for adc_dln2 module.

The original patch[1] fell through the cracks when the driver was added
so ADC has never actually been usable. That patch did not have ACPI
support which was added in v5.9, so the oldest supported version this
current patch can be backported to is 5.10.

[1] https://www.spinics.net/lists/linux-iio/msg33975.html

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Jack Andersen <jackoalan@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/mfd/dln2.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 83e676a096dc..852129ea0766 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -50,6 +50,7 @@ enum dln2_handle {
 	DLN2_HANDLE_GPIO,
 	DLN2_HANDLE_I2C,
 	DLN2_HANDLE_SPI,
+	DLN2_HANDLE_ADC,
 	DLN2_HANDLES
 };
 
@@ -653,6 +654,7 @@ enum {
 	DLN2_ACPI_MATCH_GPIO	= 0,
 	DLN2_ACPI_MATCH_I2C	= 1,
 	DLN2_ACPI_MATCH_SPI	= 2,
+	DLN2_ACPI_MATCH_ADC	= 3,
 };
 
 static struct dln2_platform_data dln2_pdata_gpio = {
@@ -683,6 +685,16 @@ static struct mfd_cell_acpi_match dln2_acpi_match_spi = {
 	.adr = DLN2_ACPI_MATCH_SPI,
 };
 
+/* Only one ADC port supported */
+static struct dln2_platform_data dln2_pdata_adc = {
+	.handle = DLN2_HANDLE_ADC,
+	.port = 0,
+};
+
+static struct mfd_cell_acpi_match dln2_acpi_match_adc = {
+	.adr = DLN2_ACPI_MATCH_ADC,
+};
+
 static const struct mfd_cell dln2_devs[] = {
 	{
 		.name = "dln2-gpio",
@@ -702,6 +714,12 @@ static const struct mfd_cell dln2_devs[] = {
 		.platform_data = &dln2_pdata_spi,
 		.pdata_size = sizeof(struct dln2_platform_data),
 	},
+	{
+		.name = "dln2-adc",
+		.acpi_match = &dln2_acpi_match_adc,
+		.platform_data = &dln2_pdata_adc,
+		.pdata_size = sizeof(struct dln2_platform_data),
+	},
 };
 
 static void dln2_stop(struct dln2_dev *dln2)
-- 
2.33.0

