Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983343BB117
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhGDXKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhGDXKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38BA9613F6;
        Sun,  4 Jul 2021 23:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440047;
        bh=svsv6M47GusGxdoHHlZTnG/iyReb7Lr39eIxDeEHyp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPDss1lESr5kxLTMV0G9UxnV9+wLCKogZ1oQ/EKPb4YkpXBRl+qnh2B3O9ZJxqnTW
         Oeg9/1SzrVY5CUAp9OS5Lxps0aH3Nh+JiZSnWQNnBbH948N+42lh0n++zuxhHsUCiO
         H+XAfxkl0BF/OMIDogkdlVCwsI5e/OBQyc4jVqxDm5/jYJGloTe+jwMMVgKtvyKPdg
         P/xXgijSEGgQpdaqzYv5n4qv4ae1WbB8+rN1YZq93EimULSoToqVwvlvv6KUZBaF+s
         PBhT0JvJUpddA8dZWGU2OdbqG1bLKIyOqX9IdXlq9cZBckRCvGJtRqATTRzd4OLQ27
         YTO1sb81ZZs6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zpershuai <zpershuai@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 52/80] spi: meson-spicc: fix a wrong goto jump for avoiding memory leak.
Date:   Sun,  4 Jul 2021 19:05:48 -0400
Message-Id: <20210704230616.1489200-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

