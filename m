Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449E958C0BE
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbiHHByF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243909AbiHHBwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:52:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928D11A819;
        Sun,  7 Aug 2022 18:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD88B60DF8;
        Mon,  8 Aug 2022 01:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5EBC433B5;
        Mon,  8 Aug 2022 01:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922731;
        bh=1A5r9hYexUM/9UNCzOVYPV04HzR/ucU5F94PF7LMAtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f01x7A5u48Fa5Kygbdt8U9Lhea701om3JAdbl9IyC0BPkxYfT31uSAFWNXr/BKlOI
         vTPYwSmZen0MafP11UpaDyNyBblWxkwmBy81UZqXcugzQz9TnLsll1OGio/kYtqEzb
         Fp0RU37cmp/Hasz9w5ykjfMo3bAZGhrVwikaB9zx9sLHtLEs9LQ3n7RBXyiBPc6loj
         +5m+b4RbA9Yp51La1V19Vo/RSuaOEqELAbCe5N5pavF9GoLtPFF9Z7xuXBeJ3V8Y4V
         V6M0pNkbBQ1wThTBjRSKFuJYR7RP1Art/Bsj9FdpDodoRf7GUxKJYN22AAWwsW7zka
         4WqMl0Beetong==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/23] ARM: dts: imx6ul: change operating-points to uint32-matrix
Date:   Sun,  7 Aug 2022 21:38:16 -0400
Message-Id: <20220808013832.316381-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013832.316381-1-sashal@kernel.org>
References: <20220808013832.316381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit edb67843983bbdf61b4c8c3c50618003d38bb4ae ]

operating-points is a uint32-matrix as per opp-v1.yaml. Change it
accordingly. While at it, change fsl,soc-operating-points as well,
although there is no bindings file (yet). But they should have the same
format. Fixes the dt_binding_check warning:
cpu@0: operating-points:0: [696000, 1275000, 528000, 1175000, 396000,
1025000, 198000, 950000] is too long
cpu@0: operating-points:0: Additional items are not allowed (528000,
1175000, 396000, 1025000, 198000, 950000 were unexpected)

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 630643013bdc..baf4a41a9aa9 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -62,20 +62,18 @@ cpu0: cpu@0 {
 			clock-frequency = <696000000>;
 			clock-latency = <61036>; /* two CLK32 periods */
 			#cooling-cells = <2>;
-			operating-points = <
+			operating-points =
 				/* kHz	uV */
-				696000	1275000
-				528000	1175000
-				396000	1025000
-				198000	950000
-			>;
-			fsl,soc-operating-points = <
+				<696000	1275000>,
+				<528000	1175000>,
+				<396000	1025000>,
+				<198000	950000>;
+			fsl,soc-operating-points =
 				/* KHz	uV */
-				696000	1275000
-				528000	1175000
-				396000	1175000
-				198000	1175000
-			>;
+				<696000	1275000>,
+				<528000	1175000>,
+				<396000	1175000>,
+				<198000	1175000>;
 			clocks = <&clks IMX6UL_CLK_ARM>,
 				 <&clks IMX6UL_CLK_PLL2_BUS>,
 				 <&clks IMX6UL_CLK_PLL2_PFD2>,
-- 
2.35.1

