Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDDB6B46D0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjCJOrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjCJOq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:46:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64483122CF6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FFDC618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B37C4339B;
        Fri, 10 Mar 2023 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459590;
        bh=+1Dn16WbLzEL5s/SKtH4HbIKJJbnSMv/WlMXkA+MGxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3o6UvPcwNAqXjDsG0vOZFbSLFgQmKGwB7xA9v9bZrswLOHzCFyw1Y2Gn1e41iGi8
         Np/bIMZS7NfS0UekIbM+7aB6W70e1WDeAxtbY1E2uJs+cB0/xLA4nZGiM9pcDm0LQU
         /ysKPeScD98Ijcu3SNI22gb6RGxNP6r9Nv6OFAfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vaishnav Achath <vaishnav.a@ti.com>,
        Jayesh Choudhary <j-choudhary@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/529] arm64: dts: ti: k3-j7200: Fix wakeup pinmux range
Date:   Fri, 10 Mar 2023 14:32:47 +0100
Message-Id: <20230310133806.113231214@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaishnav Achath <vaishnav.a@ti.com>

[ Upstream commit 9ae21ac445e911e3541985c20052fc05d60f6879 ]

The WKUP_PADCONFIG register region in J7200 has multiple non-addressable
regions, split the existing wkup_pmx region as follows to avoid the
non-addressable regions and include all valid WKUP_PADCONFIG registers.
Also update references to old nodes with new ones.

wkup_pmx0 -> 13 pins (WKUP_PADCONFIG 0 - 12)
wkup_pmx1 -> 2 pins (WKUP_PADCONFIG 14 - 15)
wkup_pmx2 -> 59 pins (WKUP_PADCONFIG 26 - 84)
wkup_pmx3 -> 8 pins (WKUP_PADCONFIG 93 - 100)

J7200 Datasheet (Table 6-106, Section 6.4 Pin Multiplexing) :
	https://www.ti.com/lit/ds/symlink/dra821u.pdf

Fixes: d361ed88455f ("arm64: dts: ti: Add support for J7200 SoC")

Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Reviewed-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20230119042622.22310-1-vaishnav.a@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j7200-common-proc-board.dts     |  2 +-
 .../boot/dts/ti/k3-j7200-mcu-wakeup.dtsi      | 29 ++++++++++++++++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
index e8a4143e1c241..909ab6661aef5 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -16,7 +16,7 @@ chosen {
 	};
 };
 
-&wkup_pmx0 {
+&wkup_pmx2 {
 	mcu_cpsw_pins_default: mcu-cpsw-pins-default {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0x0068, PIN_OUTPUT, 0) /* MCU_RGMII1_TX_CTL */
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index eb2a78a53512c..7f252cc6eb379 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -56,7 +56,34 @@ chipid@43000014 {
 	wkup_pmx0: pinctrl@4301c000 {
 		compatible = "pinctrl-single";
 		/* Proxy 0 addressing */
-		reg = <0x00 0x4301c000 0x00 0x178>;
+		reg = <0x00 0x4301c000 0x00 0x34>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx1: pinctrl@0x4301c038 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c038 0x00 0x8>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx2: pinctrl@0x4301c068 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c068 0x00 0xec>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx3: pinctrl@0x4301c174 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c174 0x00 0x20>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.39.2



