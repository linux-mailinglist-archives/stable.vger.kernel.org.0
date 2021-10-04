Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA61420FC4
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237963AbhJDNhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237981AbhJDNfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF48E63236;
        Mon,  4 Oct 2021 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353381;
        bh=tYr1UR5UVV9/l4UvwpgkGg2+Y55MDBz5RAQC9WXHaPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/UXXRg+Q5OPMxr1ew52G9uqBjneS30AMrvdhDMGeEdrjWqEPRSiK31J5feItLVWR
         TgDrRWmlVWKKx95430w/fmxKX03HZa1Rkz3oUbLJbq8pYviMW32Ng7aUwX4N6VqaTy
         JswZO/+cnW/Nk+7eho6JPmkwQg2hrGSIbzAOjeSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 107/172] dsa: mv88e6xxx: Fix MTU definition
Date:   Mon,  4 Oct 2021 14:52:37 +0200
Message-Id: <20211004125048.440210951@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit b92ce2f54c0f0ff781e914ec189c25f7bf1b1ec2 ]

The MTU passed to the DSA driver is the payload size, typically 1500.
However, the switch uses the frame size when applying restrictions.
Adjust the MTU with the size of the Ethernet header and the frame
checksum. The VLAN header also needs to be included when the frame
size it per port, but not when it is global.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/global1.c |  2 ++
 drivers/net/dsa/mv88e6xxx/port.c    |  2 ++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f99f09c50722..014950a343f4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2775,8 +2775,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Port Control 2: don't force a good FCS, set the maximum frame size to
-	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
+	/* Port Control 2: don't force a good FCS, set the MTU size to
+	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
 	 * received packets as usual, disable ARP mirroring and don't send a
 	 * copy of all transmitted/received frames on this port to the CPU.
@@ -2795,7 +2795,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		return err;
 
 	if (chip->info->ops->port_set_jumbo_size) {
-		err = chip->info->ops->port_set_jumbo_size(chip, port, 10240);
+		err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
 		if (err)
 			return err;
 	}
@@ -2885,10 +2885,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	if (chip->info->ops->port_set_jumbo_size)
-		return 10240;
+		return 10240 - VLAN_ETH_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632;
-	return 1522;
+		return 1632 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	return 1522 - VLAN_ETH_HLEN - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 815b0f681d69..5848112036b0 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -232,6 +232,8 @@ int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu)
 	u16 val;
 	int err;
 
+	mtu += ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f77e2ee64a60..451028c57af8 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1277,6 +1277,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 	u16 reg;
 	int err;
 
+	size += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
 	if (err)
 		return err;
-- 
2.33.0



