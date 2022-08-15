Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2063594503
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346934AbiHOWaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351048AbiHOW1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0736CF5B;
        Mon, 15 Aug 2022 12:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B905CE12E0;
        Mon, 15 Aug 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F99C433C1;
        Mon, 15 Aug 2022 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592784;
        bh=i2jhH5/szEKqI2jW51v3Ub9wFARlUPzzK8ZZbQhSzOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAxhJWIwuoLe6bXrdIP0758JgAIh+RzMrBOmUtCGtOGn4mzuKPhEsK4/qQ/jhcYOU
         B7VuagMLE0wo8rDmvPgv44pqIYQ64eqKv/jaqOC5TIkEC8OLoNvGYz1YzkNW7Oqfr7
         pyL5e98G3eBXI+gT+1CdXm0tuufMvKntfCYLkUJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0164/1157] ARM: dts: imx6ul: change operating-points to uint32-matrix
Date:   Mon, 15 Aug 2022 19:52:00 +0200
Message-Id: <20220815180446.241489129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 1d435a46fc5c..2fcbd9d91521 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -64,20 +64,18 @@ cpu0: cpu@0 {
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



