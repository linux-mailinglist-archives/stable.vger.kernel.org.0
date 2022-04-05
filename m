Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864C24F31FB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347794AbiDEJ2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbiDEIwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D5924948;
        Tue,  5 Apr 2022 01:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BBDBB81BAE;
        Tue,  5 Apr 2022 08:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2B9C385A0;
        Tue,  5 Apr 2022 08:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148364;
        bh=dzWhcPIWdsa4A39sNEcEVgjZ6v05Z816/SN2s+i6y/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVCRmowKLwLrBY87p5mixckWL7fYWuoVuoj6ckBlFu6uu/0c8RSujwuJ3Yer5PQR9
         whkO6hgeApiwRhbhI9SWULPX6p3xDFnZeVdU4fJX5rB2F5pRQ1XkigvYhr9+iBaKFj
         uLirsO1bea443rxigRvNyyQRJYZWMIWN8b2HL8U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0330/1017] ARM: dts: imx: Add missing LVDS decoder on M53Menlo
Date:   Tue,  5 Apr 2022 09:20:43 +0200
Message-Id: <20220405070404.077109510@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0c6f71176ea43d6f4003a4d57f7bb518c5ad6145 ]

The M53Menlo display unit uses an LVDS-to-DPI bridge, TI DS90CF364A.
Describe this bridge in DT, otherwise the DT incorrectly describes
DPI panel attached directly to LVDS source.

Fixes: 716be61d1869 ("ARM: dts: imx53: Add Menlosystems M53 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-m53menlo.dts | 29 ++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-m53menlo.dts b/arch/arm/boot/dts/imx53-m53menlo.dts
index 4f88e96d81dd..d5c68d1ea707 100644
--- a/arch/arm/boot/dts/imx53-m53menlo.dts
+++ b/arch/arm/boot/dts/imx53-m53menlo.dts
@@ -53,6 +53,31 @@
 		};
 	};
 
+	lvds-decoder {
+		compatible = "ti,ds90cf364a", "lvds-decoder";
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+
+				lvds_decoder_in: endpoint {
+					remote-endpoint = <&lvds0_out>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+
+				lvds_decoder_out: endpoint {
+					remote-endpoint = <&panel_in>;
+				};
+			};
+		};
+	};
+
 	panel {
 		compatible = "edt,etm0700g0dh6";
 		pinctrl-0 = <&pinctrl_display_gpio>;
@@ -61,7 +86,7 @@
 
 		port {
 			panel_in: endpoint {
-				remote-endpoint = <&lvds0_out>;
+				remote-endpoint = <&lvds_decoder_out>;
 			};
 		};
 	};
@@ -450,7 +475,7 @@
 			reg = <2>;
 
 			lvds0_out: endpoint {
-				remote-endpoint = <&panel_in>;
+				remote-endpoint = <&lvds_decoder_in>;
 			};
 		};
 	};
-- 
2.34.1



