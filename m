Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00864CEC2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbfFTNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 09:32:39 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:59276 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731770AbfFTNci (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 09:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=OU8h7GYHNznH778rX36bPEvMnuvSQdzNrA5A/oaRaAk=; b=Ec6GFCf2FlA6
        u44e2e7k9+5fyKBC7wetOUC+VUPyOdpTDrSU5Mek3sOBT5Fo5a/BIDIGY6ofFpJSREj5UqiDZtDNS
        ZZvK2c7xqKZnkqzSUuF93HZeS+L4Sg44uiYlDMH9WtJbBJKq1nrkA3YK+3mO3vfkn9TrpIPNTkKF8
        oXE90=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hdxB2-0000kJ-3U; Thu, 20 Jun 2019 13:32:32 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 9ADFB44004A; Thu, 20 Jun 2019 14:32:31 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, <stable@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Applied "regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure" to the regulator tree
In-Reply-To: <1560948159-21926-1-git-send-email-krzk@kernel.org>
X-Patchwork-Hint: ignore
Message-Id: <20190620133231.9ADFB44004A@finisterre.sirena.org.uk>
Date:   Thu, 20 Jun 2019 14:32:31 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup failure

has been applied to the regulator tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-5.2

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 70ca117b02f3b1c8830fe95e4e3dea2937038e11 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 19 Jun 2019 14:42:39 +0200
Subject: [PATCH] regulator: s2mps11: Fix ERR_PTR dereference on GPIO lookup
 failure

If devm_gpiod_get_from_of_node() call returns ERR_PTR, it is assigned
into an array of GPIO descriptors and used later because such error is
not treated as critical thus it is not propagated back to the probe
function.

All code later expects that such GPIO descriptor is either a NULL or
proper value.  This later might lead to dereference of ERR_PTR.

Only devices with S2MPS14 flavor are affected (other do not control
regulators with GPIOs).

Fixes: 1c984942f0a4 ("regulator: s2mps11: Pass descriptor instead of GPIO number")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/s2mps11.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 134c62db36c5..af9bf10b4c33 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -824,6 +824,7 @@ static void s2mps14_pmic_dt_parse_ext_control_gpio(struct platform_device *pdev,
 		if (IS_ERR(gpio[reg])) {
 			dev_err(&pdev->dev, "Failed to get control GPIO for %d/%s\n",
 				reg, rdata[reg].name);
+			gpio[reg] = NULL;
 			continue;
 		}
 		if (gpio[reg])
-- 
2.20.1

