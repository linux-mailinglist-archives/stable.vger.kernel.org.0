Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DC811B3F1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbfLKP1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733284AbfLKP1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8695024654;
        Wed, 11 Dec 2019 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078036;
        bh=WqdzLOw1svIJXrp3BQkqyAvYYG4c3ZCv1Ywl8zqVggc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGVXSZD8tWn0M1iTy/JWEQeXx7HJY7wAQ2Jv3jsID2EAXrNc+vkbzPWbg6/DCiU/t
         pNaQKa9SCE03/96lRCeW1rhjuIZ5zP2lzPLIE3VbKqZsnVlZ60CdGKqNhTnpAGcsgU
         V5XclImLsrNY90MGY/ej7FC1kuM1p0yopoOGmWHU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 30/79] clk: clk-gpio: propagate rate change to parent
Date:   Wed, 11 Dec 2019 10:25:54 -0500
Message-Id: <20191211152643.23056-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

[ Upstream commit fc59462c5ce60da119568fac325c92fc6b7c6175 ]

For an external clock source, which is gated via a GPIO, the
rate change should typically be propagated to the parent clock.

The situation where we are requiring this propagation, is when an
external clock is connected to override an internal clock (which typically
has a fixed rate). The external clock can have a different rate than the
internal one, and may also be variable, thus requiring the rate
propagation.

This rate change wasn't propagated until now, and it's unclear about cases
where this shouldn't be propagated. Thus, it's unclear whether this is
fixing a bug, or extending the current driver behavior. Also, it's unsure
about whether this may break any existing setups; in the case that it does,
a device-tree property may be added to disable this flag.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lkml.kernel.org/r/20191108071718.17985-1-alexandru.ardelean@analog.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-gpio.c b/drivers/clk/clk-gpio.c
index 40af4fbab4d23..af9cc00d2d920 100644
--- a/drivers/clk/clk-gpio.c
+++ b/drivers/clk/clk-gpio.c
@@ -248,7 +248,7 @@ static int gpio_clk_driver_probe(struct platform_device *pdev)
 	else
 		clk = clk_register_gpio_gate(&pdev->dev, node->name,
 				parent_names ?  parent_names[0] : NULL, gpiod,
-				0);
+				CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-- 
2.20.1

