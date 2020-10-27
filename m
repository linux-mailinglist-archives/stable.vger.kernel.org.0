Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C2329B914
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802189AbgJ0Pp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798575AbgJ0P24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADC922282;
        Tue, 27 Oct 2020 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812532;
        bh=9JQDxN238P8XgUMNbhtOC1rAp8RS2RnpnB2Lr3wWk8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEPW86AD9bjjbWadIezhGwA6y09MEoE/Y0vjONr/gtdjM5NOjpUZ4cQ7l69Bt8dT4
         4FJ+JHsE+mZjUff1j/TVe3nhm59QsmzGN8urbEtiDVQJ17R6E8eHgNspgVgGMCz81T
         Hg4hjxaobnq5cLnq3sLugebf14c4HOktWLZ2ONAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 211/757] wilc1000: Fix memleak in wilc_bus_probe
Date:   Tue, 27 Oct 2020 14:47:41 +0100
Message-Id: <20201027135500.511636058@linuxfoundation.org>
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
 drivers/net/wireless/microchip/wilc1000/spi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 3f19e3f38a397..a18dac0aa6b67 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
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



