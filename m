Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5214AA8DF
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 13:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379874AbiBEM5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 07:57:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiBEM5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 07:57:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A41B80B8A
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29966C340E8;
        Sat,  5 Feb 2022 12:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644065868;
        bh=Mbvh9f753zDg93GUmAPOXWDZZMcuAUWfwaMnFk7+oiw=;
        h=Subject:To:Cc:From:Date:From;
        b=tbuW4B9GSGQoUnZNkeHPouIfk866tfIYLwJPYr/O0qlpBU5KuCWynLorbSFa/mYsG
         ccqJKIawnEWqg3Ad4kJilufyHoe1e43xuKXRvRxjwQSSsts4ZDe+k0zPGxMP2q8FU4
         GiEt78AVCf3RpYx9hCxleH5yuuhERdoVA5RgNQ2w=
Subject: FAILED: patch "[PATCH] spi: uniphier: Fix a bug that doesn't point to private data" failed to apply to 5.10-stable tree
To:     hayashi.kunihiko@socionext.com, broonie@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 13:57:38 +0100
Message-ID: <1644065858236151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23e3404de1aecc62c14ac96d4b63403c3e0f52d5 Mon Sep 17 00:00:00 2001
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
 

