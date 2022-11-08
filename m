Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D015621574
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbiKHOMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiKHOMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65BF57B7E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55804615C2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABBAC433C1;
        Tue,  8 Nov 2022 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916702;
        bh=cBE1qpBhCvkurVN2vXaVw0QBRqX59HvDqFo3kx0vAC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRXM3YXyFEVoT1cGynM7+Bmh298wSTXRBpei87TCEiOKj9psVrauYukOMdgP8dMhU
         ZWJOxwwtRKJpCOeQ/FcmPdD9/eLY9ZAvYwFiGbVt+tlX7WSTGUNlTWlDI1yr8u4JCq
         GLLNmp5Be1zuk3Xo5Bgl1K559WCvIe5oQRsDyev0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 106/197] arm64: dts: lx2160a: specify clock frequencies for the MDIO controllers
Date:   Tue,  8 Nov 2022 14:39:04 +0100
Message-Id: <20221108133359.669361344@linuxfoundation.org>
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

[ Upstream commit c126a0abc5dadd7df236f20aae6d8c3d103f095c ]

Up until now, the external MDIO controller frequency values relied
either on the default ones out of reset or on those setup by u-boot.
Let's just properly specify the MDC frequency in the DTS so that even
without u-boot's intervention Linux can drive the MDIO bus.

Fixes: 6e1b8fae892d ("arm64: dts: lx2160a: add emdio1 node")
Fixes: 5705b9dcda57 ("arm64: dts: lx2160a: add emdio2 node")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 6680fb2a6dc9..8c76d86cb756 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1385,6 +1385,9 @@ emdio1: mdio@8b96000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			little-endian;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(2)>;
 			status = "disabled";
 		};
 
@@ -1395,6 +1398,9 @@ emdio2: mdio@8b97000 {
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



