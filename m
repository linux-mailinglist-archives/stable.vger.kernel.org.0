Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3025DC2D
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgIDOpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730021AbgIDOpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 10:45:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84CC4206F2;
        Fri,  4 Sep 2020 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599230733;
        bh=USIbP/3EYFe8LjTqejgvz1e2EW6/gfRsqgLgrs3ove4=;
        h=Subject:To:From:Date:From;
        b=1ifvO2EX/3qXXSNW8pe/eTmGoGYqMEYT1Rja+8Akde0YiYsvTT8I29j55Vjfji1Cc
         dniR7CN7MWaieGD9NUCuVJJ/AcW6O/EZhgCpBj04V7AJnxWxlF8lMiINGLlO7zfC1F
         +3d/S4w2h3tDOewWOj0iEKSbWlRdYU9un7fmCHks=
Subject: patch "Revert "usb: dwc3: meson-g12a: fix shared reset control use"" added to usb-linus
To:     aouledameur@baylibre.com, gregkh@linuxfoundation.org,
        jbrunet@baylibre.com, narmstrong@baylibre.com,
        p.zabel@pengutronix.de, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 16:45:48 +0200
Message-ID: <1599230748185110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: dwc3: meson-g12a: fix shared reset control use"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a6498d51821edf9615b42b968fb419a40197a982 Mon Sep 17 00:00:00 2001
From: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Date: Thu, 27 Aug 2020 16:48:10 +0200
Subject: Revert "usb: dwc3: meson-g12a: fix shared reset control use"

This reverts commit 7a410953d1fb4dbe91ffcfdee9cbbf889d19b0d7.

This commit breaks USB on meson-gxl-s905x-libretech-cc. Reverting
the change solves the issue.

In fact, according to the reset framework code, consumers must not use
reset_control_(de)assert() on shared reset lines when reset_control_reset
has been used, and vice-versa.

Moreover, with this commit, usb is not guaranted to be reset since the
reset is likely to be initially deasserted.

Reverting the commit will bring back the suspend warning mentioned in the
commit description. Nevertheless, a warning is much less critical than
breaking dwc3-meson-g12a USB completely. We will address the warning
issue in another way as a 2nd step.

Fixes: 7a410953d1fb ("usb: dwc3: meson-g12a: fix shared reset control use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Amjad Ouled-Ameur <aouledameur@baylibre.com>
Reported-by: Jerome Brunet <jbrunet@baylibre.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20200827144810.26657-1-aouledameur@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index 88b75b5a039c..1f7f4d88ed9d 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -737,13 +737,13 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 		goto err_disable_clks;
 	}
 
-	ret = reset_control_deassert(priv->reset);
+	ret = reset_control_reset(priv->reset);
 	if (ret)
-		goto err_assert_reset;
+		goto err_disable_clks;
 
 	ret = dwc3_meson_g12a_get_phys(priv);
 	if (ret)
-		goto err_assert_reset;
+		goto err_disable_clks;
 
 	ret = priv->drvdata->setup_regmaps(priv, base);
 	if (ret)
@@ -752,7 +752,7 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);
 		if (ret)
-			goto err_assert_reset;
+			goto err_disable_clks;
 	}
 
 	/* Get dr_mode */
@@ -765,13 +765,13 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = priv->drvdata->usb_init(priv);
 	if (ret)
-		goto err_assert_reset;
+		goto err_disable_clks;
 
 	/* Init PHYs */
 	for (i = 0 ; i < PHY_COUNT ; ++i) {
 		ret = phy_init(priv->phys[i]);
 		if (ret)
-			goto err_assert_reset;
+			goto err_disable_clks;
 	}
 
 	/* Set PHY Power */
@@ -809,9 +809,6 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_exit(priv->phys[i]);
 
-err_assert_reset:
-	reset_control_assert(priv->reset);
-
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);
-- 
2.28.0


