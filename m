Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147A35BDDB
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbhDLIzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238471AbhDLIwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A455561221;
        Mon, 12 Apr 2021 08:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217479;
        bh=D/HvxFYjZJ/ANAhaqPehwJ3N5Iqsp0HOSQFW644kqmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOvcHI6uV1aQT7jnrOXMSoY4XQ5UJ3KBL6m/B3nd2xdXbCQ3xb/eTcMtQ8Yt7LtTF
         CP4aBbNl5Lomrdlf5YyTgv5pdSs8BERTmoGZSmvmd9Gq/wc7Pgyu1wrLdKSe6jxCxu
         0dgT/SVnQr0Wtt02PAVccBkEZn6LShoZ53ViCYtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.10 031/188] ARM: dts: turris-omnia: configure LED[2]/INTn pin as interrupt pin
Date:   Mon, 12 Apr 2021 10:39:05 +0200
Message-Id: <20210412084014.686141907@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -236,6 +236,7 @@
 		status = "okay";
 		compatible = "ethernet-phy-id0141.0DD1", "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
+		marvell,reg-init = <3 18 0 0x4985>;
 
 		/* irq is connected to &pcawan pin 7 */
 	};


