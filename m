Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DEF60ABB6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiJXNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbiJXNyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0D5BE2C2;
        Mon, 24 Oct 2022 05:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B49FD612C9;
        Mon, 24 Oct 2022 12:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF6FC433C1;
        Mon, 24 Oct 2022 12:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615442;
        bh=886F7+QHCEAnDMEkfjueOSSJcarr3O9tSlES4/xq6vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zn03B/0Cciu4XNi4N6qp5pIhy5ZRJoA5/6lBMh2ET05niaVDFpNRMO6zVXlSAI8WD
         ZZ0veM6mnTwPy9d2TEZT2DuIPZPf4z4SqoPA4ytexKaZSb0A7zA2c5UDzkIy4hHcJa
         gdpw2CK/Vn0Ja3TfwDk6Rz4SVbionCPl54T8501Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/530] ARM: dts: imx6qdl-kontron-samx6i: hook up DDC i2c bus
Date:   Mon, 24 Oct 2022 13:29:56 +0200
Message-Id: <20221024113056.510332388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit afd8f77957e3e83adf21d9229c61ff37f44a177a ]

i2c2 is routed to the pins dedicated as DDC in the module standard.
Reduce clock rate to 100kHz to be in line with VESA standard and hook
this bus up to the HDMI node.

Fixes: 708ed2649ad8 ("ARM: dts: imx6qdl-kontron-samx6i: increase i2c-frequency")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
[m.felsch@pengutronix.de: add fixes line]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 6b791d515e29..683f6e58ab23 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -263,6 +263,10 @@
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
 };
 
+&hdmi {
+	ddc-i2c-bus = <&i2c2>;
+};
+
 &i2c_intern {
 	pmic@8 {
 		compatible = "fsl,pfuze100";
@@ -387,7 +391,7 @@
 
 /* HDMI_CTRL */
 &i2c2 {
-	clock-frequency = <375000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 };
-- 
2.35.1



