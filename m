Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301D92E3EBA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504031AbgL1Ob7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504581AbgL1Obl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F1C206D4;
        Mon, 28 Dec 2020 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165860;
        bh=Sdv2LMeck2Xq4M1B8LUBYvuodFaoib3fxPBjjaMSsaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MoFEAkIKmqGR8G0iSmn4Gyfusw8o4YEAxDe/43ioi6xMqfVSX2yovoMOvS/oRCtCZ
         W1BoCizERnArzdd8l1r6jdqXYfhiQ8h2qzqrzVMDEM3ezmqXjcakL+OE7wy7+iUTFZ
         e8OfMn+8l844Q2CU5oaBOT7ZyV0axWjHFKD+cN6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mason Yang <masonccyang@mxic.com.tw>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 649/717] spi: mxic: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:47 +0100
Message-Id: <20201228125052.042384990@linuxfoundation.org>
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

commit cc53711b2191cf3b3210283ae89bf0abb98c70a3 upstream.

If the calls to devm_clk_get() or devm_ioremap_resource() fail on probe
of the Macronix SPI driver, the spi_master struct is erroneously not freed.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.0+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.0+
Cc: Mason Yang <masonccyang@mxic.com.tw>
Link: https://lore.kernel.org/r/4fa6857806e7e75741c05d057ac9df3564460114.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mxic.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -529,7 +529,7 @@ static int mxic_spi_probe(struct platfor
 	struct mxic_spi *mxic;
 	int ret;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct mxic_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct mxic_spi));
 	if (!master)
 		return -ENOMEM;
 
@@ -574,15 +574,9 @@ static int mxic_spi_probe(struct platfor
 	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_master failed\n");
-		goto err_put_master;
+		pm_runtime_disable(&pdev->dev);
 	}
 
-	return 0;
-
-err_put_master:
-	spi_master_put(master);
-	pm_runtime_disable(&pdev->dev);
-
 	return ret;
 }
 


