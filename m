Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BBA3ED665
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhHPNU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240147AbhHPNST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263B0632FD;
        Mon, 16 Aug 2021 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119632;
        bh=f/NiUibPdla70IKUtLbglAvG5zxydKA3p1/+yLNhIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjkA5TXiZ2DaH9+EePovPKKK57/+qxSJy5VD9N2fDBi3xsAsStcc5HmuQg1aB6QPL
         ghFKWU4HMs847a2uulFm+QLmA8EB9Ee7IlI9BqFn4hW8kbv/yBhbJB2D9T84xjEvMg
         37Z7A0entXnNtpsvvWzZdxw8PlfI04pN9PAdHovE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/151] net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion
Date:   Mon, 16 Aug 2021 15:02:04 +0200
Message-Id: <20210816125447.175847517@linuxfoundation.org>
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

[ Upstream commit af01754f9e3c553a2ee63b4693c79a3956e230ab ]

When a VLAN is deleted from a port, the flags in struct
switchdev_obj_port_vlan are always 0.  ksz8_port_vlan_del() copies the
BRIDGE_VLAN_INFO_UNTAGGED flag to the port's Tag Removal flag, and
therefore always clears it.

In case there are multiple VLANs configured as untagged on this port -
which seems useless, but is allowed - deleting one of them changes the
remaining VLANs to be tagged.

It's only ever necessary to change this flag when a VLAN is added to
the port, so leave it unchanged in ksz8_port_vlan_del().

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c20fb6edd420..46ef5bc79cbd 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1167,7 +1167,6 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
 	u16 data, pvid;
 	u8 fid, member, valid;
@@ -1178,8 +1177,6 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid = pvid & 0xFFF;
 
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
-
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
-- 
2.30.2



