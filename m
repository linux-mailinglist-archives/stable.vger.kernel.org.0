Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCE93114B0
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBEWMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232707AbhBEOld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E7C64FCA;
        Fri,  5 Feb 2021 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534154;
        bh=c7Q8ewKd/jRSRoeS+fbFYVXJ7RfUsOeiMX6bRQu4UYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XSZoagzfJjY+ItuMtSVaLkrqBCNjszBkDE/3N0IaO4hCFEElyfRjdkHkwZGFgwwQ
         VDGOBpoGsoJ4259D4GMH0sM8qlqxcIrw+YWq3oypKRSSI4rMObhD4o/R5iQ2BWDtQX
         8dYZxPLDVIn7rPwBPh3AIhd5bq3nbJFJfgVHqqkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Barker <pbarker@konsulko.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 01/57] net: dsa: microchip: Adjust reset release timing to match reference reset circuit
Date:   Fri,  5 Feb 2021 15:06:27 +0100
Message-Id: <20210205140656.043955711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 1c45ba93d34cd6af75228f34d0675200c81738b5 upstream.

KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
rise enough to release the reset.

For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
                    VDDIO - VIH
  t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
                       VDDIO
so we need ~95 ms for the reset to really de-assert, and then the
original 100us for the switch itself to come out of reset. Simply
msleep() for 100 ms which fits the constraint with a bit of extra
space.

Fixes: 5b797980908a ("net: dsa: microchip: Implement recommended reset timing")
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Paul Barker <pbarker@konsulko.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210120030502.617185-1-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 489963664443..389abfd27770 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -400,7 +400,7 @@ int ksz_switch_register(struct ksz_device *dev,
 		gpiod_set_value_cansleep(dev->reset_gpio, 1);
 		usleep_range(10000, 12000);
 		gpiod_set_value_cansleep(dev->reset_gpio, 0);
-		usleep_range(100, 1000);
+		msleep(100);
 	}
 
 	mutex_init(&dev->dev_mutex);
-- 
2.30.0



