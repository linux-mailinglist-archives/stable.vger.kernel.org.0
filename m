Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC1B45224D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377433AbhKPBKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245146AbhKOTTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E285561B95;
        Mon, 15 Nov 2021 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000956;
        bh=fZyoex3Xh9SqjGK4bzXXvL+Yb+kn2e8dDp1t2zGQWag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR+kUM+Tmm8mt6YJpl2+5k4jS9UfDuLK8jgPIwYti2wJw/RKmmMhd5VOL+cz4jbm8
         viZExMaOoOCGIin8XyMf6VnzyXLnoF0oqXc5iHt296EmIetuszp9iUOoEdKE81C4ox
         +seEVZfyoOWiGMfDjJ1+6i7SyKO53xHFBp3Bgr5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Andersen <jackoalan@gmail.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.14 814/849] mfd: dln2: Add cell for initializing DLN2 ADC
Date:   Mon, 15 Nov 2021 18:04:57 +0100
Message-Id: <20211115165447.779771707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Andersen <jackoalan@gmail.com>

commit 313c84b5ae4104e48c661d5d706f9f4c425fd50f upstream.

This patch extends the DLN2 driver; adding cell for adc_dln2 module.

The original patch[1] fell through the cracks when the driver was added
so ADC has never actually been usable. That patch did not have ACPI
support which was added in v5.9, so the oldest supported version this
current patch can be backported to is 5.10.

[1] https://www.spinics.net/lists/linux-iio/msg33975.html

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Jack Andersen <jackoalan@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211018112541.25466-1-noralf@tronnes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/dln2.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

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
@@ -683,6 +685,16 @@ static struct mfd_cell_acpi_match dln2_a
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
@@ -702,6 +714,12 @@ static const struct mfd_cell dln2_devs[]
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


