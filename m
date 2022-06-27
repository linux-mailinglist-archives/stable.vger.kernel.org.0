Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB9455C76A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiF0Lyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238786AbiF0Lwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB0CE1F;
        Mon, 27 Jun 2022 04:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC840B80D37;
        Mon, 27 Jun 2022 11:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCF4C341C8;
        Mon, 27 Jun 2022 11:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330338;
        bh=/ytqoKsFYOTGym0SGOiMclSgdUUJRlrjEEvf8L8UZGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBp3HolJLBDYFuT4nfWKi8mLXoIKj6CrNlksgT2h4hDZYtWMq3CdP45RD2a0LlW1N
         e8GqwN9SF0iK/mwouFkXI3jS72met5Fx7q3gbiLvhNdjc1B8Zzm5sZcrTwoxFW2oqK
         095RNCdupO8DH1g637WTeMHWv+YjoNSDsxFpHCC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.18 163/181] ARM: dts: imx7: Move hsic_phy power domain to HSIC PHY node
Date:   Mon, 27 Jun 2022 13:22:16 +0200
Message-Id: <20220627111949.413688048@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
@@ -120,6 +120,7 @@
 		compatible = "usb-nop-xceiv";
 		clocks = <&clks IMX7D_USB_HSIC_ROOT_CLK>;
 		clock-names = "main_clk";
+		power-domains = <&pgc_hsic_phy>;
 		#phy-cells = <0>;
 	};
 
@@ -1153,7 +1154,6 @@
 				compatible = "fsl,imx7d-usb", "fsl,imx27-usb";
 				reg = <0x30b30000 0x200>;
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
-				power-domains = <&pgc_hsic_phy>;
 				clocks = <&clks IMX7D_USB_CTRL_CLK>;
 				fsl,usbphy = <&usbphynop3>;
 				fsl,usbmisc = <&usbmisc3 0>;


