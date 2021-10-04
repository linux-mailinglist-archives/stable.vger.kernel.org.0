Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C61420FC5
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbhJDNhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237986AbhJDNfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6275961BA8;
        Mon,  4 Oct 2021 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353383;
        bh=YjiCTESwpqcDToF41uSRlXF7ZBEfd7NrEwTMAzHJm7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/lPyX1qRnMxoCwG2iFL2+iYtSXd1XQAf0iXQRUcMyPj++3aIHgEGMMftUWP/P4g8
         CjcSEhPqqtolUosteBgNai7sePwbfPkboaoyDym2ojjnkgeuMgQOqSx0LO8Tt2/9dQ
         jj8ZZwRFNd2wMVRv8RMRL6+MotWVWpyCpdLwcZPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 108/172] dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports
Date:   Mon,  4 Oct 2021 14:52:38 +0200
Message-Id: <20211004125048.470198628@linuxfoundation.org>
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

[ Upstream commit b9c587fed61cf88bd45822c3159644445f6d5aa6 ]

Same members of the Marvell Ethernet switches impose MTU restrictions
on ports used for connecting to the CPU or another switch for DSA. If
the MTU is set too low, tagged frames will be discarded. Ensure the
worst case tagger overhead is included in setting the MTU for DSA and
CPU ports.

Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU")
Reported by: 曹煜 <cao88yu@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++++---
 drivers/net/dsa/mv88e6xxx/chip.h | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 014950a343f4..66b4f4a9832a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2885,10 +2885,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	if (chip->info->ops->port_set_jumbo_size)
-		return 10240 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - ETH_FCS_LEN;
+		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -2896,6 +2896,9 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+		new_mtu += EDSA_HLEN;
+
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 675b1f3e43b7..59f316cc8583 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -18,6 +18,7 @@
 #include <linux/timecounter.h>
 #include <net/dsa.h>
 
+#define EDSA_HLEN		8
 #define MV88E6XXX_N_FID		4096
 
 /* PVT limits for 4-bit port and 5-bit switch */
-- 
2.33.0



