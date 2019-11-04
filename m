Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85AEEFEA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbfKDVwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbfKDVwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 360D32184C;
        Mon,  4 Nov 2019 21:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904372;
        bh=HDsv24RpewDnlRB22Fo8IdX8RsS0btuV9oTMySaKPco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8E3SYfPVjihTY8uydQQi4cBsxxcePgZv9KYQDbTbcAB7Y4rkSioQHIa1Akf2N33v
         Kmsoonw3TNlMbslACtPGahFKGeRwiKrnUm5azXInt+2LGEOHqD4LG2QwyG7thKKokd
         NxzhFPKbgCABJOT0mfJiXYx1BcJ4xgketv1QAsDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elie Roudninski <xademax@gmail.com>,
        Remi Pommarel <repk@triplefau.lt>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/95] iio: adc: meson_saradc: Fix memory allocation order
Date:   Mon,  4 Nov 2019 22:44:22 +0100
Message-Id: <20191104212054.266245809@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit de10ac47597e7a3596b27631d0d5ce5f48d2c099 ]

meson_saradc's irq handler uses priv->regmap so make sure that it is
allocated before the irq get enabled.

This also fixes crash when CONFIG_DEBUG_SHIRQ is enabled, as device
managed resources are freed in the inverted order they had been
allocated, priv->regmap was freed before the spurious fake irq that
CONFIG_DEBUG_SHIRQ adds called the handler.

Fixes: 3af109131b7eb8 ("iio: adc: meson-saradc: switch from polling to interrupt mode")
Reported-by: Elie Roudninski <xademax@gmail.com>
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: Elie ROUDNINSKI <xademax@gmail.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/meson_saradc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/meson_saradc.c b/drivers/iio/adc/meson_saradc.c
index 2515badf8b280..9b2121f249263 100644
--- a/drivers/iio/adc/meson_saradc.c
+++ b/drivers/iio/adc/meson_saradc.c
@@ -976,6 +976,11 @@ static int meson_sar_adc_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
+	priv->regmap = devm_regmap_init_mmio(&pdev->dev, base,
+					     priv->data->regmap_config);
+	if (IS_ERR(priv->regmap))
+		return PTR_ERR(priv->regmap);
+
 	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
 	if (!irq)
 		return -EINVAL;
@@ -985,11 +990,6 @@ static int meson_sar_adc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	priv->regmap = devm_regmap_init_mmio(&pdev->dev, base,
-					     priv->data->regmap_config);
-	if (IS_ERR(priv->regmap))
-		return PTR_ERR(priv->regmap);
-
 	priv->clkin = devm_clk_get(&pdev->dev, "clkin");
 	if (IS_ERR(priv->clkin)) {
 		dev_err(&pdev->dev, "failed to get clkin\n");
-- 
2.20.1



