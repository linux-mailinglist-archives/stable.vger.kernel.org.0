Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF57621565
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbiKHOLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiKHOLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02977218
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC8A0B81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE34C433C1;
        Tue,  8 Nov 2022 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916671;
        bh=3cGvnje7yntm+B2+IjME86yWjR2Ev15peBOa+/Q4oXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZ7MfMpG8roeuEIiyiqcLSuvVEDjGPUWQdrlPiUSOD13N2d4Plza5hCkQ6CROe673
         kJ0llaBErBPz8u+u/8jfpOaNQkW9dN3wtBsS2wQ9ValWYV38wByfd4RlS91Gk+oi3W
         aYosPmk5W59vO8WjRgXv3T/UduxKQ1w80Nsz9WqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 097/197] arm64: dts: verdin-imx8mp: fix ctrl_sleep_moci
Date:   Tue,  8 Nov 2022 14:38:55 +0100
Message-Id: <20221108133359.265534806@linuxfoundation.org>
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

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 2f321fd6d89ad1e9525f5aa1f2be9202c2f3e724 ]

The GPIO signaling ctrl_sleep_moci is currently handled as a gpio hog.
But the gpio-hog node is made a child of the wrong gpio controller.
Move it to the node representing gpio4 so that it actually works.

Without this carrier board components jumpered to use the signal are
unconditionally switched off.

Fixes: a39ed23bdf6e ("arm64: dts: freescale: add initial support for verdin imx8m plus")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-verdin.dtsi     | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
index 1c74c6a19449..360be51a3527 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -339,16 +339,6 @@ &gpio2 {
 			  "SODIMM_82",
 			  "SODIMM_70",
 			  "SODIMM_72";
-
-	ctrl-sleep-moci-hog {
-		gpio-hog;
-		/* Verdin CTRL_SLEEP_MOCI# (SODIMM 256) */
-		gpios = <29 GPIO_ACTIVE_HIGH>;
-		line-name = "CTRL_SLEEP_MOCI#";
-		output-high;
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_ctrl_sleep_moci>;
-	};
 };
 
 &gpio3 {
@@ -417,6 +407,16 @@ &gpio4 {
 			  "SODIMM_256",
 			  "SODIMM_48",
 			  "SODIMM_44";
+
+	ctrl-sleep-moci-hog {
+		gpio-hog;
+		/* Verdin CTRL_SLEEP_MOCI# (SODIMM 256) */
+		gpios = <29 GPIO_ACTIVE_HIGH>;
+		line-name = "CTRL_SLEEP_MOCI#";
+		output-high;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ctrl_sleep_moci>;
+	};
 };
 
 /* On-module I2C */
-- 
2.35.1



