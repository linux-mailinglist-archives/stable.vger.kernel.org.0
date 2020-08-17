Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767C12475D1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgHQT3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbgHQPcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:32:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145AA2389A;
        Mon, 17 Aug 2020 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678347;
        bh=OjKwuGq6o48gdmVKs5O1o02EftD/J2g4ZV6Yxn+WrJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqrmX5DT27em/lxInYQ8jWIpeLULzOEig82UgXc7Wy+Qo2cifnGIFaSmUavKzrPlk
         pDHXQkQSNdZGQesvIfQOkswdn1PDcqpTNBaIThWJHpsTsqHOkiND0KNOSyP4DnwjBJ
         axIE8LB997So7ziSerBPcvfnAIZ21Wl7TLWzWlYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Robertson <dan@dlrobertson.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 285/464] usb: dwc3: meson-g12a: fix shared reset control use
Date:   Mon, 17 Aug 2020 17:13:58 +0200
Message-Id: <20200817143847.406488369@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Robertson <dan@dlrobertson.com>

[ Upstream commit 7a410953d1fb4dbe91ffcfdee9cbbf889d19b0d7 ]

The reset is a shared reset line, but reset_control_reset is still used
and reset_control_deassert is not guaranteed to have been called before
the first reset_control_assert call. When suspending the following
warning may be seen:

WARNING: CPU: 1 PID: 5530 at drivers/reset/core.c:355 reset_control_assert+0x184/0x19c
Hardware name: Hardkernel ODROID-N2 (DT)
[..]
pc : reset_control_assert+0x184/0x19c
lr : dwc3_meson_g12a_suspend+0x68/0x7c
[..]
Call trace:
 reset_control_assert+0x184/0x19c
 dwc3_meson_g12a_suspend+0x68/0x7c
 platform_pm_suspend+0x28/0x54
 __device_suspend+0x590/0xabc
 dpm_suspend+0x104/0x404
 dpm_suspend_start+0x84/0x1bc
 suspend_devices_and_enter+0xc4/0x4fc
 pm_suspend+0x198/0x2d4

Fixes: 6d9fa35a347a87 ("usb: dwc3: meson-g12a: get the reset as shared")
Signed-off-by: Dan Robertson <dan@dlrobertson.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index 1f7f4d88ed9d8..88b75b5a039c9 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -737,13 +737,13 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 		goto err_disable_clks;
 	}
 
-	ret = reset_control_reset(priv->reset);
+	ret = reset_control_deassert(priv->reset);
 	if (ret)
-		goto err_disable_clks;
+		goto err_assert_reset;
 
 	ret = dwc3_meson_g12a_get_phys(priv);
 	if (ret)
-		goto err_disable_clks;
+		goto err_assert_reset;
 
 	ret = priv->drvdata->setup_regmaps(priv, base);
 	if (ret)
@@ -752,7 +752,7 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);
 		if (ret)
-			goto err_disable_clks;
+			goto err_assert_reset;
 	}
 
 	/* Get dr_mode */
@@ -765,13 +765,13 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = priv->drvdata->usb_init(priv);
 	if (ret)
-		goto err_disable_clks;
+		goto err_assert_reset;
 
 	/* Init PHYs */
 	for (i = 0 ; i < PHY_COUNT ; ++i) {
 		ret = phy_init(priv->phys[i]);
 		if (ret)
-			goto err_disable_clks;
+			goto err_assert_reset;
 	}
 
 	/* Set PHY Power */
@@ -809,6 +809,9 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_exit(priv->phys[i]);
 
+err_assert_reset:
+	reset_control_assert(priv->reset);
+
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);
-- 
2.25.1



