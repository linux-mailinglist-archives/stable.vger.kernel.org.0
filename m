Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750AE401438
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241236AbhIFBcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245003AbhIFB3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16C0611C6;
        Mon,  6 Sep 2021 01:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891409;
        bh=eP1WFQhf31Lq4TK7PAKnhlXK4e5Ou+XXurZgzDm4qao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2etP8TgcM7L2DBPbnpdB5pRtT4q9ODZL6eywncHQbV087mrO+V/0CDpluNI6oeYK
         WNHyGbfe9g5W/snyUKIaJw29gxoyoAKAIpLiaEK5o1vO3e9u5U3sKwa6oaIzrmq5QM
         hRToOWcQ7ZIawY57/0Ju5GWX+7OX+p9+pY0aooiI3vE7vZ2UprJb+BlUsWVo5YrnJO
         iP+bKxGl7xwzcn0LxgDsqx8ySDzVmiJnWTMjbWX3s4zXsCfOTjgbOiAhXx/6esrBGZ
         yZsv0f5A29ueUemJD9s3s0O+ZLorUlbTGDhDQ3E/1OkJ2fW3/F1o/gm4RyQoh57Ny2
         +nayv+XaVPPhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/23] power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
Date:   Sun,  5 Sep 2021 21:23:04 -0400
Message-Id: <20210906012322.930668-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit caa534c3ba40c6e8352b42cbbbca9ba481814ac8 ]

When fuel_gauge_reg_readb()/_writeb() fails, report which register we
were trying to read / write when the error happened.

Also reword the message a bit:
- Drop the axp288 prefix, dev_err() already prints this
- Switch from telegram / abbreviated style to a normal sentence, aligning
  the message with those from fuel_gauge_read_*bit_word()

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_fuel_gauge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index 157cf5ec6b02..1641868c345c 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -158,7 +158,7 @@ static int fuel_gauge_reg_readb(struct axp288_fg_info *info, int reg)
 	}
 
 	if (ret < 0) {
-		dev_err(&info->pdev->dev, "axp288 reg read err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error reading reg 0x%02x err: %d\n", reg, ret);
 		return ret;
 	}
 
@@ -172,7 +172,7 @@ static int fuel_gauge_reg_writeb(struct axp288_fg_info *info, int reg, u8 val)
 	ret = regmap_write(info->regmap, reg, (unsigned int)val);
 
 	if (ret < 0)
-		dev_err(&info->pdev->dev, "axp288 reg write err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error writing reg 0x%02x err: %d\n", reg, ret);
 
 	return ret;
 }
-- 
2.30.2

