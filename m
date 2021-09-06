Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76234012E7
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhIFBW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239117AbhIFBWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EA4861050;
        Mon,  6 Sep 2021 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891259;
        bh=N2cw0vw9Ce3FtJp9qeQZlnLgkWX8LJQvvX+Qh0nLp5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5K/8XFsIqAfbs9J5cSgSgDQBkcUr+8q3tpLEoTHzAaGpg1hdKI2xQ+6hdYwoPKJl
         gVCj3XDNLrMTBACIADIHudhHofq1eCCjpSM30Rv3vZwR4PQgxDaOiqdwvhILw0PIk/
         V0Fjh1RrZ+jxW88fC3rkBkBvyDB/XLUlTOlixgFMr9514KWcR1EeJjL3bKP8xoRfCv
         vGbIAO1zvoJa/qqSgoVm4NiJg2qbOgUOLNvZEv1tHzIzwFARZMKij0I6fOgKDJ809+
         gaTnttC8HDobA8uIdQzfaPYRXvzs9CsJQmZQ+Z/hYr8/qM5ksyQ3f3R4/hZQ55fLL6
         715vY/IPuBEjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 06/46] power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
Date:   Sun,  5 Sep 2021 21:20:11 -0400
Message-Id: <20210906012052.929174-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index 37af0e216bc3..225adaffaa28 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -149,7 +149,7 @@ static int fuel_gauge_reg_readb(struct axp288_fg_info *info, int reg)
 	}
 
 	if (ret < 0) {
-		dev_err(&info->pdev->dev, "axp288 reg read err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error reading reg 0x%02x err: %d\n", reg, ret);
 		return ret;
 	}
 
@@ -163,7 +163,7 @@ static int fuel_gauge_reg_writeb(struct axp288_fg_info *info, int reg, u8 val)
 	ret = regmap_write(info->regmap, reg, (unsigned int)val);
 
 	if (ret < 0)
-		dev_err(&info->pdev->dev, "axp288 reg write err:%d\n", ret);
+		dev_err(&info->pdev->dev, "Error writing reg 0x%02x err: %d\n", reg, ret);
 
 	return ret;
 }
-- 
2.30.2

