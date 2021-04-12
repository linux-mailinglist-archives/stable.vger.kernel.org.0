Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D735BF4A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhDLJDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237444AbhDLJBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C808E6137F;
        Mon, 12 Apr 2021 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218012;
        bh=x7VZ5WABemxezkp+xBiyWWiCowGZqH3BhZ6oCy72sog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMVhzveQroS5d0wdq8Vdnemw17FY71mHwdbuCcdGmj/vJZSt8xrERniOhV0o+iTA1
         1wcAj9EHk6+9KmhcmvdZaX6uqGk+kmOdA8TAW8tseYnUBnxB9KCbTk/+LwVwj6iHwX
         iG4OVf+vZfDRKmjFOcXn5ZNT1nw00U/Uubb0K4yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.11 038/210] ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin
Date:   Mon, 12 Apr 2021 10:39:03 +0200
Message-Id: <20210412084017.279580657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit a26c56ae67fa9fbb45a8a232dcd7ebaa7af16086 upstream.

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
Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -389,6 +389,7 @@
 	phy1: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		marvell,reg-init = <3 18 0 0x4985>;
 
 		/* irq is connected to &pcawan pin 7 */
 	};


