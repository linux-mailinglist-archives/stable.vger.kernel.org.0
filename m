Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC0FF4668
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbfKHLmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733210AbfKHLmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBF2222D4;
        Fri,  8 Nov 2019 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213328;
        bh=9fAtqds1VzPCxVoMPO2Bw4wJHGDRYIONBHw1nr1WOKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x11rAGNtCGzynWS8RquHYTqkOsjakeAU1mQ6GSELTZZg7+Y3RuyxGGh5/KRctVpC8
         98pSZ1piwcQw4mgnWkzQVvyb/j5gbCCGdnlhzTCW5BBpSCL0zt9m+lx2o0gVYBRf0C
         vS0yiQsfP83Cbvi7gS70HZrCu5SpBxqOhIcl82tY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 170/205] pinctrl: at91-pio4: fix has_config check in atmel_pctl_dt_subnode_to_map()
Date:   Fri,  8 Nov 2019 06:37:17 -0500
Message-Id: <20191108113752.12502-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b97760ae8e3dc8bb91881c13425a0bff55f2bd85 ]

Smatch complains about this condition:

	if (has_config && num_pins >= 1)

The "has_config" variable is either uninitialized or true.  The
"num_pins" variable is unsigned and we verified that it is non-zero on
the lines before so we know "num_pines >= 1" is true.  Really, we could
just check "num_configs" directly and remove the "has_config" variable.

Fixes: 776180848b57 ("pinctrl: introduce driver for Atmel PIO4 controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91-pio4.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index ef7ab208b951e..9e2f3738bf3ec 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -493,7 +493,6 @@ static int atmel_pctl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned num_pins, num_configs, reserve;
 	unsigned long *configs;
 	struct property	*pins;
-	bool has_config;
 	u32 pinfunc;
 	int ret, i;
 
@@ -509,9 +508,6 @@ static int atmel_pctl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		return ret;
 	}
 
-	if (num_configs)
-		has_config = true;
-
 	num_pins = pins->length / sizeof(u32);
 	if (!num_pins) {
 		dev_err(pctldev->dev, "no pins found in node %pOF\n", np);
@@ -524,7 +520,7 @@ static int atmel_pctl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	 * map for each pin.
 	 */
 	reserve = 1;
-	if (has_config && num_pins >= 1)
+	if (num_configs)
 		reserve++;
 	reserve *= num_pins;
 	ret = pinctrl_utils_reserve_map(pctldev, map, reserved_maps, num_maps,
@@ -547,7 +543,7 @@ static int atmel_pctl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		pinctrl_utils_add_map_mux(pctldev, map, reserved_maps, num_maps,
 					  group, func);
 
-		if (has_config) {
+		if (num_configs) {
 			ret = pinctrl_utils_add_map_configs(pctldev, map,
 					reserved_maps, num_maps, group,
 					configs, num_configs,
-- 
2.20.1

