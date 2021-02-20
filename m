Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A31320799
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 00:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBTXNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 18:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhBTXMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 18:12:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D9664EB8;
        Sat, 20 Feb 2021 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613862726;
        bh=u7qHB3S8G0lDGgctj7hnk3Ftm2wmMqZUJjxJBtDhpoc=;
        h=From:To:Cc:Subject:Date:From;
        b=UodP6zDtTn2rRt4+ehbVCIW17ZhEeFqUvsdVPd3AtqHA/4qMCvYrcMUfBAyvkIxxE
         iolOJx4zAZ4rGDwpe/J1/qcEYjThxGJEEGVG0GEsEagBhf/rqGS9svyIwwikGShnNp
         oQDyWWm8GLipj7RmEQqFLhp+q9dHupSLChJY1X5Zxo1if/4UB0tqjTzH9Q33YiYK6z
         Pg4gPROOMnnfHDZhK7w7sh56FVWJgGSSX4ZHOuQFsKQeqW17tsnG2LT56tA9WhjzcL
         qwLadqhl1tLgfOO4enBPGnwMxa7L8mWBhWo0nEO3aSMCEXbLPqk+ZHzRpf36rRxKhd
         pFYAYcAcfN7SQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Subject: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin
Date:   Sun, 21 Feb 2021 00:11:44 +0100
Message-Id: <20210220231144.32325-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the `marvell,reg-init` DT property to configure the LED[2]/INTn pin
of the Marvell 88E1514 ethernet PHY on Turris Omnia into interrupt mode.

Without this the pin is by default in LED[2] mode, and the Marvell PHY
driver configures LED[2] into "On - Link, Blink - Activity" mode.

This fixes the issue where the pca9538 GPIO/interrupt controller (which
can't mask interrupts in HW) received too many interrupts and after a
time started ignoring the interrupt with error message:
  IRQ 71: nobody cared

There is a work in progress to have the Marvell PHY driver support
parsing PHY LED nodes from OF and registering the LEDs as Linux LED
class devices. Once this is done the PHY driver can also automatically
set the pin into INTn mode if it does not find LED[2] in OF.

Until then, though, we fix this via `marvell,reg-init` DT property.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: <stable@vger.kernel.org>

---

This patch fixes bug introduced with the commit that added Turris
Omnia's DTS (26ca8b52d6e1), but will not apply cleanly because there is
commit 8ee4a5f4f40d which changed node name and node compatible
property and this commit did not go into stable.

So either commit 8ee4a5f4f40d has also to go into stable before this, or
this patch has to be fixed a little in order to apply to 4.14+.

Please let me know how should I handle this.

---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 646a06420c77..b0f3fd8e1429 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -389,6 +389,7 @@ &mdio {
 	phy1: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		marvell,reg-init = <3 18 0 0x4985>;
 
 		/* irq is connected to &pcawan pin 7 */
 	};
-- 
2.26.2

