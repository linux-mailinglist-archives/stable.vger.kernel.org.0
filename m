Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE35551D06
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiFTNPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344738AbiFTNOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:14:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4733E1EEFF;
        Mon, 20 Jun 2022 06:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A85B811B1;
        Mon, 20 Jun 2022 13:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E084BC3411B;
        Mon, 20 Jun 2022 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730376;
        bh=zb93dGo4rOx73I2NIL7+fy8aGwRzCN4TayNzb/JoJmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFWExt4Sm8PhmtgA3PpGll82TSI1HyurTcPIcZ4DnbE7mKAYiT6jcyEsfIaOTBq7o
         doBDJG6+lKHlSE0lYDnpKxpIVnALOfahCO2teHIr218pji9LaqY4/upN6L9FiJntRE
         /1b6VIk9MjHybxhKXVgpBowCgig+fIstj47ymb6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 004/106] arm64: dts: imx8mn-beacon: Enable RTS-CTS on UART3
Date:   Mon, 20 Jun 2022 14:50:23 +0200
Message-Id: <20220620124724.513898809@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Adam Ford <aford173@gmail.com>

commit 5446ff1a67160ad92d9aae9530846aa54750be36 upstream.

There is a header for a DB9 serial port, but any attempts to use
hardware handshaking fail.  Enable RTS and CTS pin muxing and enable
handshaking in the uart node.

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-baseboard.dtsi
@@ -176,6 +176,7 @@
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MN_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MN_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -259,6 +260,8 @@
 		fsl,pins = <
 			MX8MN_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MN_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MN_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MN_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 


