Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB29A5B6FB2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiIMOQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiIMOQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:16:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BB961D86;
        Tue, 13 Sep 2022 07:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34E3ACE10F7;
        Tue, 13 Sep 2022 14:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B597C433C1;
        Tue, 13 Sep 2022 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078251;
        bh=p+HnPi623dh4PxbCAHH7wm7YkniRUhK3KuU/byw80+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUsXAdrByQXVAE9h6tf9rXJtEQy4ovrsNH2DvE+tSMue16YBsLm2L4P3hijArhaiO
         bCXZMFCXyGg/plPMp3yNaHgBBdCniNEA2XCDytevx40XFJ8fvmVwYFH3P2Gycd4BRy
         EwsR89vvDJFa39Yb96yiDBdU826FzB+0DK56+qSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 068/192] arm64: dts: imx8mm-verdin: use level interrupt for mcp251xfd
Date:   Tue, 13 Sep 2022 16:02:54 +0200
Message-Id: <20220913140413.354836862@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

[ Upstream commit e9f130e0775b5a2dad0a33440347d373ff69e631 ]

Switch to level interrupt for mcp251xfd. This will make sure no
interrupts are lost.

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 2841c6bfe3a92..6491e745b3fa8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -195,7 +195,7 @@
 	can1: can@0 {
 		compatible = "microchip,mcp251xfd";
 		clocks = <&clk40m>;
-		interrupts-extended = <&gpio1 6 IRQ_TYPE_EDGE_FALLING>;
+		interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_can1_int>;
 		reg = <0>;
-- 
2.35.1



