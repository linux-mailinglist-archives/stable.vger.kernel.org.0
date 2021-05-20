Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74DE38A848
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhETKsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238103AbhETKqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 678B461CAC;
        Thu, 20 May 2021 09:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504683;
        bh=RXzOjeD3DtTd5ZVkHsoedyHcI866GHHZ1NV/ShCYFjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nItNJgVf2W95vDnPOi4tY5eEA2d25huKJC7WhQBOfeumjywON4C6butnHt35lauzA
         hJa8yL3ieJ3mqWTYja0MGjsSqIAQ1wSZjUGXb0LTqKUMyUV3E3xFMphMpJgNfT1Qai
         wlM5TlLzEeOO6EJo9LsEZEls1qp7KPbrDWp54n5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dongjian <dongjian@yulong.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/240] power: supply: Use IRQF_ONESHOT
Date:   Thu, 20 May 2021 11:20:24 +0200
Message-Id: <20210520092109.739008635@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dongjian <dongjian@yulong.com>

[ Upstream commit 2469b836fa835c67648acad17d62bc805236a6ea ]

Fixes coccicheck error:

drivers/power/supply/pm2301_charger.c:1089:7-27: ERROR:
drivers/power/supply/lp8788-charger.c:502:8-28: ERROR:
drivers/power/supply/tps65217_charger.c:239:8-33: ERROR:
drivers/power/supply/tps65090-charger.c:303:8-33: ERROR:

Threaded IRQ with no primary handler requested without IRQF_ONESHOT

Signed-off-by: dongjian <dongjian@yulong.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c   | 2 +-
 drivers/power/supply/pm2301_charger.c   | 2 +-
 drivers/power/supply/tps65090-charger.c | 2 +-
 drivers/power/supply/tps65217_charger.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index c3075ea011b6..e800beff1f8f 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -532,7 +532,7 @@ static int lp8788_set_irqs(struct platform_device *pdev,
 
 		ret = request_threaded_irq(virq, NULL,
 					lp8788_charger_irq_thread,
-					0, name, pchg);
+					IRQF_ONESHOT, name, pchg);
 		if (ret)
 			break;
 	}
diff --git a/drivers/power/supply/pm2301_charger.c b/drivers/power/supply/pm2301_charger.c
index 78561b6884fc..9ef218d76aa9 100644
--- a/drivers/power/supply/pm2301_charger.c
+++ b/drivers/power/supply/pm2301_charger.c
@@ -1098,7 +1098,7 @@ static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	ret = request_threaded_irq(gpio_to_irq(pm2->pdata->gpio_irq_number),
 				NULL,
 				pm2xxx_charger_irq[0].isr,
-				pm2->pdata->irq_type,
+				pm2->pdata->irq_type | IRQF_ONESHOT,
 				pm2xxx_charger_irq[0].name, pm2);
 
 	if (ret != 0) {
diff --git a/drivers/power/supply/tps65090-charger.c b/drivers/power/supply/tps65090-charger.c
index 1b4b5e09538e..297bf58f0d4f 100644
--- a/drivers/power/supply/tps65090-charger.c
+++ b/drivers/power/supply/tps65090-charger.c
@@ -311,7 +311,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 
 	if (irq != -ENXIO) {
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-			tps65090_charger_isr, 0, "tps65090-charger", cdata);
+			tps65090_charger_isr, IRQF_ONESHOT, "tps65090-charger", cdata);
 		if (ret) {
 			dev_err(cdata->dev,
 				"Unable to register irq %d err %d\n", irq,
diff --git a/drivers/power/supply/tps65217_charger.c b/drivers/power/supply/tps65217_charger.c
index 9fd019f9b88c..a6b4eb61b4bb 100644
--- a/drivers/power/supply/tps65217_charger.c
+++ b/drivers/power/supply/tps65217_charger.c
@@ -238,7 +238,7 @@ static int tps65217_charger_probe(struct platform_device *pdev)
 	if (irq != -ENXIO) {
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 						tps65217_charger_irq,
-						0, "tps65217-charger",
+						IRQF_ONESHOT, "tps65217-charger",
 						charger);
 		if (ret) {
 			dev_err(charger->dev,
-- 
2.30.2



