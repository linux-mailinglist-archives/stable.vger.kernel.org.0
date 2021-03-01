Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0A9328E9E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242008AbhCATeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241716AbhCAT2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D56E46503D;
        Mon,  1 Mar 2021 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619097;
        bh=cJP3+Yi3Rou+gcwmssqzE7fHt1Fjtghq1B8c0SMp7eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13xHE60qJDytBGSrtlpqhvIlt/aZyoZU1wKqGcmXsa+/ka9MRNE7oEgJi0AO42Ux0
         hDhhKJ/8iY6vD80krlw+HU9RMzfkxiRhl+cLC8XrweR0BosjuLGzaA200aRojLWISu
         +p4x6ZLgXi1HkBS0MXd3lGuX2C/x6CMf4eU1OZc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/663] spi: imx: Dont print error on -EPROBEDEFER
Date:   Mon,  1 Mar 2021 17:09:08 +0100
Message-Id: <20210301161156.675738228@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit 8346633f2c87713a1852d802305e03555e9a9fce ]

This avoids

[    0.962538] spi_imx 30820000.spi: bitbang start failed with -517

durig driver probe.

Fixes: 8197f489f4c4 ("spi: imx: Fix failure path leak on GPIO request error correctly")
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/0f51ab42e7c7a3452f2f8652794d81584303ea0d.1610987414.git.agx@sigxcpu.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 8df5e973404f0..831a38920fa98 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1713,7 +1713,7 @@ static int spi_imx_probe(struct platform_device *pdev)
 	master->dev.of_node = pdev->dev.of_node;
 	ret = spi_bitbang_start(&spi_imx->bitbang);
 	if (ret) {
-		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
+		dev_err_probe(&pdev->dev, ret, "bitbang start failed\n");
 		goto out_bitbang_start;
 	}
 
-- 
2.27.0



