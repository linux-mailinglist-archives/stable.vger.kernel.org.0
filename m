Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400A4BCFEB
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfIXRCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632842AbfIXQm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D91521783;
        Tue, 24 Sep 2019 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343376;
        bh=/P72MjB8XhN4/ZZi1bmLbv5QAnQz2BwhA6RjE5T6u/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReUInaZOcC6IEgmX09uszfo5IrdYC6kMnPwLz/+6clJFuuyP0ZhSRBTW0ntct8gnG
         FkKPTYD++drYDWZOeDuK/vwkLDGmEYXwnIDCZPXjCVKFcae4PJCzuuBfs+A+u5yIFd
         kpDkaiYVyFFKtgL6DHBll5hoLlSLTZ4wTB1nodw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Amelie Delaunay <amelie.delaunay@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 25/87] pinctrl: stmfx: update pinconf settings
Date:   Tue, 24 Sep 2019 12:40:41 -0400
Message-Id: <20190924164144.25591-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

[ Upstream commit a502b343ebd0eab38f3cb33fbb84011847cf5aac ]

According to the following tab (coming from STMFX datasheet), updates
have to done in stmfx_pinconf_set function:

-"type" has to be set when "bias" is configured as "pull-up or pull-down"
-PIN_CONFIG_DRIVE_PUSH_PULL should only be used when gpio is configured as
 output. There is so no need to check direction.

DIR | TYPE | PUPD | MFX GPIO configuration
----|------|------|---------------------------------------------------
1   | 1    | 1    | OUTPUT open drain with internal pull-up resistor
----|------|------|---------------------------------------------------
1   | 1    | 0    | OUTPUT open drain with internal pull-down resistor
----|------|------|---------------------------------------------------
1   | 0    | 0/1  | OUTPUT push pull no pull
----|------|------|---------------------------------------------------
0   | 1    | 1    | INPUT with internal pull-up resistor
----|------|------|---------------------------------------------------
0   | 1    | 0    | INPUT with internal pull-down resistor
----|------|------|---------------------------------------------------
0   | 0    | 1    | INPUT floating
----|------|------|---------------------------------------------------
0   | 0    | 0    | analog (GPIO not used, default setting)

Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@st.com>
Link: https://lore.kernel.org/r/1564053416-32192-1-git-send-email-amelie.delaunay@st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-stmfx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-stmfx.c b/drivers/pinctrl/pinctrl-stmfx.c
index d3332da356372..31b6e511670fc 100644
--- a/drivers/pinctrl/pinctrl-stmfx.c
+++ b/drivers/pinctrl/pinctrl-stmfx.c
@@ -296,29 +296,29 @@ static int stmfx_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		switch (param) {
 		case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
 		case PIN_CONFIG_BIAS_DISABLE:
+		case PIN_CONFIG_DRIVE_PUSH_PULL:
+			ret = stmfx_pinconf_set_type(pctl, pin, 0);
+			if (ret)
+				return ret;
+			break;
 		case PIN_CONFIG_BIAS_PULL_DOWN:
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
+			if (ret)
+				return ret;
 			ret = stmfx_pinconf_set_pupd(pctl, pin, 0);
 			if (ret)
 				return ret;
 			break;
 		case PIN_CONFIG_BIAS_PULL_UP:
-			ret = stmfx_pinconf_set_pupd(pctl, pin, 1);
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
 			if (ret)
 				return ret;
-			break;
-		case PIN_CONFIG_DRIVE_OPEN_DRAIN:
-			if (!dir)
-				ret = stmfx_pinconf_set_type(pctl, pin, 1);
-			else
-				ret = stmfx_pinconf_set_type(pctl, pin, 0);
+			ret = stmfx_pinconf_set_pupd(pctl, pin, 1);
 			if (ret)
 				return ret;
 			break;
-		case PIN_CONFIG_DRIVE_PUSH_PULL:
-			if (!dir)
-				ret = stmfx_pinconf_set_type(pctl, pin, 0);
-			else
-				ret = stmfx_pinconf_set_type(pctl, pin, 1);
+		case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+			ret = stmfx_pinconf_set_type(pctl, pin, 1);
 			if (ret)
 				return ret;
 			break;
-- 
2.20.1

