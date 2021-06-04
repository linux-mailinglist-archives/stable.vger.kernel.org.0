Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412B839B762
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 12:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFDLBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhFDLBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C0956141A;
        Fri,  4 Jun 2021 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622804375;
        bh=7JFZGqDgohw0bbWPYUpCoh9VbvdVlfJxui3wRWhmgMU=;
        h=Subject:To:From:Date:From;
        b=SaV6uAoQuCM7sWMzMpkt1F0xGY3qeaVgX3XmNvtbNCmz6zOoq85XhgSiwpOGhXtCQ
         uuWDeHZzFsChLuROPZTyoN4Dw/RBAiyWZGiAxjiYcmOlISlkIENWPC94pw0+ShKo+j
         wLy3I5uTHyilTITdfbz69z5/8DSjCQPGunRKxZgI=
Subject: patch "usb: dwc3: meson-g12a: Disable the regulator in the error handling" added to usb-linus
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        martin.blumenstingl@googlemail.com, narmstrong@baylibre.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 12:59:33 +0200
Message-ID: <162280437315232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: meson-g12a: Disable the regulator in the error handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1d0d3d818eafe1963ec1eaf302175cd14938188e Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Fri, 21 May 2021 18:55:50 +0200
Subject: usb: dwc3: meson-g12a: Disable the regulator in the error handling
 path of the probe

If an error occurs after a successful 'regulator_enable()' call,
'regulator_disable()' must be called.

Fix the error handling path of the probe accordingly.

The remove function doesn't need to be fixed, because the
'regulator_disable()' call is already hidden in 'dwc3_meson_g12a_suspend()'
which is called via 'pm_runtime_set_suspended()' in the remove function.

Fixes: c99993376f72 ("usb: dwc3: Add Amlogic G12A DWC3 glue")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/79df054046224bbb0716a8c5c2082650290eec86.1621616013.git.christophe.jaillet@wanadoo.fr
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index bdf1f98dfad8..804957525130 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -772,13 +772,13 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = priv->drvdata->usb_init(priv);
 	if (ret)
-		goto err_disable_clks;
+		goto err_disable_regulator;
 
 	/* Init PHYs */
 	for (i = 0 ; i < PHY_COUNT ; ++i) {
 		ret = phy_init(priv->phys[i]);
 		if (ret)
-			goto err_disable_clks;
+			goto err_disable_regulator;
 	}
 
 	/* Set PHY Power */
@@ -816,6 +816,10 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_exit(priv->phys[i]);
 
+err_disable_regulator:
+	if (priv->vbus)
+		regulator_disable(priv->vbus);
+
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);
-- 
2.31.1


