Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D844255CBB7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbiF0Lne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbiF0Lmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A222DBB;
        Mon, 27 Jun 2022 04:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26246609D0;
        Mon, 27 Jun 2022 11:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A874C3411D;
        Mon, 27 Jun 2022 11:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329826;
        bh=EfqybhqZKCqHI6x6TuEbBk8Qw1d4L2PCvm9+UEsIQUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygnFz7+udtmJ65Jqp1d8vs0MPbZM1lsgrLyB6RDEInFwDbUyf5oHjS9FDMBe3Fzz2
         oI5Wz78M4zozBki9yKcjeIcMuuP6G+JYUMqKKOGMIGAXBO1gbhfyT0HIWsGYF0gDVz
         ZsYhqetntbU5wAUQz5orMKLS2ZodgJBA4l1XNbnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 121/135] ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node
Date:   Mon, 27 Jun 2022 13:22:08 +0200
Message-Id: <20220627111941.666378889@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 552ca27929ab28b341ae9b2629f0de3a84c98ee8 upstream.

Move the power domain to its actual user. This keeps the power domain
enabled even when the USB host is runtime suspended. This is necessary
to detect any downstream events, like device attach.

Fixes: 02f8eb40ef7b ("ARM: dts: imx7s: Add power domain for imx7d HSIC")
Suggested-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx7s.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -104,6 +104,7 @@
 		compatible = "usb-nop-xceiv";
 		clocks = <&clks IMX7D_USB_HSIC_ROOT_CLK>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_hsic_phy>;
 		#phy-cells = <0>;
 	};
 
@@ -1135,7 +1136,6 @@
 				compatible = "fsl,imx7d-usb", "fsl,imx27-usb";
 				reg = <0x30b30000 0x200>;
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-				power-domains = <&pgc_hsic_phy>;
 				clocks = <&clks IMX7D_USB_CTRL_CLK>;
 				fsl,usbphy = <&usbphynop3>;
 				fsl,usbmisc = <&usbmisc3 0>;


