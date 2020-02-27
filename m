Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5582E171AA0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgB0Nzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgB0Nzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804EB2469B;
        Thu, 27 Feb 2020 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811731;
        bh=2vMDVmLuOR6BkAhzKPJBoLjsBQUyJrJMaKfCRoB8+CI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWyS/VkP+xebdXOlC1W73vcKVpX8nxWoTPO/jcrzEnBfldL2LO3m+LE84M67vrLlc
         je65TA6DlzvZugnkw451mUAXHsrEXVyf0J5WEFrTn0/4tR1lFwa59BVzIflOqIOqyW
         tJ5zAZGj4zzp9FpFXJip3y2hqT+KmeX3dxVPeRGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/237] regulator: rk808: Lower log level on optional GPIOs being not available
Date:   Thu, 27 Feb 2020 14:34:46 +0100
Message-Id: <20200227132302.438013018@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



