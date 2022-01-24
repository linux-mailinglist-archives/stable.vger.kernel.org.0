Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3C499BC5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1457183AbiAXVzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573913AbiAXVqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:46:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82154C08B4D3;
        Mon, 24 Jan 2022 12:32:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4FA61593;
        Mon, 24 Jan 2022 20:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD622C36AE2;
        Mon, 24 Jan 2022 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056360;
        bh=Me67gsWeV+RFSnXE3+KumzwdeAVvLxMDCMedH2J8DJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vah95zA5+O9fDFv8qYvVAHv4MZnvQJDuBARSesJf3DSXCghhuqkzPwpZChU7RRQml
         KyU1bMuKidwneYG5ilbrvawnArSpX4aELa4+26wAIe7n2XOy9Jamr6WH9BbMJOgBew
         JiSPN5KHNqeaMQKti905SRFKdIwTuNG72uln7jAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Merlijn Wajer <merlijn@wizzup.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/846] leds: lp55xx: initialise output direction from dts
Date:   Mon, 24 Jan 2022 19:39:35 +0100
Message-Id: <20220124184116.771606298@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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



