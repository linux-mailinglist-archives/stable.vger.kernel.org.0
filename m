Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2184CEEF3C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfKDV7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfKDV7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:12 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C1D20650;
        Mon,  4 Nov 2019 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904751;
        bh=XYF7y0BM07GfP9nY7zrjKzNbEKYrD2mjyfQAzvcSNZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pB4geZxWm38YoYQSfjrGmomzVb7ml2HroDnldWNif6WhdIcVtpJg9UUzldVOBRu0W
         rQE7JvXp+9bKqW2Ns4TSjhg8f0e8wcIXknn55TIb3+2Fmobsye6qvNGmnj/L7rbFxl
         uaVv2m9tQeNtoAKjlgo7knB0eDvaJuSdq7ICzDWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Kurz <akurz@blala.de>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/149] power: supply: max14656: fix potential use-after-free
Date:   Mon,  4 Nov 2019 22:44:10 +0100
Message-Id: <20191104212140.394613573@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



