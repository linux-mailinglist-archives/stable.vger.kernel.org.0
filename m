Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F843ED65E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbhHPNUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240056AbhHPNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4ABA632F2;
        Mon, 16 Aug 2021 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119612;
        bh=Njm3gNEJD63qzOWuG9P/h9nIWjasa5Ilr5YnsQCqUwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtwjyP9+6nYyt05syJ7TpHTCaWFfsmyqZ+dFIJGHNNg93UEDZgLt+N0oqCaKKPdrx
         iQ2dhMp/YAzTUbB7A8hG2plDTH8+hcYrD1yfdW+Mcmj5WxEa1wXZOCaGXTVH2WQ+hy
         e9am5d8r9ujQAWwRJQNqoF+cdMqk2KtIdHtMWKBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 092/151] net: dsa: microchip: ksz8795: Fix PVID tag insertion
Date:   Mon, 16 Aug 2021 15:02:02 +0200
Message-Id: <20210816125447.106780472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@mind.be>

[ Upstream commit ef3b02a1d79b691f9a354c4903cf1e6917e315f9 ]

ksz8795 has never actually enabled PVID tag insertion, and it also
programmed the PVID incorrectly.  To fix this:

* Allow tag insertion to be controlled per ingress port.  On most
  chips, set bit 2 in Global Control 19.  On KSZ88x3 this control
  flag doesn't exist.

* When adding a PVID:
  - Set the appropriate register bits to enable tag insertion on
    egress at every other port if this was the packet's ingress port.
  - Mask *out* the VID from the default tag, before or-ing in the new
    PVID.

* When removing a PVID:
  - Clear the same control bits to disable tag insertion.
  - Don't update the default tag.  This wasn't doing anything useful.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c     | 26 ++++++++++++++++++-------
 drivers/net/dsa/microchip/ksz8795_reg.h |  4 ++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ad509a57a945..bc9ca2b0e091 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1083,6 +1083,16 @@ static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
 	return 0;
 }
 
+static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
+{
+	if (ksz_is_ksz88x3(dev)) {
+		ksz_cfg(dev, REG_SW_INSERT_SRC_PVID,
+			0x03 << (4 - 2 * port), state);
+	} else {
+		ksz_pwrite8(dev, port, REG_PORT_CTRL_12, state ? 0x0f : 0x00);
+	}
+}
+
 static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan,
 			      struct netlink_ext_ack *extack)
@@ -1119,9 +1129,11 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 		u16 vid;
 
 		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
-		vid &= 0xfff;
+		vid &= ~VLAN_VID_MASK;
 		vid |= new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
+
+		ksz8_port_enable_pvid(dev, port, true);
 	}
 
 	return 0;
@@ -1132,7 +1144,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, pvid, new_pvid = 0;
+	u16 data, pvid;
 	u8 fid, member, valid;
 
 	if (ksz_is_ksz88x3(dev))
@@ -1154,14 +1166,11 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 		valid = 0;
 	}
 
-	if (pvid == vlan->vid)
-		new_pvid = 1;
-
 	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan->vid, data);
 
-	if (new_pvid != pvid)
-		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
+	if (pvid == vlan->vid)
+		ksz8_port_enable_pvid(dev, port, false);
 
 	return 0;
 }
@@ -1394,6 +1403,9 @@ static int ksz8_setup(struct dsa_switch *ds)
 
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
 
+	if (!ksz_is_ksz88x3(dev))
+		ksz_cfg(dev, REG_SW_CTRL_19, SW_INS_TAG_ENABLE, true);
+
 	/* set broadcast storm protection 10% rate */
 	regmap_update_bits(dev->regmap[1], S_REPLACE_VID_CTRL,
 			   BROADCAST_STORM_RATE,
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index c2e52c40a54c..383ba7a90f9c 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -631,6 +631,10 @@
 #define REG_PORT_4_OUT_RATE_3		0xEE
 #define REG_PORT_5_OUT_RATE_3		0xFE
 
+/* 88x3 specific */
+
+#define REG_SW_INSERT_SRC_PVID		0xC2
+
 /* PME */
 
 #define SW_PME_OUTPUT_ENABLE		BIT(1)
-- 
2.30.2



