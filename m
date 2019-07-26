Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A79F76DAE
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbfGZPcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389007AbfGZPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FBE2054F;
        Fri, 26 Jul 2019 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155130;
        bh=B2G43BUIL/B67yn5SSx5k31Rhc5SJkFskrrpC5iyrJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6GAbXaYUXV6mOt0y/2R1duUBTL0kg7boDHopJS/rR0KiWKlSBnsNhN2HzTsY1bYM
         oDpnPqn5Esl1tUQqrZJ3WI+zxwW4ASzAEG2ibV0HEQcElQPYLWRZmMNS7vtLAT2Yld
         eqr80npMBFXona3n6aL0SvB5b1Ix9qIFikUClH4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chris.healy@zii.aero,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/50] net: phy: sfp: hwmon: Fix scaling of RX power
Date:   Fri, 26 Jul 2019 17:24:48 +0200
Message-Id: <20190726152301.937711203@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 0cea0e1148fe134a4a3aaf0b1496f09241fb943a ]

The RX power read from the SFP uses units of 0.1uW. This must be
scaled to units of uW for HWMON. This requires a divide by 10, not the
current 100.

With this change in place, sensors(1) and ethtool -m agree:

sff2-isa-0000
Adapter: ISA adapter
in0:          +3.23 V
temp1:        +33.1 C
power1:      270.00 uW
power2:      200.00 uW
curr1:        +0.01 A

        Laser output power                        : 0.2743 mW / -5.62 dBm
        Receiver signal average optical power     : 0.2014 mW / -6.96 dBm

Reported-by: chris.healy@zii.aero
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 1323061a018a ("net: phy: sfp: Add HWMON support for module sensors")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -514,7 +514,7 @@ static int sfp_hwmon_read_sensor(struct
 
 static void sfp_hwmon_to_rx_power(long *value)
 {
-	*value = DIV_ROUND_CLOSEST(*value, 100);
+	*value = DIV_ROUND_CLOSEST(*value, 10);
 }
 
 static void sfp_hwmon_calibrate(struct sfp *sfp, unsigned int slope, int offset,


