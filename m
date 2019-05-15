Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE61F0E6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfEOLXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfEOLXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94DC206BF;
        Wed, 15 May 2019 11:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919417;
        bh=kWtr6FzKjaWPfHKVSImpDJZdsyMw1mqvtfvNhv6cC+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SKiGbxSgiXg+DNfJU2j+sHYxlefhD4RqUfDB2QOyOjgIA2nZch0TpxknfChizxi2
         2PB7UMRJZ3JjR1aC14D4Vlb0dvM04cC14IGswNpT3LTpH023hxNDRBY3Gvah2VXwLg
         j6Zd9fiwgLG7y81Fc1Tt/PY4lIwh61OAZfPnA0ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 067/113] net: dsa: mv88e6xxx: fix few issues in mv88e6390x_port_set_cmode
Date:   Wed, 15 May 2019 12:55:58 +0200
Message-Id: <20190515090658.621165565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5ceaeb99ffb4dc002d20f6ac243c19a85e2c7a76 ]

This patches fixes few issues in mv88e6390x_port_set_cmode().

1. When entering the function the old cmode may be 0, in this case
   mv88e6390x_serdes_get_lane() returns -ENODEV. As result we bail
   out and have no chance to set a new mode. Therefore deal properly
   with -ENODEV.

2. Once we have disabled power and irq, let's set the cached cmode to 0.
   This reflects the actual status and is cleaner if we bail out with an
   error in the following function calls.

3. The cached cmode is used by mv88e6390x_serdes_get_lane(),
   mv88e6390_serdes_power_lane() and mv88e6390_serdes_irq_enable().
   Currently we set the cached mode to the new one at the very end of
   the function only, means until then we use the old one what may be
   wrong.

4. When calling mv88e6390_serdes_irq_enable() we use the lane value
   belonging to the old cmode. Get the lane belonging to the new cmode
   before calling this function.

It's hard to provide a good "Fixes" tag because quite a few smaller
changes have been done to the code in question recently.

Fixes: d235c48b40d3 ("net: dsa: mv88e6xxx: power serdes on/off for 10G interfaces on 6390X")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/dsa/mv88e6xxx/port.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fffce734f0a5..fdeddbfa829da 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -379,18 +379,22 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		return 0;
 
 	lane = mv88e6390x_serdes_get_lane(chip, port);
-	if (lane < 0)
+	if (lane < 0 && lane != -ENODEV)
 		return lane;
 
-	if (chip->ports[port].serdes_irq) {
-		err = mv88e6390_serdes_irq_disable(chip, port, lane);
+	if (lane >= 0) {
+		if (chip->ports[port].serdes_irq) {
+			err = mv88e6390_serdes_irq_disable(chip, port, lane);
+			if (err)
+				return err;
+		}
+
+		err = mv88e6390x_serdes_power(chip, port, false);
 		if (err)
 			return err;
 	}
 
-	err = mv88e6390x_serdes_power(chip, port, false);
-	if (err)
-		return err;
+	chip->ports[port].cmode = 0;
 
 	if (cmode) {
 		err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
@@ -404,6 +408,12 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 
+		chip->ports[port].cmode = cmode;
+
+		lane = mv88e6390x_serdes_get_lane(chip, port);
+		if (lane < 0)
+			return lane;
+
 		err = mv88e6390x_serdes_power(chip, port, true);
 		if (err)
 			return err;
@@ -415,8 +425,6 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		}
 	}
 
-	chip->ports[port].cmode = cmode;
-
 	return 0;
 }
 
-- 
2.20.1



