Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658F7408E80
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbhIMNfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242483AbhIMN3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F3661354;
        Mon, 13 Sep 2021 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539450;
        bh=jLa9bZIjWiXqboxB1Luym7DLUd9su7iVxlQkiTZxnR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kqIBWDs3UM2kCr7V6vws9D0+fZe9onfAicsvEYc5EnxjEp06ecHNXBIXYsYwzWT9
         04qDgwSFN0aAx9AfRdNc8bVcpEhvdSq3Y5Z7w1hTYChmPmEZWbD4crtOiUwm8LRMUP
         j5Qv+OG+jW4zVzbE9G+QvSyv/kosS2eh2wSJ4uKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/236] power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
Date:   Mon, 13 Sep 2021 15:11:51 +0200
Message-Id: <20210913131100.539750159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 148eb8105803..be24529157be 100644
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



