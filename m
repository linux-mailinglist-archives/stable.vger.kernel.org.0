Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAA329B7FC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798626AbgJ0P3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798570AbgJ0P24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E0920780;
        Tue, 27 Oct 2020 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812529;
        bh=3FrghEAZdJTShkk1uslzcRCPiDPwxGtwQjzbTjEI46I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gn2iesS9pG8HN98Llib1rcIIO1aqhs2uvv+0Z7tQrKEXeqiFntK9a/qdDfoAEq53L
         8JyiH5ZTye9hacX2/YeBnnF+jQcDSWgR3yNP8gkg6Q0NaLDW8/xXuySQW3hFXUiDNb
         7cdOEJKKiDzgnUkqBtpxm28iMFkJQiFmefe4fP/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 210/757] wilc1000: Fix memleak in wilc_sdio_probe
Date:   Tue, 27 Oct 2020 14:47:40 +0100
Message-Id: <20201027135500.464238865@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 8d95ab34b21ee0f870a9185b6457e8f6eb54914c ]

When devm_clk_get() returns -EPROBE_DEFER, sdio_priv
should be freed just like when wilc_cfg80211_init()
fails.

Fixes: 8692b047e86cf ("staging: wilc1000: look for rtc_clk clock")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200820054819.23365-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 3ece7b0b03929..351ff909ab1c7 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -149,9 +149,10 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	wilc->dev = &func->dev;
 
 	wilc->rtc_clk = devm_clk_get(&func->card->dev, "rtc");
-	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER)
+	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
+		kfree(sdio_priv);
 		return -EPROBE_DEFER;
-	else if (!IS_ERR(wilc->rtc_clk))
+	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	dev_info(&func->dev, "Driver Initializing success\n");
-- 
2.25.1



