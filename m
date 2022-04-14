Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547625012E8
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243224AbiDNNwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245312AbiDNNnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:43:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D6822B1A;
        Thu, 14 Apr 2022 06:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1B95CE29B0;
        Thu, 14 Apr 2022 13:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AD6C385A1;
        Thu, 14 Apr 2022 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943568;
        bh=fo5jDvJBWmOniiLzpnFzuE6QhoHAzd6X7kzz8Acf3a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkZM5VXHL+3avDM1NREIpMG9IxyJU9n444ELZ82sP0yJBISi6YIjFIRuK9u1WcQeM
         TGAr2eEQIt2PVX2B9CJrcxS/ZvYwW8+70uEvfvRVatvhfaqN8H5RUjQjiSkvddIYj9
         cKhKhA5UN6DhbQUDzRxwCeO+qSoAPvl1j1Zg6KG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/475] power: supply: wm8350-power: Handle error for wm8350_register_irq
Date:   Thu, 14 Apr 2022 15:09:47 +0200
Message-Id: <20220414110900.782356315@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b0b14b5ba11bec56fad344a4a0b2e16449cc8b94 ]

As the potential failure of the wm8350_register_irq(),
it should be better to check it and return error if fails.
Also, use 'free_' in order to avoid same code.

Fixes: 14431aa0c5a4 ("power_supply: Add support for WM8350 PMU")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/wm8350_power.c | 96 ++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 14 deletions(-)

diff --git a/drivers/power/supply/wm8350_power.c b/drivers/power/supply/wm8350_power.c
index 26923af574f4..0762ab13fa56 100644
--- a/drivers/power/supply/wm8350_power.c
+++ b/drivers/power/supply/wm8350_power.c
@@ -408,44 +408,112 @@ static const struct power_supply_desc wm8350_usb_desc = {
  *		Initialisation
  *********************************************************************/
 
-static void wm8350_init_charger(struct wm8350 *wm8350)
+static int wm8350_init_charger(struct wm8350 *wm8350)
 {
+	int ret;
+
 	/* register our interest in charger events */
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
 			    wm8350_charger_handler, 0, "Battery hot", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
+	if (ret)
+		goto err;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
 			    wm8350_charger_handler, 0, "Battery cold", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
+	if (ret)
+		goto free_chg_bat_hot;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
 			    wm8350_charger_handler, 0, "Battery fail", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
+	if (ret)
+		goto free_chg_bat_cold;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
 			    wm8350_charger_handler, 0,
 			    "Charger timeout", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
+	if (ret)
+		goto free_chg_bat_fail;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
 			    wm8350_charger_handler, 0,
 			    "Charge end", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
+	if (ret)
+		goto free_chg_to;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
 			    wm8350_charger_handler, 0,
 			    "Charge start", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
+	if (ret)
+		goto free_chg_end;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
 			    wm8350_charger_handler, 0,
 			    "Fast charge ready", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
+	if (ret)
+		goto free_chg_start;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.9V", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
+	if (ret)
+		goto free_chg_fast_rdy;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.1V", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
+	if (ret)
+		goto free_chg_vbatt_lt_3p9;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
 			    wm8350_charger_handler, 0,
 			    "Battery <2.85V", wm8350);
+	if (ret)
+		goto free_chg_vbatt_lt_3p1;
 
 	/* and supply change events */
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
 			    wm8350_charger_handler, 0, "USB", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
+	if (ret)
+		goto free_chg_vbatt_lt_2p85;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
 			    wm8350_charger_handler, 0, "Wall", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
+	if (ret)
+		goto free_ext_usb_fb;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
 			    wm8350_charger_handler, 0, "Battery", wm8350);
+	if (ret)
+		goto free_ext_wall_fb;
+
+	return 0;
+
+free_ext_wall_fb:
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB, wm8350);
+free_ext_usb_fb:
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB, wm8350);
+free_chg_vbatt_lt_2p85:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
+free_chg_vbatt_lt_3p1:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
+free_chg_vbatt_lt_3p9:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
+free_chg_fast_rdy:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY, wm8350);
+free_chg_start:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+free_chg_end:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
+free_chg_to:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
+free_chg_bat_fail:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL, wm8350);
+free_chg_bat_cold:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD, wm8350);
+free_chg_bat_hot:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT, wm8350);
+err:
+	return ret;
 }
 
 static void free_charger_irq(struct wm8350 *wm8350)
-- 
2.34.1



