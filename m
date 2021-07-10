Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B873C3787
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhGJXwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhGJXwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A84B61057;
        Sat, 10 Jul 2021 23:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960970;
        bh=zWPWy9z0d0S0lEkxJfttdaXSj32THijNC1L5hxKEctI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XydGA+aRkbrAxzR7Z/YD8vSaMH30cr/R0FnhLUuTVWOapAHhu0CDKPdyI/iAcMnjh
         Jr0iMutWl0qNIYBo+zi12HjbK6Q7Grn8pR5NIKpSi/kTOPzKexpbcSFywAjVeXours
         1Bb38FW8cFilBcoOFGS3c2imOSPCIQahV6EjeMRgDw0pj3Z/DDy2/zv/WnoUyYcDFE
         kQJzxVxYTKp2xOPt1CA6Ofmx6JOp6N49CxRi2cfGpzsQv49d/T6s0rCiTsObKmbT7o
         eqaAd8JJ9ZY8Ro0ABpoJCJ9nE43DnCLME+zPBNK8aQs8bK2XNVRmNL5MstijT+lndM
         hnZA00t1KQhcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/43] power: supply: max17042: Do not enforce (incorrect) interrupt trigger type
Date:   Sat, 10 Jul 2021 19:48:40 -0400
Message-Id: <20210710234915.3220342-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
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
index 79d4b5988360..8117ecabe31c 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1104,7 +1104,7 @@ static int max17042_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		unsigned int flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		unsigned int flags = IRQF_ONESHOT;
 
 		/*
 		 * On ACPI systems the IRQ may be handled by ACPI-event code,
-- 
2.30.2

