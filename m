Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC20429B40A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752844AbgJ0O5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752836AbgJ0O5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B3AC204FD;
        Tue, 27 Oct 2020 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810643;
        bh=JO79Fcv24VlHd/8g/HWugfjf7MkJ5rRRKpSmeS5SWGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHwYCXHW7wcBu5DONo+pNAKiBn4Q4jkjjU3gWE6MlxZZ5RxQ3OftoW5X29l3hTJLG
         DKAdhhk4ARMbxse7QD1KLqfyrcB/JmsskMFjl5s5zpM44VJppmcPDMSygF32n0vfTl
         7FcoYgYpSspgsdr8ySWL9gOy+Q8QvofWubt9BVbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 181/633] wilc1000: Fix memleak in wilc_bus_probe
Date:   Tue, 27 Oct 2020 14:48:44 +0100
Message-Id: <20201027135531.180106980@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 9a19a939abfa7d949f584a7ad872e683473fdc14 ]

When devm_clk_get() returns -EPROBE_DEFER, spi_priv
should be freed just like when wilc_cfg80211_init()
fails.

Fixes: 854d66df74aed ("staging: wilc1000: look for rtc_clk clock in spi mode")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200820055256.24333-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/spi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/spi.c b/drivers/staging/wilc1000/spi.c
index 3f19e3f38a397..a18dac0aa6b67 100644
--- a/drivers/staging/wilc1000/spi.c
+++ b/drivers/staging/wilc1000/spi.c
@@ -112,9 +112,10 @@ static int wilc_bus_probe(struct spi_device *spi)
 	wilc->dev_irq_num = spi->irq;
 
 	wilc->rtc_clk = devm_clk_get(&spi->dev, "rtc_clk");
-	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER)
+	if (PTR_ERR_OR_ZERO(wilc->rtc_clk) == -EPROBE_DEFER) {
+		kfree(spi_priv);
 		return -EPROBE_DEFER;
-	else if (!IS_ERR(wilc->rtc_clk))
+	} else if (!IS_ERR(wilc->rtc_clk))
 		clk_prepare_enable(wilc->rtc_clk);
 
 	return 0;
-- 
2.25.1



