Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D590DD3CF
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393981AbfJRWUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731839AbfJRWGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1678222D1;
        Fri, 18 Oct 2019 22:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436399;
        bh=XYF7y0BM07GfP9nY7zrjKzNbEKYrD2mjyfQAzvcSNZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glyBhlngT6a49CHs5Dh2X4Uu/WIOV+2kNtIE4owXMLLTpg0S9F3kQQRff4f8nEHDq
         yrLyOu3/qJIDIwHM1dL4XfyaletQOMrOYnodl+5PxjLjxm0oMp5W6t6yGIEtU0JD1q
         hxeGEBaCTvZwVnSmFQnkS74NlJEKHkTtrbIqQF78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Alexander Kurz <akurz@blala.de>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 049/100] power: supply: max14656: fix potential use-after-free
Date:   Fri, 18 Oct 2019 18:04:34 -0400
Message-Id: <20191018220525.9042-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 252fbeb86ceffa549af9842cefca2412d53a7653 ]

Explicitly cancel/sync the irq_work delayed work, otherwise
there's a chance that it will run after the device is removed,
which would result in a use-after-free.

Note that cancel/sync should happen:
- after irq's have been disabled, as the isr re-schedules the work
- before the power supply is unregistered, because the work func
    uses the power supply handle.

Cc: Alexander Kurz <akurz@blala.de>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../power/supply/max14656_charger_detector.c    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max14656_charger_detector.c b/drivers/power/supply/max14656_charger_detector.c
index d19307f791c68..9e6472834e373 100644
--- a/drivers/power/supply/max14656_charger_detector.c
+++ b/drivers/power/supply/max14656_charger_detector.c
@@ -240,6 +240,14 @@ static enum power_supply_property max14656_battery_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
 };
 
+static void stop_irq_work(void *data)
+{
+	struct max14656_chip *chip = data;
+
+	cancel_delayed_work_sync(&chip->irq_work);
+}
+
+
 static int max14656_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
@@ -278,8 +286,6 @@ static int max14656_probe(struct i2c_client *client,
 	if (ret)
 		return -ENODEV;
 
-	INIT_DELAYED_WORK(&chip->irq_work, max14656_irq_worker);
-
 	chip->detect_psy = devm_power_supply_register(dev,
 		       &chip->psy_desc, &psy_cfg);
 	if (IS_ERR(chip->detect_psy)) {
@@ -287,6 +293,13 @@ static int max14656_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	INIT_DELAYED_WORK(&chip->irq_work, max14656_irq_worker);
+	ret = devm_add_action(dev, stop_irq_work, chip);
+	if (ret) {
+		dev_err(dev, "devm_add_action %d failed\n", ret);
+		return ret;
+	}
+
 	ret = devm_request_irq(dev, chip->irq, max14656_irq,
 			       IRQF_TRIGGER_FALLING,
 			       MAX14656_NAME, chip);
-- 
2.20.1

