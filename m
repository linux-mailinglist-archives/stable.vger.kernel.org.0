Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806C3442A1
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfFMQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbfFMIhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B813D20851;
        Thu, 13 Jun 2019 08:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415040;
        bh=ZPH16qG/Ca5t+j0juJTeNqQ9wDqZdh+nyOxINpzAyb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6/EOqZ6DH5BsfSdm+eKplUlTasolbIOmOhMvMIq404xJq7yh4DI9yJHBErS8CmiZ
         62hlkVDSrufsscw4k1xIs1+MgHVsYLueNVsL7lxAsJZMyY7aD5iATKqAavIn3bZgyA
         XQlPZ22r6upbDHRyXBwWRavBO/3Z+Skl9gZbGxQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Kurz <akurz@blala.de>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 63/81] power: supply: max14656: fix potential use-before-alloc
Date:   Thu, 13 Jun 2019 10:33:46 +0200
Message-Id: <20190613075653.690359440@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0cd0e49711556d2331a06b1117b68dd786cb54d2 ]

Call order on probe():
- max14656_hw_init() enables interrupts on the chip
- devm_request_irq() starts processing interrupts, isr
  could be called immediately
-    isr: schedules delayed work (irq_work)
-    irq_work: calls power_supply_changed()
- devm_power_supply_register() registers the power supply

Depending on timing, it's possible that power_supply_changed()
is called on an unregistered power supply structure.

Fix by registering the power supply before requesting the irq.

Cc: Alexander Kurz <akurz@blala.de>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max14656_charger_detector.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/power/supply/max14656_charger_detector.c b/drivers/power/supply/max14656_charger_detector.c
index b91b1d2999dc..d19307f791c6 100644
--- a/drivers/power/supply/max14656_charger_detector.c
+++ b/drivers/power/supply/max14656_charger_detector.c
@@ -280,6 +280,13 @@ static int max14656_probe(struct i2c_client *client,
 
 	INIT_DELAYED_WORK(&chip->irq_work, max14656_irq_worker);
 
+	chip->detect_psy = devm_power_supply_register(dev,
+		       &chip->psy_desc, &psy_cfg);
+	if (IS_ERR(chip->detect_psy)) {
+		dev_err(dev, "power_supply_register failed\n");
+		return -EINVAL;
+	}
+
 	ret = devm_request_irq(dev, chip->irq, max14656_irq,
 			       IRQF_TRIGGER_FALLING,
 			       MAX14656_NAME, chip);
@@ -289,13 +296,6 @@ static int max14656_probe(struct i2c_client *client,
 	}
 	enable_irq_wake(chip->irq);
 
-	chip->detect_psy = devm_power_supply_register(dev,
-		       &chip->psy_desc, &psy_cfg);
-	if (IS_ERR(chip->detect_psy)) {
-		dev_err(dev, "power_supply_register failed\n");
-		return -EINVAL;
-	}
-
 	schedule_delayed_work(&chip->irq_work, msecs_to_jiffies(2000));
 
 	return 0;
-- 
2.20.1



