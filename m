Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAE43BB067
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhGDXIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhGDXIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B13861405;
        Sun,  4 Jul 2021 23:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439938;
        bh=FWdpgeLZjTV3yUDS9DmJf5529C3/nxBDlPw9YGo3gao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HptehRZCMDsw8jzg8pFZqrJ+Uikd0ZLHeTDbIG+4MJwvRpUEpTrzi+MIwDYnOk9kC
         jvASibpsjVvCGmngLNghZiRXBDaDjGBur76F46ZSg1GaThdSDq/u5iXdq1NNA70TAN
         KZB5J77BnnI/dXIIWn9hymUz9RONnjF18uRrRnt0F0+PFMGjeZSgqTvbLHeN6/viEd
         BgDkqRsuKcRasbmjoS6NdLta1PQYGoiUha3WjeFv3uQeq4Eu+x128lkBp/2M3xMWNu
         1ABviwADjV98akDN8gpYK2XTZFfF1raV8EEYjund1Y/5ZJkrgt+7ecUwFO7M5Yca0h
         yhMljqN12wJQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zpershuai <zpershuai@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 56/85] spi: meson-spicc: fix memory leak in meson_spicc_probe
Date:   Sun,  4 Jul 2021 19:03:51 -0400
Message-Id: <20210704230420.1488358-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zpershuai <zpershuai@gmail.com>

[ Upstream commit b2d501c13470409ee7613855b17e5e5ec4111e1c ]

when meson_spicc_clk_init returns failed, it should goto the
out_clk label.

Signed-off-by: zpershuai <zpershuai@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/1623562156-21995-1-git-send-email-zpershuai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 51aef2c6e966..b2c4621db34d 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -752,7 +752,7 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	ret = meson_spicc_clk_init(spicc);
 	if (ret) {
 		dev_err(&pdev->dev, "clock registration failed\n");
-		goto out_master;
+		goto out_clk;
 	}
 
 	ret = devm_spi_register_master(&pdev->dev, master);
-- 
2.30.2

