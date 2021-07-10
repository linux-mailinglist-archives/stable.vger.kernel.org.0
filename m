Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6FB3C391A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhGJX5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhGJX4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D8A9613B6;
        Sat, 10 Jul 2021 23:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961137;
        bh=pfH0Ji+8ZDpSskIgX+PwG5GckvMLIe/0t8YKozXpRVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLAgb3Aa4a/wZYekofWhWZ6U2fSEajeOT9lJ+2yzcL7U+8Fg98c83z2a+cMJHVPE7
         PMgoJHVEZHvbBbs0QKlrP/d4YEF28QnL+x44ztSKn1dpvNuEtWlIyxpmR5PzEvQQ0Z
         xRkK5RIyLDwJjMfekreQGvVmwcFSP0FhCrDnzSkZ8xJaEUEYa4rTeQN1hcJIMJ3rC/
         QFKR6o6NDxuV8JvwyR7e1fQTlFBxV7OSS+bQ/YBc8JYIfNFOuvvEuxNZH9J6u5YOqn
         rl8pk9L1XlQMlAXoIaPGgGS8EELGIKpwqT27cJ9Zr4RREp3sVJJkfIBO4kgjc0WFtR
         zFpjxnate1lzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/21] power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
Date:   Sat, 10 Jul 2021 19:51:54 -0400
Message-Id: <20210710235212.3222375-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7fbf6b731bca347700e460d94b130f9d734b33e9 ]

Interrupt line can be configured on different hardware in different way,
even inverted.  Therefore driver should not enforce specific trigger
type - edge falling - but instead rely on Devicetree to configure it.

The Maxim 17047/77693 datasheets describe the interrupt line as active
low with a requirement of acknowledge from the CPU therefore the edge
falling is not correct.

The interrupt line is shared between PMIC and RTC driver, so using level
sensitive interrupt is here especially important to avoid races.  With
an edge configuration in case if first PMIC signals interrupt followed
shortly after by the RTC, the interrupt might not be yet cleared/acked
thus the second one would not be noticed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max17042_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 9c7eaaeda343..911d42366ef1 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1051,7 +1051,7 @@ static int max17042_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		unsigned int flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		unsigned int flags = IRQF_ONESHOT;
 
 		/*
 		 * On ACPI systems the IRQ may be handled by ACPI-event code,
-- 
2.30.2

