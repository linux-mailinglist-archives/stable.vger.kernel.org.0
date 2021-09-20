Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2142C412291
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357925AbhITSQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376598AbhITSNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:13:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 747C263283;
        Mon, 20 Sep 2021 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158466;
        bh=wdwkhDQfnQvYJY1RBZzGawuoDVJPTFDTxaNVaUyKE4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPi7sO8Qg0ZFQifyJVRj1OQ4kryqXaOEQRPfl1cCGR71MTozjEzzLkaRssRKvpuL5
         SSktA+3DVWG6y1AuWMZ75KoNH8W2HNHYwVV1xZoBQSn4tAEKBcWt+xdpBUi9511ff0
         Di4yWLQ5NnFyu+YMKtubd9u0KgEPzNPl43Ii4ZiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/260] ath9k: fix sleeping in atomic context
Date:   Mon, 20 Sep 2021 18:43:08 +0200
Message-Id: <20210920163936.861056931@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 7c48662b9d56666219f526a71ace8c15e6e12f1f ]

The problem is that gpio_free() can sleep and the cfg_soc() can be
called with spinlocks held. One problematic call tree is:

--> ath_reset_internal() takes &sc->sc_pcu_lock spin lock
   --> ath9k_hw_reset()
      --> ath9k_hw_gpio_request_in()
         --> ath9k_hw_gpio_request()
            --> ath9k_hw_gpio_cfg_soc()

Remove gpio_free(), use error message instead, so we should make sure
there is no GPIO conflict.

Also remove ath9k_hw_gpio_free() from ath9k_hw_apply_gpio_override(),
as gpio_mask will never be set for SOC chips.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1628481916-15030-1-git-send-email-miaoqing@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9fd8e64288ff..7e2e22b6bbbc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1622,7 +1622,6 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
-		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
@@ -2730,14 +2729,17 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
 static void ath9k_hw_gpio_cfg_soc(struct ath_hw *ah, u32 gpio, bool out,
 				  const char *label)
 {
+	int err;
+
 	if (ah->caps.gpio_requested & BIT(gpio))
 		return;
 
-	/* may be requested by BSP, free anyway */
-	gpio_free(gpio);
-
-	if (gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label))
+	err = gpio_request_one(gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label);
+	if (err) {
+		ath_err(ath9k_hw_common(ah), "request GPIO%d failed:%d\n",
+			gpio, err);
 		return;
+	}
 
 	ah->caps.gpio_requested |= BIT(gpio);
 }
-- 
2.30.2



