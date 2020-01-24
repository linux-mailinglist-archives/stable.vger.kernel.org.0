Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480CD1475F2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgAXBRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgAXBRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8AAE206A2;
        Fri, 24 Jan 2020 01:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828630;
        bh=0z9he5/8RIETBoAkMNqggpbxB2rCMy6pikyjYVwCBwM=;
        h=From:To:Cc:Subject:Date:From;
        b=14g4OAoMfm4UTkVlF3yhowtAHqyrUCAsf4CJzlUxn5PSQXOqRFx62XOdBQeWunNox
         rZfhFYmR8jM3pEE0d7FIC3Zc2lYRhserJIolSU5XMvDFazLXcB2JuyQ59Q51NyTq4S
         GjbaHtclPKcm5c/1sIDLpTUxFLA+855NuylnXYGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yauhen Kharuzhy <jekhor@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 01/33] extcon-intel-cht-wc: Don't reset USB data connection at probe
Date:   Thu, 23 Jan 2020 20:16:36 -0500
Message-Id: <20200124011708.18232-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yauhen Kharuzhy <jekhor@gmail.com>

[ Upstream commit e81b88932985c9134d410f4eaaaa9b81a3b4bd0c ]

Intel Cherry Trail Whiskey Cove extcon driver connect USB data lines to
PMIC at driver probing for further charger detection. This causes reset of
USB data sessions and removing all devices from bus. If system was
booted from Live CD or USB dongle, this makes system unusable.

Check if USB ID pin is floating and re-route data lines in this case
only, don't touch otherwise.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
[cw00.choi: Clean-up the minor coding style]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-intel-cht-wc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-intel-cht-wc.c b/drivers/extcon/extcon-intel-cht-wc.c
index 9d32150e68db5..771f6f4cf92e6 100644
--- a/drivers/extcon/extcon-intel-cht-wc.c
+++ b/drivers/extcon/extcon-intel-cht-wc.c
@@ -338,6 +338,7 @@ static int cht_wc_extcon_probe(struct platform_device *pdev)
 	struct intel_soc_pmic *pmic = dev_get_drvdata(pdev->dev.parent);
 	struct cht_wc_extcon_data *ext;
 	unsigned long mask = ~(CHT_WC_PWRSRC_VBUS | CHT_WC_PWRSRC_USBID_MASK);
+	int pwrsrc_sts, id;
 	int irq, ret;
 
 	irq = platform_get_irq(pdev, 0);
@@ -387,8 +388,19 @@ static int cht_wc_extcon_probe(struct platform_device *pdev)
 		goto disable_sw_control;
 	}
 
-	/* Route D+ and D- to PMIC for initial charger detection */
-	cht_wc_extcon_set_phymux(ext, MUX_SEL_PMIC);
+	ret = regmap_read(ext->regmap, CHT_WC_PWRSRC_STS, &pwrsrc_sts);
+	if (ret) {
+		dev_err(ext->dev, "Error reading pwrsrc status: %d\n", ret);
+		goto disable_sw_control;
+	}
+
+	/*
+	 * If no USB host or device connected, route D+ and D- to PMIC for
+	 * initial charger detection
+	 */
+	id = cht_wc_extcon_get_id(ext, pwrsrc_sts);
+	if (id != INTEL_USB_ID_GND)
+		cht_wc_extcon_set_phymux(ext, MUX_SEL_PMIC);
 
 	/* Get initial state */
 	cht_wc_extcon_pwrsrc_event(ext);
-- 
2.20.1

