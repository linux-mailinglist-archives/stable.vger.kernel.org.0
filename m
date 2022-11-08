Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD86621577
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiKHOMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiKHOMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E2257B4E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F4EF6157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6E7C433C1;
        Tue,  8 Nov 2022 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916709;
        bh=h3M2MLR50FCIojthYG4cMTQHfXoeJNqXoOO+lt46Jys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lb90nfqib7kgQoLtvMJburLA7w4UKApTwKqSBIlDpFATBBjyVX9kJeGkxJEtES1yL
         0Rtaq+VNXr3EHwru0ms0Bl2Y4LEg5BSiqC+Ieo7cuZLE9a7hzgrqB9zvwY65KIj/Ju
         fD7JEgqeLz6mHhTYPnIghJgyvD/vc0RmhyFkC97E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 108/197] arm64: dts: ls208xa: specify clock frequencies for the MDIO controllers
Date:   Tue,  8 Nov 2022 14:39:06 +0100
Message-Id: <20221108133359.762849055@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d5c921a53c80dfa942f6dff36253db5a50775a5f ]

Up until now, the external MDIO controller frequency values relied
either on the default ones out of reset or on those setup by u-boot.
Let's just properly specify the MDC frequency in the DTS so that even
without u-boot's intervention Linux can drive the MDIO bus.

Fixes: 0420dde30a90 ("arm64: dts: ls208xa: add the external MDIO nodes")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index d76f1c42f3fa..7bb33933c2cb 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -533,6 +533,9 @@ emdio1: mdio@8b96000 {
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(2)>;
 			status = "disabled";
 		};
 
@@ -542,6 +545,9 @@ emdio2: mdio@8b97000 {
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(2)>;
 			status = "disabled";
 		};
 
-- 
2.35.1



