Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C5593ECB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbiHOUwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347071AbiHOUv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:51:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B5DBC132;
        Mon, 15 Aug 2022 12:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 085ABB8111D;
        Mon, 15 Aug 2022 19:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C826C433C1;
        Mon, 15 Aug 2022 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590598;
        bh=z0WCtzWyS+jOwGpNrrIHrFVwGek7uF+4CfKOIqfi9QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/Xz8RMlsF7KR9uww9g+TC837/hZWO6ZPMtK8aZw4puL8g95Ms+5mAWiu1Jam/eJb
         OB27Q1KoVgq+4ajUIWbZZod3zO3dTWOIxQgad5QbGP9cHjVxDxDTT6ryaG/VSpn24G
         U+bVt8iO3+mRWLqxOf0cEpGsgDi84hXxIE7rBuAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0311/1095] wifi: wilc1000: use correct sequence of RESET for chip Power-UP/Down
Date:   Mon, 15 Aug 2022 19:55:10 +0200
Message-Id: <20220815180442.678122503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

[ Upstream commit fcf690b0b47494df51d214db5c5a714a400b0257 ]

For power-up sequence, WILC expects RESET set to high 5ms after making
chip_en(enable) so corrected chip power-up sequence by making RESET high.
For Power-Down sequence, the correct sequence make RESET and CHIP_EN low
without any extra delay.

Fixes: ec031ac4792c ("wilc1000: Add reset/enable GPIO support to SPI driver")
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220524120606.9675-1-ajay.kathat@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 18420e954402..2ae8dd3411ac 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -191,11 +191,11 @@ static void wilc_wlan_power(struct wilc *wilc, bool on)
 		/* assert ENABLE: */
 		gpiod_set_value(gpios->enable, 1);
 		mdelay(5);
-		/* deassert RESET: */
-		gpiod_set_value(gpios->reset, 0);
-	} else {
 		/* assert RESET: */
 		gpiod_set_value(gpios->reset, 1);
+	} else {
+		/* deassert RESET: */
+		gpiod_set_value(gpios->reset, 0);
 		/* deassert ENABLE: */
 		gpiod_set_value(gpios->enable, 0);
 	}
-- 
2.35.1



