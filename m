Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2B7420E4D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhJDNYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236430AbhJDNWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:22:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9721D61BE4;
        Mon,  4 Oct 2021 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352986;
        bh=BVz3P0qfRiqO8nW7axQItDIJOBviNJFuPSP2wkwuAMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwE6YettO88MGZA/865KY/ly8kPTKVJX6xQgpAMo4hezw4ld8/xGZahjUSwTo9sv3
         lBLxh5cCXb6ElmlHCtWPv/az6zHV2r3SlpGd9PejGWWJZLX7jr0i4nmUuU0BL2VQgr
         IqCak9FjsBS9zUPPRt73xiVlXWUFlvaBADfBZ4dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 44/93] dsa: mv88e6xxx: Fix MTU definition
Date:   Mon,  4 Oct 2021 14:52:42 +0200
Message-Id: <20211004125036.017299797@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
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
index caa3c4f30405..50bbea220fbf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2613,8 +2613,8 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Port Control 2: don't force a good FCS, set the maximum frame size to
-	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
+	/* Port Control 2: don't force a good FCS, set the MTU size to
+	 * 10222 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
 	 * received packets as usual, disable ARP mirroring and don't send a
 	 * copy of all transmitted/received frames on this port to the CPU.
@@ -2633,7 +2633,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		return err;
 
 	if (chip->info->ops->port_set_jumbo_size) {
-		err = chip->info->ops->port_set_jumbo_size(chip, port, 10240);
+		err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
 		if (err)
 			return err;
 	}
@@ -2718,10 +2718,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
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
index 33d443a37efc..9936ae69e5ee 100644
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
index 8128dc607cf4..dfd9e8292e9a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1082,6 +1082,8 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 	u16 reg;
 	int err;
 
+	size += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
 	if (err)
 		return err;
-- 
2.33.0



