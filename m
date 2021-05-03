Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89574371C11
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhECQvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhECQsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:48:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D0B61430;
        Mon,  3 May 2021 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060007;
        bh=Uz6pSn0OahnFxDtAvlu/orHdqvVlgWzmt0UFYg52VB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPhYb62fboriJoIfkQGM4LsUaR/A8FaMWZOj0fCiJTEsnLsE9udY9ZQe7dVk4BXmh
         pCc57JIHZV97rDoSO9BYE3MB/k9VPnSk2uC+gw4NcB9QjVZLcwbjp8kG7ltylIdoKL
         iG7nj/lvxLIjP1zonvvdfXLD061YWIwpfv2Cp/+S0ZA7udn/I7m4cViL61GmtgFvN8
         57n6rQK4M8o287do4QLBq7Qntqm7hzyQQrVsKmGEQM6aYxu6Z+SoNBCSOHNp7xkAlg
         pDY8G1lJoaupj52jviZjqPyfRkM/bfwYJTADteckOd3LWE0aEFpT6PlUdfNi3DmvLp
         aJ3aW7MtKduUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     dongjian <dongjian@yulong.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/57] power: supply: Use IRQF_ONESHOT
Date:   Mon,  3 May 2021 12:39:01 -0400
Message-Id: <20210503163941.2853291-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index e7931ffb7151..397e5a03b7d9 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -501,7 +501,7 @@ static int lp8788_set_irqs(struct platform_device *pdev,
 
 		ret = request_threaded_irq(virq, NULL,
 					lp8788_charger_irq_thread,
-					0, name, pchg);
+					IRQF_ONESHOT, name, pchg);
 		if (ret)
 			break;
 	}
diff --git a/drivers/power/supply/pm2301_charger.c b/drivers/power/supply/pm2301_charger.c
index 17749fc90e16..d2aff1cf4f79 100644
--- a/drivers/power/supply/pm2301_charger.c
+++ b/drivers/power/supply/pm2301_charger.c
@@ -1095,7 +1095,7 @@ static int pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	ret = request_threaded_irq(gpio_to_irq(pm2->pdata->gpio_irq_number),
 				NULL,
 				pm2xxx_charger_irq[0].isr,
-				pm2->pdata->irq_type,
+				pm2->pdata->irq_type | IRQF_ONESHOT,
 				pm2xxx_charger_irq[0].name, pm2);
 
 	if (ret != 0) {
diff --git a/drivers/power/supply/tps65090-charger.c b/drivers/power/supply/tps65090-charger.c
index 6b0098e5a88b..0990b2fa6cd8 100644
--- a/drivers/power/supply/tps65090-charger.c
+++ b/drivers/power/supply/tps65090-charger.c
@@ -301,7 +301,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 
 	if (irq != -ENXIO) {
 		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-			tps65090_charger_isr, 0, "tps65090-charger", cdata);
+			tps65090_charger_isr, IRQF_ONESHOT, "tps65090-charger", cdata);
 		if (ret) {
 			dev_err(cdata->dev,
 				"Unable to register irq %d err %d\n", irq,
diff --git a/drivers/power/supply/tps65217_charger.c b/drivers/power/supply/tps65217_charger.c
index 814c2b81fdfe..ba33d1617e0b 100644
--- a/drivers/power/supply/tps65217_charger.c
+++ b/drivers/power/supply/tps65217_charger.c
@@ -238,7 +238,7 @@ static int tps65217_charger_probe(struct platform_device *pdev)
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

