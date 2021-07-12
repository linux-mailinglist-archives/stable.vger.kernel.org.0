Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6C3C4C94
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbhGLHGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243121AbhGLHEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9D1261167;
        Mon, 12 Jul 2021 07:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073305;
        bh=svsv6M47GusGxdoHHlZTnG/iyReb7Lr39eIxDeEHyp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2e1uTxESmpiL9H/yPNzYwB/SoSXa6eWKtRtSIU3R1F18j7dn6ADDyW6wxhVtjBUS3
         PDG+NH9zseDLw5QZ+rMjVMpoAQXHfCn+ehw9sFmQ7yS7mYCbAw+hzrvcqD8m5l4tLJ
         MfWetsgR/CfsJ3+qyNJqu8hrnK77JWXFQgjstJsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zpershuai <zpershuai@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 169/700] spi: meson-spicc: fix a wrong goto jump for avoiding memory leak.
Date:   Mon, 12 Jul 2021 08:04:12 +0200
Message-Id: <20210712060949.885001620@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zpershuai <zpershuai@gmail.com>

[ Upstream commit 95730d5eb73170a6d225a9998c478be273598634 ]

In meson_spifc_probe function, when enable the device pclk clock is
error, it should use clk_disable_unprepare to release the core clock.

Signed-off-by: zpershuai <zpershuai@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/1623562172-22056-1-git-send-email-zpershuai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index ecba6b4a5d85..51aef2c6e966 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -725,7 +725,7 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(spicc->pclk);
 	if (ret) {
 		dev_err(&pdev->dev, "pclk clock enable failed\n");
-		goto out_master;
+		goto out_core_clk;
 	}
 
 	device_reset_optional(&pdev->dev);
@@ -764,9 +764,11 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	return 0;
 
 out_clk:
-	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
 
+out_core_clk:
+	clk_disable_unprepare(spicc->core);
+
 out_master:
 	spi_master_put(master);
 
-- 
2.30.2



