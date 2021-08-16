Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C85E3ED688
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhHPNWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240657AbhHPNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49DD6632CB;
        Mon, 16 Aug 2021 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119719;
        bh=nHOtjRE3feirLNVFm2EMkxIy+GMyVrNJvihoM1rAXhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zK2Trfl+3WBoQOLxpYKQDIbgaoKqMdtpmwoU+TqolC5+SZxFehEOx0SmwhjKEfDT2
         wPvsXYJUwQZ3I458btxyE20qlIpFEo+HXZZdtxF7PSsDb1mvEuBE1KB2ARZ0WHHSUK
         0SFJowMNZ4yY0e3qbyOurup902G15o19OiV/3Ems=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 093/151] net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
Date:   Mon, 16 Aug 2021 15:02:03 +0200
Message-Id: <20210816125447.146694379@linuxfoundation.org>
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

[ Upstream commit 8f4f58f88fe0d9bd591f21f53de7dbd42baeb3fa ]

The switches supported by ksz8795 only have a per-port flag for Tag
Removal.  This means it is not possible to support both tagged and
untagged VLANs on the same port.  Reject attempts to add a VLAN that
requires the flag to be changed, unless there are no VLANs currently
configured.

VID 0 is excluded from this check since it is untagged regardless of
the state of the flag.

On the CPU port we could support tagged and untagged VLANs at the same
time.  This will be enabled by a later patch.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c    | 27 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index bc9ca2b0e091..c20fb6edd420 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1099,13 +1099,38 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
 
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+	/* If a VLAN is added with untagged flag different from the
+	 * port's Remove Tag flag, we need to change the latter.
+	 * Ignore VID 0, which is always untagged.
+	 */
+	if (untagged != p->remove_tag && vlan->vid != 0) {
+		unsigned int vid;
+
+		/* Reject attempts to add a VLAN that requires the
+		 * Remove Tag flag to be changed, unless there are no
+		 * other VLANs currently configured.
+		 */
+		for (vid = 1; vid < dev->num_vlans; ++vid) {
+			/* Skip the VID we are going to add or reconfigure */
+			if (vid == vlan->vid)
+				continue;
+
+			ksz8_from_vlan(dev, dev->vlan_cache[vid].table[0],
+				       &fid, &member, &valid);
+			if (valid && (member & BIT(port)))
+				return -EINVAL;
+		}
+
+		ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+		p->remove_tag = untagged;
+	}
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6afbb41ad39e..1597c63988b4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -27,6 +27,7 @@ struct ksz_port_mib {
 struct ksz_port {
 	u16 member;
 	u16 vid_member;
+	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	int stp_state;
 	struct phy_device phydev;
 
-- 
2.30.2



