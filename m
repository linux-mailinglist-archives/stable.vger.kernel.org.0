Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7584C4D982B
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 10:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346846AbiCOJyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 05:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiCOJyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 05:54:17 -0400
Received: from smtp-out.xnet.cz (smtp-out.xnet.cz [178.217.244.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2808CC3;
        Tue, 15 Mar 2022 02:52:58 -0700 (PDT)
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 78C6418B17;
        Tue, 15 Mar 2022 10:52:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=true.cz; s=xnet;
        t=1647337976; bh=IQtZfpMDBgNq+XqyyqcXkjpmhkMzPfrWtiIPXWEftkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=O5l+9lqIldUUtx0pEdG7W5ytrn6ar+q2ON3b/cEFsr/nGrVhn48KlshztPUznUGh5
         up9ye7AmKTwO0pV9RFJVLYlHmpt8uHnSNL6xWAJXedBMh51fVcIpcIDOR8Wsh9ZxSi
         gWHiKAB9gUxJBi+o65x5LacW5JNQMg9nyCxrj0Qc=
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 8ca2b6eb;
        Tue, 15 Mar 2022 10:52:32 +0100 (CET)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Cc:     =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] Revert "ARM: dts: sun7i: A20-olinuxino-lime2: Fix ethernet phy-mode"
Date:   Tue, 15 Mar 2022 10:52:42 +0100
Message-Id: <20220315095244.29718-2-ynezz@true.cz>
In-Reply-To: <20220315095244.29718-1-ynezz@true.cz>
References: <20220315095244.29718-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 55dd7e059098ce4bd0a55c251cb78e74604abb57 as it
breaks network on my A20-olinuxino-lime2 hardware revision "K" which has
Micrel KSZ9031RNXCC-TR Gigabit PHY. Bastien has probably some previous
hardware revisions which were based on RTL8211E-VB-CG1 PHY and thus this
fix was working on his board.

Cc: stable@vger.kernel.org
Cc: Bastien Roucariès <rouca@debian.org>
References: https://github.com/openwrt/openwrt/issues/9153
References: https://github.com/OLIMEX/OLINUXINO/blob/master/HARDWARE/A20-OLinuXino-LIME2/hardware_revision_changes_log.txt
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
index ecb91fb899ff..8077f1716fbc 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
@@ -112,7 +112,7 @@ &gmac {
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac_rgmii_pins>;
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii-id";
+	phy-mode = "rgmii";
 	status = "okay";
 };
 
