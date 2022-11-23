Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE0F6357D8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiKWJrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiKWJqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12041165BD
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99022B81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D149DC433C1;
        Wed, 23 Nov 2022 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196623;
        bh=z5GETknOQPK5Ek7hfT88k4+2NbUFgA2cq9oDvquLDL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LztdYAgRmiuryEdmAZAGFuHyTJvhv6FMrH+7OGlA8dzgaU8w0/Gm2HvH6jPAVFFc/
         7RCjLyZsSb9phRqcM7Fs24ZrjNyYLHkoZa5VTVvK107nTmVJdgTHa20ecJIUFFAvmL
         DY1jRuD7Eg3oM8431hcrDK50F9QJnjC5BOt7sDgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 083/314] arm64: dts: qcom: sc8280xp: drop broken DP PHY nodes
Date:   Wed, 23 Nov 2022 09:48:48 +0100
Message-Id: <20221123084629.234050356@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 7cdfb7a54ac88f7cb6d830ebb78bdbcbcb44bb4c ]

The DP PHY register layout of the current binding do not apply to the
newer USB4/USB3/DP PHY which uses a different register layout entirely.

Drop the DP PHY subnodes until the binding has been updated to prevent
the driver from corrupting unrelated registers.

Note that this is also needed in order to not break USB with an upcoming
PHY driver change that checks for overlapping register regions.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220919094454.1574-5-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index cf6d1063bb84..2a702abcf51e 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1191,16 +1191,6 @@ usb_0_ssphy: usb3-phy@88eb400 {
 				clock-names = "pipe0";
 				clock-output-names = "usb0_phy_pipe_clk_src";
 			};
-
-			usb_0_dpphy: dp-phy@88ed200 {
-				reg = <0 0x088ed200 0 0x200>,
-				      <0 0x088ed400 0 0x200>,
-				      <0 0x088eda00 0 0x200>,
-				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>;
-				#clock-cells = <1>;
-				#phy-cells = <0>;
-			};
 		};
 
 		usb_1_hsphy: phy@8902000 {
@@ -1253,16 +1243,6 @@ usb_1_ssphy: usb3-phy@8903400 {
 				clock-names = "pipe0";
 				clock-output-names = "usb1_phy_pipe_clk_src";
 			};
-
-			usb_1_dpphy: dp-phy@8904200 {
-				reg = <0 0x08904200 0 0x200>,
-				      <0 0x08904400 0 0x200>,
-				      <0 0x08904a00 0 0x200>,
-				      <0 0x08904600 0 0x200>,
-				      <0 0x08904800 0 0x200>;
-				#clock-cells = <1>;
-				#phy-cells = <0>;
-			};
 		};
 
 		system-cache-controller@9200000 {
-- 
2.35.1



