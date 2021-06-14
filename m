Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB113A62D2
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhFNLFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhFNLCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCC0613FF;
        Mon, 14 Jun 2021 10:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667441;
        bh=nzAyjLyV03WC2pA/xt/1Q15MP5i9n0ZYniC4TeU6imA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRsX3YPUHg+yUDthfXZH6aW6sUB7IHLeYqEJTH2PDdLBZ5EU8SyK+obxOZYEUq/RG
         9gxRs0vUUyfvWZK6280NqccHbVOPjraMGPChUf3RoOVwywh8k2sx/yNqazEZG0bbc5
         WL+Fnip1Ti3gxucX5TqARmrbJYwhu3BWyimLclFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 5.10 071/131] usb: dwc3: meson-g12a: Disable the regulator in the error handling path of the probe
Date:   Mon, 14 Jun 2021 12:27:12 +0200
Message-Id: <20210614102655.451106856@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 1d0d3d818eafe1963ec1eaf302175cd14938188e upstream.

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
 drivers/usb/dwc3/dwc3-meson-g12a.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -775,13 +775,13 @@ static int dwc3_meson_g12a_probe(struct
 
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
@@ -819,6 +819,10 @@ err_phys_exit:
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_exit(priv->phys[i]);
 
+err_disable_regulator:
+	if (priv->vbus)
+		regulator_disable(priv->vbus);
+
 err_disable_clks:
 	clk_bulk_disable_unprepare(priv->drvdata->num_clks,
 				   priv->drvdata->clks);


