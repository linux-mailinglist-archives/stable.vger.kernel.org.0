Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CECD371CE1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhECQ5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234792AbhECQyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:54:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7910C61952;
        Mon,  3 May 2021 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060140;
        bh=l+lPckUWtfmMfgnw1V58b39aVdu81Xf38AqpRgERYek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NnT27Hg9M8K3gSVdTNOn47y0k6H99VW+EDBTplBltH12EwvSVLue16eY6Fgn7zsSU
         cLc5x1wQUPxygzLZu4c45IZEaWc6TZKpc9LXNIG8teAL/9rvGvgv5mKHSm7KxM6fie
         jyEzDkRLc11d2gYv97AQyedNVpvrwnPGofwM9gcIIWN7tzsd1svusRCauduQIIK/XR
         BRAANGCp43WFUEuQTNI5fqQ3Z+6xy5B4+5RwhQT98YlaC8l4QsjmzRePvkp7BY3udm
         60Pn+XHbH9WyQwaX21QKMWfKavrUtHXyQaelEDfCwrTpSqy6/Hzt4Vk2TfHQQ5wi9z
         AloJipXzZwjiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     dongjian <dongjian@yulong.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/31] power: supply: Use IRQF_ONESHOT
Date:   Mon,  3 May 2021 12:41:43 -0400
Message-Id: <20210503164204.2854178-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b8f7dac7ac3f..6dcabbeccde1 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -529,7 +529,7 @@ static int lp8788_set_irqs(struct platform_device *pdev,
 
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
index 1f5234098aaf..7295c1b13f93 100644
--- a/drivers/power/supply/tps65217_charger.c
+++ b/drivers/power/supply/tps65217_charger.c
@@ -250,7 +250,7 @@ static int tps65217_charger_probe(struct platform_device *pdev)
 	for (i = 0; i < NUM_CHARGER_IRQS; i++) {
 		ret = devm_request_threaded_irq(&pdev->dev, irq[i], NULL,
 						tps65217_charger_irq,
-						0, "tps65217-charger",
+						IRQF_ONESHOT, "tps65217-charger",
 						charger);
 		if (ret) {
 			dev_err(charger->dev,
-- 
2.30.2

