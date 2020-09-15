Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A847B26B3DC
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbgIOXLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbgIOOki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:40:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08569229C4;
        Tue, 15 Sep 2020 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180228;
        bh=eDH+SXdPj8Yzhk9RgPWFeCuKBmhffiaHeIn4srpUobQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz4heB8VBg0RweWgaMZ/SY4l8RfnkSwcWp3ct5Ks2ioZQVuldGLrW6owX/XsWTlio
         ZYxKpRpfmA3OfqQXuIAKDpc51Q1ulHEtMJ0nUWUjHjJJEpLSFQQwufTXp0bmv3GjRV
         IC52/eQuGCOZHWS43+he+GACbtovurFcfsXNM9Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5.8 159/177] Revert "usb: dwc3: meson-g12a: fix shared reset control use"
Date:   Tue, 15 Sep 2020 16:13:50 +0200
Message-Id: <20200915140701.312648721@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amjad Ouled-Ameur <aouledameur@baylibre.com>

commit a6498d51821edf9615b42b968fb419a40197a982 upstream.

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
 drivers/usb/dwc3/dwc3-meson-g12a.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -737,13 +737,13 @@ static int dwc3_meson_g12a_probe(struct
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
@@ -752,7 +752,7 @@ static int dwc3_meson_g12a_probe(struct
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);
 		if (ret)
-			goto err_assert_reset;
+			goto err_disable_clks;
 	}
 
 	/* Get dr_mode */
@@ -765,13 +765,13 @@ static int dwc3_meson_g12a_probe(struct
 
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
@@ -809,9 +809,6 @@ err_phys_exit:
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_exit(priv->phys[i]);
 
-err_assert_reset:
-	reset_control_assert(priv->reset);
-
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);


