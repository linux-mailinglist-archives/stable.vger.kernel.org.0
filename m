Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3720C4972E6
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiAWQMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 11:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238485AbiAWQMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 11:12:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7574C061744
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 08:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8660160F28
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 16:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76FC340E4;
        Sun, 23 Jan 2022 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642954350;
        bh=90fyWAlo/zRkaazI2j1owjHCMsRJCvFfUkGLIGUoe7I=;
        h=Subject:To:Cc:From:Date:From;
        b=wrRd5Sbr99fwVofhrkRYXKgte8WHOfJPVCYQ3kcAvOuNBjeKVimyLENATNMeDL5f3
         swR6X7MiF64F8Y0xF73UxJ0GMQWmaC2xQqRrFnele/7fQzs1LvwhV/hgxmb1zLf8f7
         ttlI3xWZ8kR4+AMV2ufYwxgpeFEbcV9WgzQ7ia5Q=
Subject: FAILED: patch "[PATCH] spi: uniphier: Fix a bug that doesn't point to private data" failed to apply to 4.19-stable tree
To:     hayashi.kunihiko@socionext.com, broonie@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 17:12:27 +0100
Message-ID: <1642954347172212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80bb73a9fbcde4ecc55e12f10c73fabbe68a24d1 Mon Sep 17 00:00:00 2001
From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Wed, 22 Dec 2021 13:48:12 +0900
Subject: [PATCH] spi: uniphier: Fix a bug that doesn't point to private data
 correctly

In uniphier_spi_remove(), there is a wrong code to get private data from
the platform device, so the driver can't be removed properly.

The driver should get spi_master from the platform device and retrieve
the private data from it.

Cc: <stable@vger.kernel.org>
Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-uniphier.c b/drivers/spi/spi-uniphier.c
index 8900e51e1a1c..342ee8d2c476 100644
--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -767,12 +767,13 @@ static int uniphier_spi_probe(struct platform_device *pdev)
 
 static int uniphier_spi_remove(struct platform_device *pdev)
 {
-	struct uniphier_spi_priv *priv = platform_get_drvdata(pdev);
+	struct spi_master *master = platform_get_drvdata(pdev);
+	struct uniphier_spi_priv *priv = spi_master_get_devdata(master);
 
-	if (priv->master->dma_tx)
-		dma_release_channel(priv->master->dma_tx);
-	if (priv->master->dma_rx)
-		dma_release_channel(priv->master->dma_rx);
+	if (master->dma_tx)
+		dma_release_channel(master->dma_tx);
+	if (master->dma_rx)
+		dma_release_channel(master->dma_rx);
 
 	clk_disable_unprepare(priv->clk);
 

