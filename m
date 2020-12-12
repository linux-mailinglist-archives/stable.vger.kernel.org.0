Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340DB2D8591
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 11:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438492AbgLLJ6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 04:58:52 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:35806 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438467AbgLLJ6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 04:58:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607766929;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=g6bpl7WULr2ukmQidYOp2C0r5vm/laI1YjdSO2Z4mDY=;
        b=WGnrZBALPPbamiiPMRkfsc49KHyr6BL/UIvbeiWw9K8Ik8UOaP4m2S0e5IzlrFXQL3
        +FKM1JrBvM+vRxvNlhbtJCazTPGzLBN1CxzP3djUELk9SE4enmhRF8ojuykfzn/xfqO8
        mACFdyE4l2db7qckI9Aqzrv3W1abmrwTOM2zZ165o3yX4JlhqF6t8FTZzhDrUWbeNVV5
        90i/LhXBUwbtVO9UWDH763h0aUQ4Is696bJ8wtKVRrw67YCQBP8HaJ7T4frJfkAoCWkq
        NtdcqBCu5L2lCUJhvDhiE8T1Lj66hsCkuaFty2fpMoLwWekwQHS7aJVQQO1C4PNnCxKu
        Hmjw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH4FpDwNN0="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 47.7.1 DYNA|AUTH)
        with ESMTPSA id K0b553wBC9tQ2bo
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 12 Dec 2020 10:55:26 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H. Nikolaus Schaller" <hns@goldelico.com>, stable@vger.kernel.org
Subject: [PATCH] DTS: ARM: gta04: remove legacy spi-cs-high to make display work again
Date:   Sat, 12 Dec 2020 10:55:25 +0100
Message-Id: <de8774e44a8f6402435e64034b8e7122157f5b52.1607766924.git.hns@goldelico.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts

commit f1f028ff89cb ("DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again")

which had to be intruduced after

commit 6953c57ab172 ("gpio: of: Handle SPI chipselect legacy bindings")

broke the GTA04 display. This contradicted the data sheet but was the only
way to get it as an spi client operational again.

The panel data sheet defines the chip-select to be active low.

Now, with the arrival of

commit 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")

the logic of interaction between spi-cs-high and the gpio descriptor flags
has been changed a second time, making the display broken again. So we have
to remove the original fix which in retrospect was a workaround of a bug in
the spi subsystem and not a feature of the panel or bug in the device tree.

With this fix the device tree is back in sync with the data sheet and
spi subsystem code.

Fixes: 766c6b63aa04 ("spi: fix client driver breakages when using GPIO descriptors")
CC: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index c8745bc800f71..003202d129907 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -124,7 +124,6 @@ lcd: td028ttec1@0 {
 			spi-max-frequency = <100000>;
 			spi-cpol;
 			spi-cpha;
-			spi-cs-high;
 
 			backlight= <&backlight>;
 			label = "lcd";
-- 
2.26.2

