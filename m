Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0DD603DA3
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbiJSJFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiJSJEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CE3B03DA;
        Wed, 19 Oct 2022 01:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4695B61800;
        Wed, 19 Oct 2022 08:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5DFC433C1;
        Wed, 19 Oct 2022 08:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169818;
        bh=886F7+QHCEAnDMEkfjueOSSJcarr3O9tSlES4/xq6vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMzOMVwb2GFzoYgq//y72Soanf2z0PBZc7S+XbHc/Bpr+5cGorpCoc2JQ9nnygjyl
         82qhpxhUQi21NeFq94XppA4uTunASilEicTps49BR/oySvghM/uLxk1jb3TKLgauD8
         ieszuDOUpL7HxehgszCS7/aHQMO35uJOcRbuQDwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 421/862] ARM: dts: imx6qdl-kontron-samx6i: hook up DDC i2c bus
Date:   Wed, 19 Oct 2022 10:28:28 +0200
Message-Id: <20221019083308.565428913@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



