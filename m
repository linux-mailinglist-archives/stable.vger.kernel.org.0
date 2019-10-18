Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3366ADD4A7
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJRWES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfJRWER (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5D97222C9;
        Fri, 18 Oct 2019 22:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436257;
        bh=/TiINZmJsoedbiu+tJ48La03mc4J9pQ/MseuO/2nh5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSMEdOLSqBDzj53vkaNzhLdV8AJnoqwJswIdkaxQVt1TdwPdtF9rJkdESBuaUfDyM
         JIu73blPGNgwaQdZ74meNukhYD0M+QYZuU3jdv/+NHkZdaA0yQEqEBH047XbELmyNF
         l3rCAWEjn/4W/0IfNAqvTFNO8VPyfbnxMPkLA+Ec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 40/89] gpio: max77620: Use correct unit for debounce times
Date:   Fri, 18 Oct 2019 18:02:35 -0400
Message-Id: <20191018220324.8165-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit fffa6af94894126994a7600c6f6f09b892e89fa9 ]

The gpiod_set_debounce() function takes the debounce time in
microseconds. Adjust the switch/case values in the MAX77620 GPIO to use
the correct unit.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20191002122825.3948322-1-thierry.reding@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-max77620.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max77620.c b/drivers/gpio/gpio-max77620.c
index b7d89e30131e2..06e8caaafa811 100644
--- a/drivers/gpio/gpio-max77620.c
+++ b/drivers/gpio/gpio-max77620.c
@@ -192,13 +192,13 @@ static int max77620_gpio_set_debounce(struct max77620_gpio *mgpio,
 	case 0:
 		val = MAX77620_CNFG_GPIO_DBNC_None;
 		break;
-	case 1 ... 8:
+	case 1000 ... 8000:
 		val = MAX77620_CNFG_GPIO_DBNC_8ms;
 		break;
-	case 9 ... 16:
+	case 9000 ... 16000:
 		val = MAX77620_CNFG_GPIO_DBNC_16ms;
 		break;
-	case 17 ... 32:
+	case 17000 ... 32000:
 		val = MAX77620_CNFG_GPIO_DBNC_32ms;
 		break;
 	default:
-- 
2.20.1

