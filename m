Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478ED1380CA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbgAKKeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:34:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731664AbgAKKeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:34:02 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2278920882;
        Sat, 11 Jan 2020 10:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738842;
        bh=66DVYFBrLGLVARYkBMilCyp7NSpvJyAn5q3dwlYhkL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6c1INa5Q45lM7CZGqgqv1ntx0tVlhlTvx1n/fApqbtOtc4xwQ8wMQwg/OLudZCWg
         n8EJoRvJ0gvfFtcaQy9utGsb6sSjih9LQD3hs7IMCVntY6fNtcTgPQhSRw02umbv69
         IavZDH42TXItyaT8eg7AB9mmTu63U0FINtVseZrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Baruch Siach <baruch@tkos.co.il>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 157/165] net: dsa: mv88e6xxx: force cmode write on 6141/6341
Date:   Sat, 11 Jan 2020 10:51:16 +0100
Message-Id: <20200111094942.051996560@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit f7a48b68abd9b20ce1ac6298aaaa3c4d158271dd ]

mv88e6xxx_port_set_cmode() relies on cmode stored in struct
mv88e6xxx_port to skip cmode update when the requested value matches the
cached value. It turns out that mv88e6xxx_port_hidden_write() might
change the port cmode setting as a side effect, so we can't rely on the
cached value to determine that cmode update in not necessary.

Force cmode update in mv88e6341_port_set_cmode(), to make
serdes configuration work again. Other mv88e6xxx_port_set_cmode()
callers keep the current behaviour.

This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
GT-8K.

Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/port.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -393,7 +393,7 @@ phy_interface_t mv88e6390x_port_max_spee
 }
 
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-				    phy_interface_t mode)
+				    phy_interface_t mode, bool force)
 {
 	u8 lane;
 	u16 cmode;
@@ -427,8 +427,8 @@ static int mv88e6xxx_port_set_cmode(stru
 		cmode = 0;
 	}
 
-	/* cmode doesn't change, nothing to do for us */
-	if (cmode == chip->ports[port].cmode)
+	/* cmode doesn't change, nothing to do for us unless forced */
+	if (cmode == chip->ports[port].cmode && !force)
 		return 0;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
@@ -484,7 +484,7 @@ int mv88e6390x_port_set_cmode(struct mv8
 	if (port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
@@ -504,7 +504,7 @@ int mv88e6390_port_set_cmode(struct mv88
 		break;
 	}
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
 static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
@@ -555,7 +555,7 @@ int mv88e6341_port_set_cmode(struct mv88
 	if (err)
 		return err;
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, true);
 }
 
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)


