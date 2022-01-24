Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32FF49A522
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370659AbiAYAFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1851039AbiAXXbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:31:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DADC07595E;
        Mon, 24 Jan 2022 13:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD10B80CCF;
        Mon, 24 Jan 2022 21:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCEEC340E4;
        Mon, 24 Jan 2022 21:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060109;
        bh=9YkuKF8cpwuIWjIHtOGRypGioyQeoLf8mYpkm6MpMf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o16+2XEVQQ6+NYFbZbNWWzUNP05iATsvkeYuPUr8RQEW6CjHJm8BKZkfvnXs661of
         HVbV72gCo9m0L0cPB2OcdNjEcBmFOYb9TMt+CEMCQsDbWa4DghIavDgxEUnN9TTIbF
         ifkHWYcZGkhyGTfhZ/U334k1v6j43TVoOW0jVGUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 0843/1039] spi: uniphier: Fix a bug that doesnt point to private data correctly
Date:   Mon, 24 Jan 2022 19:43:52 +0100
Message-Id: <20220124184153.627105558@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit 80bb73a9fbcde4ecc55e12f10c73fabbe68a24d1 upstream.

In uniphier_spi_remove(), there is a wrong code to get private data from
the platform device, so the driver can't be removed properly.

The driver should get spi_master from the platform device and retrieve
the private data from it.

Cc: <stable@vger.kernel.org>
Fixes: 5ba155a4d4cc ("spi: add SPI controller driver for UniPhier SoC")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1640148492-32178-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -767,12 +767,13 @@ out_master_put:
 
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
 


