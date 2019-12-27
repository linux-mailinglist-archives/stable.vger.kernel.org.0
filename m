Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6712B671
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfL0Rms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727982AbfL0Rmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD91F20740;
        Fri, 27 Dec 2019 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468567;
        bh=ASl7vaeg61VjfA/PHCSfSIa3DQSAHBoCvHj2gUv6USs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lzIH1srJui4lbb6Qb/PGnV/6MiHQMHsckVkV3juZHkt7bz482zmyc26bhRjO/ulyV
         ieFaf9vnUD5dP7qO2175sAGA+5kcMqfoIvEvIVapq98xPOKpkStvjxIq3hAGRAdcE6
         dMYksksVZioWNq9/moWSTgxQTTZtTCh1/yU4WnJg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 092/187] pinctrl: pinmux: fix a possible null pointer in pinmux_can_be_used_for_gpio
Date:   Fri, 27 Dec 2019 12:39:20 -0500
Message-Id: <20191227174055.4923-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

[ Upstream commit 6ba2fd391ac58c1a26874f10c3054a1ea4aca2d0 ]

This commit adds a check on ops pointer to avoid a kernel panic when
ops->strict is used. Indeed, on some pinctrl driver (at least for
pinctrl-stmfx) the pinmux ops is not implemented. Let's assume than gpio
can be used in this case.

Fixes: 472a61e777fe ("pinctrl/gpio: Take MUX usage into account")
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Link: https://lore.kernel.org/r/20191204144106.10876-1-alexandre.torgue@st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index e914f6efd39e..9503ddf2edc7 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -85,7 +85,7 @@ bool pinmux_can_be_used_for_gpio(struct pinctrl_dev *pctldev, unsigned pin)
 	const struct pinmux_ops *ops = pctldev->desc->pmxops;
 
 	/* Can't inspect pin, assume it can be used */
-	if (!desc)
+	if (!desc || !ops)
 		return true;
 
 	if (ops->strict && desc->mux_usecount)
-- 
2.20.1

