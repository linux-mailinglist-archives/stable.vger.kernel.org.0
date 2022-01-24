Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EEB4998D5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453522AbiAXVaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450269AbiAXVUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:20:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03601B81142;
        Mon, 24 Jan 2022 21:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BFEC340E4;
        Mon, 24 Jan 2022 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059205;
        bh=Me67gsWeV+RFSnXE3+KumzwdeAVvLxMDCMedH2J8DJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7cn0C9B4oaPvcEpHKzJc4Z9wtO8aRzYgUHHaedSfDR4r2jCGAZajiqGlbE6Hfm4f
         LgD/KOaNr3pZW3NvCYzpkIfbHo67m0Njbi7SVQ/3VPaoZP/RhcXmXE/93bt8Q9kQ3A
         k7+gOTNIvyZhcnTLOj3mixnbr+camGeyNdxP34TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0538/1039] leds: lp55xx: initialise output direction from dts
Date:   Mon, 24 Jan 2022 19:38:47 +0100
Message-Id: <20220124184143.361853911@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Merlijn Wajer <merlijn@wizzup.org>

[ Upstream commit 9e87a8da747bf72365abb79e6f64fcca955b4f56 ]

Commit a5d3d1adc95f ("leds: lp55xx: Initialize enable GPIO direction to
output") attempts to fix this, but the fix did not work since at least
for the Nokia N900 the value needs to be set to HIGH, per the device
tree. So rather than hardcoding the value to a potentially invalid value
for some devices, let's set direction in lp55xx_init_device.

Fixes: a5d3d1adc95f ("leds: lp55xx: Initialize enable GPIO direction to output")
Fixes: 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
Fixes: ac219bf3c9bd ("leds: lp55xx: Convert to use GPIO descriptors")
Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lp55xx-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index d1657c46ee2f8..9fdfc1b9a1a0c 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -439,6 +439,8 @@ int lp55xx_init_device(struct lp55xx_chip *chip)
 		return -EINVAL;
 
 	if (pdata->enable_gpiod) {
+		gpiod_direction_output(pdata->enable_gpiod, 0);
+
 		gpiod_set_consumer_name(pdata->enable_gpiod, "LP55xx enable");
 		gpiod_set_value(pdata->enable_gpiod, 0);
 		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
@@ -694,7 +696,7 @@ struct lp55xx_platform_data *lp55xx_of_populate_pdata(struct device *dev,
 	of_property_read_u8(np, "clock-mode", &pdata->clock_mode);
 
 	pdata->enable_gpiod = devm_gpiod_get_optional(dev, "enable",
-						      GPIOD_OUT_LOW);
+						      GPIOD_ASIS);
 	if (IS_ERR(pdata->enable_gpiod))
 		return ERR_CAST(pdata->enable_gpiod);
 
-- 
2.34.1



