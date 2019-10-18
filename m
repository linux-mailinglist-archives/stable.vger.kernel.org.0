Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E50DD2DD
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387809AbfJRWI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387798AbfJRWI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBB0222C2;
        Fri, 18 Oct 2019 22:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436508;
        bh=HDsv24RpewDnlRB22Fo8IdX8RsS0btuV9oTMySaKPco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcqajXV60nD2r+DiBGM/ZeVpWdf1OiJoWv4xjCWVxm/XernE1nBX+Ioc61k5UPncb
         xlkLRkDkl2fDDWtCi2+5p/1vb7WnVm4POCt96IoI7LvKA6apEh2sU173hhdWWTOmaZ
         6D48VoWi4HO1Y9JjrkvXzfcHTjbUREWqImAFBTsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Remi Pommarel <repk@triplefau.lt>,
        Elie Roudninski <xademax@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 19/56] iio: adc: meson_saradc: Fix memory allocation order
Date:   Fri, 18 Oct 2019 18:07:16 -0400
Message-Id: <20191018220753.10002-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

