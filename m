Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0A15E16D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404799AbgBNQSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404791AbgBNQSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE85824692;
        Fri, 14 Feb 2020 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697115;
        bh=2vMDVmLuOR6BkAhzKPJBoLjsBQUyJrJMaKfCRoB8+CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMKX8JPqq8VpU3COJuDHHN5ANAP4gxhkBZWYtSj36nHyoDL2fr0ghjszzb/5CXpVk
         CVzd9I07SFem4PxUonWbPC562ND2l4AjayL7a1Crz3UytDyJaJYvj5R5yObh38lVcL
         vK2pYTvsSc0s/UCRKyic5ZqM7DSd0dzM/De9jcek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 062/186] regulator: rk808: Lower log level on optional GPIOs being not available
Date:   Fri, 14 Feb 2020 11:15:11 -0500
Message-Id: <20200214161715.18113-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit b8a039d37792067c1a380dc710361905724b9b2f ]

RK808 can leverage a couple of GPIOs to tweak the ramp rate during DVS
(Dynamic Voltage Scaling). These GPIOs are entirely optional but a
dev_warn() appeared when cleaning this driver to use a more up-to-date
gpiod API. At least reduce the log level to 'info' as it is totally
fine to not populate these GPIO on a hardware design.

This change is trivial but it is worth not polluting the logs during
bringup phase by having real warnings and errors sorted out
correctly.

Fixes: a13eaf02e2d6 ("regulator: rk808: make better use of the gpiod API")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20191203164709.11127-1-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rk808-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 213b68743cc89..92498ac503035 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -714,7 +714,7 @@ static int rk808_regulator_dt_parse_pdata(struct device *dev,
 		}
 
 		if (!pdata->dvs_gpio[i]) {
-			dev_warn(dev, "there is no dvs%d gpio\n", i);
+			dev_info(dev, "there is no dvs%d gpio\n", i);
 			continue;
 		}
 
-- 
2.20.1

