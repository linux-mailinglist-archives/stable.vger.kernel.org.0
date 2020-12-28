Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495712E3EB8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504171AbgL1Ob6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504489AbgL1Oba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B27920791;
        Mon, 28 Dec 2020 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165849;
        bh=xvED9HZ6Hzg2Z33M0isYotNPsw5UsYBK1xpu7VlUT9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ2nrFJeDoxkHaL0ioenog07WCYh9h7xEIgFI9E44sJgDkKnlfQ3Rs2TjFbQvlx4w
         akAwSB1zMtIxF35XcYDjgyNiqueAFkUgdOGz120pnM0zuaVRieq1HvGrNAxPxLO8g4
         zi3fCQWLDeaUJevnXNefwMNxLyfBfHahzUvoDlHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Chuanhong Guo <gch981213@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 645/717] spi: ar934x: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:43 +0100
Message-Id: <20201228125051.838378190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 236924ee531d6251c8d10e9177b7742a60534ed5 upstream.

If the call to devm_spi_register_controller() fails on probe of the
Qualcomm Atheros AR934x/QCA95xx SPI driver, the spi_controller struct is
erroneously not freed.  Fix by switching over to the new
devm_spi_alloc_master() helper.

Moreover, the controller's clock is enabled on probe but not disabled if
any of the subsequent probe steps fail.

Finally, there's an ordering issue in ar934x_spi_remove() wherein the
clock is disabled even though the controller is not yet unregistered.
It is unregistered after ar934x_spi_remove() by the devres framework.
As long as it is not unregistered, SPI transfers may still be ongoing
and disabling the clock may break them.  It is not possible to use
devm_spi_register_controller() in this case, so move to the non-devm
variant.

All of these bugs have existed since the driver was first introduced,
so it seems fair to fix them together in a single commit.

Fixes: 047980c582af ("spi: add driver for ar934x spi controller")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.7+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.7+
Cc: Chuanhong Guo <gch981213@gmail.com>
Link: https://lore.kernel.org/r/1d58367d74d55741e0c2730a51a2b65012c8ab33.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-ar934x.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-ar934x.c
+++ b/drivers/spi/spi-ar934x.c
@@ -176,10 +176,11 @@ static int ar934x_spi_probe(struct platf
 	if (ret)
 		return ret;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*sp));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*sp));
 	if (!ctlr) {
 		dev_info(&pdev->dev, "failed to allocate spi controller\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_clk_disable;
 	}
 
 	/* disable flash mapping and expose spi controller registers */
@@ -202,7 +203,13 @@ static int ar934x_spi_probe(struct platf
 	sp->clk_freq = clk_get_rate(clk);
 	sp->ctlr = ctlr;
 
-	return devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
+	if (!ret)
+		return 0;
+
+err_clk_disable:
+	clk_disable_unprepare(clk);
+	return ret;
 }
 
 static int ar934x_spi_remove(struct platform_device *pdev)
@@ -213,6 +220,7 @@ static int ar934x_spi_remove(struct plat
 	ctlr = dev_get_drvdata(&pdev->dev);
 	sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
 	clk_disable_unprepare(sp->clk);
 
 	return 0;


