Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19B015EC91
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbgBNQHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390804AbgBNQHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49842206D7;
        Fri, 14 Feb 2020 16:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696474;
        bh=8gg111GgiL284py8cdb/2hkDji1GxlitkItG9drCMpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlXwh3rPYScqJ/IZd/FUjq7FyDCaRmMQEiuwmbSNf0BQ5L6Dc1n1YhUqXfiT3ougz
         paoAGT3TCJUmKlyAR4WzhywWUgf1JKVxm0oW9deBHbyhBBhXoZ3+tqccvMZFMxsCSJ
         9fByJZ0eTSqV2Qz3ntsF/U3FkJcTQoIblC29z0eU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 282/459] ARM: at91: pm: use of_device_id array to find the proper shdwc node
Date:   Fri, 14 Feb 2020 10:58:52 -0500
Message-Id: <20200214160149.11681-282-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit ec6e618c8c018c1361d77789a100a5f6f6317178 ]

Use of_device_id array to find the proper shdwc compatibile node.
SAM9X60's shdwc changes were not integrated when
commit eaedc0d379da ("ARM: at91: pm: add ULP1 support for SAM9X60")
was integrated.

Fixes: eaedc0d379da ("ARM: at91: pm: add ULP1 support for SAM9X60")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1576062248-18514-3-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 03250768340e4..52665f30d236d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -691,6 +691,12 @@ static void __init at91_pm_use_default_mode(int pm_mode)
 		soc_pm.data.suspend_mode = AT91_PM_ULP0;
 }
 
+static const struct of_device_id atmel_shdwc_ids[] = {
+	{ .compatible = "atmel,sama5d2-shdwc" },
+	{ .compatible = "microchip,sam9x60-shdwc" },
+	{ /* sentinel. */ }
+};
+
 static void __init at91_pm_modes_init(void)
 {
 	struct device_node *np;
@@ -700,7 +706,7 @@ static void __init at91_pm_modes_init(void)
 	    !at91_is_pm_mode_active(AT91_PM_ULP1))
 		return;
 
-	np = of_find_compatible_node(NULL, NULL, "atmel,sama5d2-shdwc");
+	np = of_find_matching_node(NULL, atmel_shdwc_ids);
 	if (!np) {
 		pr_warn("%s: failed to find shdwc!\n", __func__);
 		goto ulp1_default;
-- 
2.20.1

