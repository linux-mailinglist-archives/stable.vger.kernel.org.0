Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C806411F38
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346773AbhITRi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352008AbhITRg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A515561B2B;
        Mon, 20 Sep 2021 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157607;
        bh=eP1WFQhf31Lq4TK7PAKnhlXK4e5Ou+XXurZgzDm4qao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy2Om66z60K3JXduKUwFs3OidYuFYgbX3W211F/MFYznXOdoMSotbKcaKw379q1BU
         /PlDYqDRxJuD3e2dssuF3XJsTOShwQo/5kj1pwXCcaRtwxSIxMIDRcWpjZ09dMjGKM
         JiZa4vpjU5TPreTN8iwmAlRmrsc/2Z7w7U7iyjWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/293] power: supply: axp288_fuel_gauge: Report register-address on readb / writeb errors
Date:   Mon, 20 Sep 2021 18:39:58 +0200
Message-Id: <20210920163934.515428659@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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



