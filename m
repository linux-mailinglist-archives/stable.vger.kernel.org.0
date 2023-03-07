Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAD96AE871
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCGRPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCGRPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABC299657
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26BAB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB6BC4339B;
        Tue,  7 Mar 2023 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209054;
        bh=ZfM7LHh3djO84w/6Deze6YHGLWE+Oyp/78kHfsEM1A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmOppI6cOOr/9cx8d8ee/B+BQKE8ENcmfgtXp4J3RhG5eYlmWlDpPSDnuPma6JWd4
         nXh4CrwD1UoDARZaO7In/DIPEjAqUP9tzWSWdFsgDgx4e8i0TdjdmUSO/fnxQiiBeo
         W9NbS+ywq5BccFVttodqHpTFJ41wT7bYDArNsKWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0088/1001] arm64: dts: renesas: beacon-renesom: Fix gpio expander reference
Date:   Tue,  7 Mar 2023 17:47:40 +0100
Message-Id: <20230307170025.976691057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d7f9492dfc03153ac56ab59066a196558748f575 ]

The board used to originally introduce the Beacon Embedded RZ/G2[M/N/H]
boards had a GPIO expander with address 20, but this was changed when
the final board went to production.

The production boards changed both the part itself and the address.
With the incorrect address, the LCD cannot come up.  If the LCD fails,
the rcar-du driver fails to come up, and that also breaks HDMI.

Pre-release board were not shipped to the general public, so it should
be safe to push this as a fix.  Anyone with a production board would
have video fail due to this GPIO expander change.

Fixes: a1d8a344f1ca ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230114225647.227972-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/renesas/beacon-renesom-baseboard.dtsi | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 8166e3c1ff4e5..cafde91b4721b 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -437,20 +437,6 @@ wm8962_endpoint: endpoint {
 		};
 	};
 
-	/* 0 - lcd_reset */
-	/* 1 - lcd_pwr */
-	/* 2 - lcd_select */
-	/* 3 - backlight-enable */
-	/* 4 - Touch_shdwn */
-	/* 5 - LCD_H_pol */
-	/* 6 - lcd_V_pol */
-	gpio_exp1: gpio@20 {
-		compatible = "onnn,pca9654";
-		reg = <0x20>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
-
 	touchscreen@26 {
 		compatible = "ilitek,ili2117";
 		reg = <0x26>;
@@ -482,6 +468,16 @@ hd3ss3220_out_ep: endpoint {
 			};
 		};
 	};
+
+	gpio_exp1: gpio@70 {
+		compatible = "nxp,pca9538";
+		reg = <0x70>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		gpio-line-names = "lcd_reset", "lcd_pwr", "lcd_select",
+				  "backlight-enable", "Touch_shdwn",
+				  "LCD_H_pol", "lcd_V_pol";
+	};
 };
 
 &lvds0 {
-- 
2.39.2



