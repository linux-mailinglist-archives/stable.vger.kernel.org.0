Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA762157F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiKHOMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiKHOMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BB05655D;
        Tue,  8 Nov 2022 06:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 471F1B81AF2;
        Tue,  8 Nov 2022 14:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2588C433D7;
        Tue,  8 Nov 2022 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916731;
        bh=iaEbcrkCuX8cye+YoOUheK23PYqax7r56lSiUtWcv2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSBV8Y6sP3jsA7agiZn4ZWxHc4B9z+OxMSC3C4B5X0AKxQ0t3yaFSbHRbVkbn88ME
         9vxNgVybucdgIQ+5TCtjQ84AL2/LiMtVzrxXhcq6EZcmiti+Tzn2YryCwTzcwiT0qT
         RBIRpoN2LIz2sZW8D2Hps2DRBm8fF331xYmTLUV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 115/197] ARM: dts: ux500: Add trips to battery thermal zones
Date:   Tue,  8 Nov 2022 14:39:13 +0100
Message-Id: <20221108133400.187793178@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit cd73adcdbad3d9e9923b045d3643409e9c148d17 ]

Recent changes to the thermal framework has made the trip
points (trips) for thermal zones compulsory, which made
the Ux500 DTS files break validation and also stopped
probing because of similar changes to the code.

Fix this by adding an "outer bounding box": battery thermal
zones should not get warmer than 70 degress, then we will
shut down.

Fixes: 8c596324232d ("dt-bindings: thermal: Fix missing required property")
Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Link: https://lore.kernel.org/r/20221030210854.346662-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href.dtsi                    | 8 ++++++++
 arch/arm/boot/dts/ste-snowball.dts                 | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-codina.dts     | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-gavini.dts     | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts     | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts     | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-kyle.dts       | 8 ++++++++
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     | 8 ++++++++
 9 files changed, 72 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href.dtsi b/arch/arm/boot/dts/ste-href.dtsi
index fbaa0ce46427..8f1bb78fc1e4 100644
--- a/arch/arm/boot/dts/ste-href.dtsi
+++ b/arch/arm/boot/dts/ste-href.dtsi
@@ -24,6 +24,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
index 1c9094f24893..e2f0cdacba7d 100644
--- a/arch/arm/boot/dts/ste-snowball.dts
+++ b/arch/arm/boot/dts/ste-snowball.dts
@@ -28,6 +28,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts b/arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts
index d6940e0afa86..27a3ab7e25e1 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-codina-tmo.dts
@@ -44,6 +44,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-codina.dts b/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
index 5f41256d7f4b..b88f0c07873d 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-codina.dts
@@ -57,6 +57,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
index 806da3fc33cd..7231bc745200 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-gavini.dts
@@ -30,6 +30,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
index b0dce91aff4b..9604695edf53 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
@@ -35,6 +35,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index ed5c79c3d04b..69387e8754a9 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -30,6 +30,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-kyle.dts b/arch/arm/boot/dts/ste-ux500-samsung-kyle.dts
index c57676faf181..167846df3104 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-kyle.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-kyle.dts
@@ -34,6 +34,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index 81b341a5ae45..93e5f5ed888d 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -30,6 +30,14 @@ battery-thermal {
 			polling-delay = <0>;
 			polling-delay-passive = <0>;
 			thermal-sensors = <&bat_therm>;
+
+			trips {
+				battery-crit-hi {
+					temperature = <70000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 	};
 
-- 
2.35.1



