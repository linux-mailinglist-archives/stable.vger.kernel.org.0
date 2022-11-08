Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15E3621599
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiKHONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiKHONX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE44BB1;
        Tue,  8 Nov 2022 06:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36ED160025;
        Tue,  8 Nov 2022 14:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31397C433D6;
        Tue,  8 Nov 2022 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916801;
        bh=UHKzE7k9Sx80WMLRf2QfDfovw+SNyTDrEBBrnkdfrw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIzS44TpCXAFS4nVT2GPx3VZyugYFlUPurknUjOlUACu32lm7XtrtiHEWFxaDaNty
         9bLBjjYB5sgp1t5Eb2ijCe7KUlQxqWR2MTK/N69UQ/2FPFFrfg9hwUaEgeMHzWde1M
         CjpdXz3HrSryglgnu6+rZWHnFs4xBB/1o9nTsqnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 120/197] arm64: dts: juno: Add thermal critical trip points
Date:   Tue,  8 Nov 2022 14:39:18 +0100
Message-Id: <20221108133400.439625821@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit c4a7b9b587ca1bb4678d48d8be7132492b23a81c ]

When thermnal zones are defined, trip points definitions are mandatory.
Define a couple of critical trip points for monitoring of existing
PMIC and SOC thermal zones.

This was lost between txt to yaml conversion and was re-enforced recently
via the commit 8c596324232d ("dt-bindings: thermal: Fix missing required property")

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Fixes: f7b636a8d83c ("arm64: dts: juno: add thermal zones for scpi sensors")
Link: https://lore.kernel.org/r/20221028140833.280091-8-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 2f27619d8abd..8b4d280b1e7e 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -751,12 +751,26 @@ pmic {
 			polling-delay = <1000>;
 			polling-delay-passive = <100>;
 			thermal-sensors = <&scpi_sensors0 0>;
+			trips {
+				pmic_crit0: trip0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 
 		soc {
 			polling-delay = <1000>;
 			polling-delay-passive = <100>;
 			thermal-sensors = <&scpi_sensors0 3>;
+			trips {
+				soc_crit0: trip0 {
+					temperature = <80000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 
 		big_cluster_thermal_zone: big-cluster {
-- 
2.35.1



