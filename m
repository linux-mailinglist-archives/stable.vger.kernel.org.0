Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61CF2171C5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgGGPZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbgGGPZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C462088E;
        Tue,  7 Jul 2020 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135542;
        bh=u5hZZbFiRo5yvKUXbV5TVcAyrT/PdqV0ctTx9a77ELA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BO3JBi2A2KnkJ0xUlg13Z+2aZXhOAiJKPOlWVrscxyK8eZPdZjsW39owCpklYp4V+
         dN4EDX4gag446GBOkf3SOyq/ME0tCaIHd3AsjQ4iONYz4+vUNVZIsXEeSuVzGHY+Jt
         CGO8Zhb6VJmEefbEKV0TYQtck+hMWVdW1xow0Umc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 082/112] i2c: designware: platdrv: Set class based on DMI
Date:   Tue,  7 Jul 2020 17:17:27 +0200
Message-Id: <20200707145804.885886148@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@kernel.org>

[ Upstream commit db2a8b6f1df93d5311970cca03052c01178de674 ]

Current AMD's zen-based APUs use this core for some of its i2c-buses.

With this patch we re-enable autodetection of hwmon-alike devices, so
lm-sensors will be able to work automatically.

It does not affect the boot-time of embedded devices, as the class is
set based on the DMI information.

DMI is probed only on Qtechnology QT5222 Industrial Camera Platform.

DocLink: https://qtec.com/camera-technology-camera-platforms/
Fixes: 3eddad96c439 ("i2c: designware: reverts "i2c: designware: Add support for AMD I2C controller"")
Signed-off-by: Ricardo Ribalda <ribalda@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 5536673060cc6..3a9c2cfbef974 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -234,6 +234,17 @@ static const u32 supported_speeds[] = {
 	I2C_MAX_STANDARD_MODE_FREQ,
 };
 
+static const struct dmi_system_id dw_i2c_hwmon_class_dmi[] = {
+	{
+		.ident = "Qtechnology QT5222",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Qtechnology"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "QT5222"),
+		},
+	},
+	{ } /* terminate list */
+};
+
 static int dw_i2c_plat_probe(struct platform_device *pdev)
 {
 	struct dw_i2c_platform_data *pdata = dev_get_platdata(&pdev->dev);
@@ -349,7 +360,8 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 	adap = &dev->adapter;
 	adap->owner = THIS_MODULE;
-	adap->class = I2C_CLASS_DEPRECATED;
+	adap->class = dmi_check_system(dw_i2c_hwmon_class_dmi) ?
+					I2C_CLASS_HWMON : I2C_CLASS_DEPRECATED;
 	ACPI_COMPANION_SET(&adap->dev, ACPI_COMPANION(&pdev->dev));
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->nr = -1;
-- 
2.25.1



