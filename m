Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C69A32845F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhCAQeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhCAQ3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4521F64E31;
        Mon,  1 Mar 2021 16:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615781;
        bh=Q5h96U+BDWH4AjP0R27+N24OwmlM9ICB3VQOUIK2axQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5wBTwAk/11ioKv9LdB09sCdRHgPcCTJBNVbVxOdUP5BbSbqEqiMeNZCWVMH4Fc4p
         yRDxABm52ayt3tdzNXM53eBtkE4MINcBhkTFiU7oPvGtZhu8/Rb5E042ddWCfl2l54
         QO5BNpJ6b6fm7SaW9jSgcSH6+GGfC9LPwlbrJCwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 057/134] regulator: axp20x: Fix reference cout leak
Date:   Mon,  1 Mar 2021 17:12:38 +0100
Message-Id: <20210301161016.361981677@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit e78bf6be7edaacb39778f3a89416caddfc6c6d70 ]

Decrements the reference count of device node and its child node.

Fixes: dfe7a1b058bb ("regulator: AXP20x: Add support for regulators subsystem")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210120123313.107640-1-bianpan2016@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index a3ade9e4ef478..86776d45b68e1 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -415,7 +415,7 @@ static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 {
 	struct device_node *np, *regulators;
-	int ret;
+	int ret = 0;
 	u32 dcdcfreq = 0;
 
 	np = of_node_get(pdev->dev.parent->of_node);
@@ -430,13 +430,12 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 		ret = axp20x_set_dcdc_freq(pdev, dcdcfreq);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Error setting dcdc frequency: %d\n", ret);
-			return ret;
 		}
-
 		of_node_put(regulators);
 	}
 
-	return 0;
+	of_node_put(np);
+	return ret;
 }
 
 static int axp20x_set_dcdc_workmode(struct regulator_dev *rdev, int id, u32 workmode)
-- 
2.27.0



