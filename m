Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0B551C4B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245155AbiFTNLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiFTNIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396119FB4;
        Mon, 20 Jun 2022 06:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45AAE61543;
        Mon, 20 Jun 2022 13:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D29C3411B;
        Mon, 20 Jun 2022 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730062;
        bh=MgywS8XvIM5eqT3QyCdyvklsRJN0u5CnLIFVeSWA3Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ7ztMDLDxbG4/XCBFInhJvfJS3DBLbonF2vRD3Ptrl/IaRxy3pkSGKSg4Um8FZDJ
         oaXwxLzzkxKAkicBxMJAU/BOvRSBRw3oeecWnHPrIH82w8sUOzGePW9pWYRP6t72qB
         dblYO9pH2rKa2Hl5xuQqqvCcmUuDwSA8idCaBFIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 04/84] arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3
Date:   Mon, 20 Jun 2022 14:50:27 +0200
Message-Id: <20220620124721.016486184@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
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

commit 4ce01ce36d77137cf60776b320babed89de6bd4c upstream.

There is a header for a DB9 serial port, but any attempts to use
hardware handshaking fail.  Enable RTS and CTS pin muxing and enable
handshaking in the uart node.

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -167,6 +167,7 @@
 	pinctrl-0 = <&pinctrl_uart3>;
 	assigned-clocks = <&clk IMX8MM_CLK_UART3>;
 	assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
+	uart-has-rtscts;
 	status = "okay";
 };
 
@@ -237,6 +238,8 @@
 		fsl,pins = <
 			MX8MM_IOMUXC_ECSPI1_SCLK_UART3_DCE_RX	0x40
 			MX8MM_IOMUXC_ECSPI1_MOSI_UART3_DCE_TX	0x40
+			MX8MM_IOMUXC_ECSPI1_MISO_UART3_DCE_CTS_B	0x40
+			MX8MM_IOMUXC_ECSPI1_SS0_UART3_DCE_RTS_B	0x40
 		>;
 	};
 


