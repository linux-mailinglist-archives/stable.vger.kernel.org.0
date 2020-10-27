Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E94F29B0E3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895579AbgJ0OYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368164AbgJ0OYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D07820773;
        Tue, 27 Oct 2020 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808689;
        bh=hR6U4WnyyHaew0oR5qjCvxwyrsc/wpr+fungtJa7tUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCAjaFJYrAfKCGyrrJRM2XHlmLpKtv2DZvpacrQN9gG/7uYCTTZQCy3k7CLNNQCCG
         DQz0zosC7e+y4zBbHfTpy7lM6jfAsyKUXBUM2qPjyu3otO4glUK+iU7up+ztgsdgcw
         watjiUSrzOiQq6a2ytksM7REWiVIPF9hzcWtyn4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/264] Input: sun4i-ps2 - fix handling of platform_get_irq() error
Date:   Tue, 27 Oct 2020 14:54:05 +0100
Message-Id: <20201027135439.438998576@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit cafb3abea6136e59ea534004e5773361e196bb94 ]

platform_get_irq() returns -ERRNO on error.  In such case comparison
to 0 would pass the check.

Fixes: e443631d20f5 ("Input: serio - add support for Alwinner A10/A20 PS/2 controller")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20200828145744.3636-4-krzk@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/sun4i-ps2.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/input/serio/sun4i-ps2.c b/drivers/input/serio/sun4i-ps2.c
index 04b96fe393397..46512b4d686a8 100644
--- a/drivers/input/serio/sun4i-ps2.c
+++ b/drivers/input/serio/sun4i-ps2.c
@@ -210,7 +210,6 @@ static int sun4i_ps2_probe(struct platform_device *pdev)
 	struct sun4i_ps2data *drvdata;
 	struct serio *serio;
 	struct device *dev = &pdev->dev;
-	unsigned int irq;
 	int error;
 
 	drvdata = kzalloc(sizeof(struct sun4i_ps2data), GFP_KERNEL);
@@ -263,14 +262,12 @@ static int sun4i_ps2_probe(struct platform_device *pdev)
 	writel(0, drvdata->reg_base + PS2_REG_GCTL);
 
 	/* Get IRQ for the device */
-	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
-		dev_err(dev, "no IRQ found\n");
-		error = -ENXIO;
+	drvdata->irq = platform_get_irq(pdev, 0);
+	if (drvdata->irq < 0) {
+		error = drvdata->irq;
 		goto err_disable_clk;
 	}
 
-	drvdata->irq = irq;
 	drvdata->serio = serio;
 	drvdata->dev = dev;
 
-- 
2.25.1



