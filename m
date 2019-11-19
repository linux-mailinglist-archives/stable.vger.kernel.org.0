Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5345B1017EC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfKSFiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:38:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbfKSFiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:38:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5AB208C3;
        Tue, 19 Nov 2019 05:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141880;
        bh=6rLXOOpyhENEwIWRMZg72JBdXNe4tH+Hrc/ZYftRZBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5i99zOZdl9J2wN1/SV4ArQ3qBlj2ZIo6XVpk2Kkx4+kTfcxdc7FTG/abcmDP+wvT
         j03svwM94m3Y3fA36aoP7lICn89IPAUtzrt7ih1pVsKCX3BBZLXAqJNP1oyTgPTwTI
         8febHINGRY8XB6XKlseq3U5yUUt5vDJ9ZsKnP6Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kemnade <andreas@kemnade.info>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 272/422] power: supply: twl4030_charger: disable eoc interrupt on linear charge
Date:   Tue, 19 Nov 2019 06:17:49 +0100
Message-Id: <20191119051416.614384894@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 079cdff3d0a09c5da10ae1be35def7a116776328 ]

This avoids getting woken up from suspend after power interruptions
when the bci wrongly thinks the battery is full just because
of input current going low because of low input power

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/twl4030_charger.c | 27 +++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/twl4030_charger.c b/drivers/power/supply/twl4030_charger.c
index adcaa0a10a6f4..0e202d4273fb6 100644
--- a/drivers/power/supply/twl4030_charger.c
+++ b/drivers/power/supply/twl4030_charger.c
@@ -440,6 +440,7 @@ static void twl4030_current_worker(struct work_struct *data)
 static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 {
 	int ret;
+	u32 reg;
 
 	if (bci->usb_mode == CHARGE_OFF)
 		enable = false;
@@ -453,14 +454,38 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			bci->usb_enabled = 1;
 		}
 
-		if (bci->usb_mode == CHARGE_AUTO)
+		if (bci->usb_mode == CHARGE_AUTO) {
+			/* Enable interrupts now. */
+			reg = ~(u32)(TWL4030_ICHGLOW | TWL4030_ICHGEOC |
+					TWL4030_TBATOR2 | TWL4030_TBATOR1 |
+					TWL4030_BATSTS);
+			ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
+				       TWL4030_INTERRUPTS_BCIIMR1A);
+			if (ret < 0) {
+				dev_err(bci->dev,
+					"failed to unmask interrupts: %d\n",
+					ret);
+				return ret;
+			}
 			/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
 			ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
+		}
 
 		/* forcing USBFASTMCHG(BCIMFSTS4[2]) to 1 */
 		ret = twl4030_clear_set(TWL_MODULE_MAIN_CHARGE, 0,
 			TWL4030_USBFASTMCHG, TWL4030_BCIMFSTS4);
 		if (bci->usb_mode == CHARGE_LINEAR) {
+			/* Enable interrupts now. */
+			reg = ~(u32)(TWL4030_ICHGLOW | TWL4030_TBATOR2 |
+					TWL4030_TBATOR1 | TWL4030_BATSTS);
+			ret = twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, reg,
+				       TWL4030_INTERRUPTS_BCIIMR1A);
+			if (ret < 0) {
+				dev_err(bci->dev,
+					"failed to unmask interrupts: %d\n",
+					ret);
+				return ret;
+			}
 			twl4030_clear_set_boot_bci(TWL4030_BCIAUTOAC|TWL4030_CVENAC, 0);
 			/* Watch dog key: WOVF acknowledge */
 			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x33,
-- 
2.20.1



