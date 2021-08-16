Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C723D3ED543
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhHPNK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239012AbhHPNJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66A7E632C3;
        Mon, 16 Aug 2021 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119255;
        bh=V/WhJbzrPXjuDuEawFMTTqb+96dWQ+sePGwyMm4HOfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/Sxqfm00CW/+PQ2R+fELVznDdXFA0DSq3BTbnHdCLkAtyzln8G6OzqTK/lGkteAt
         wsaPa7Ha56e/Khrlk7ctMhh5Fd/KhEinAoMa6Kwe88becaUtOVkcC9YVy+5+fqlW7q
         IV3QmxPQOfJ0IQGfuGJnFW/uJlyIHEzEKMATQY10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/96] net: dsa: microchip: ksz8795: Fix VLAN filtering
Date:   Mon, 16 Aug 2021 15:02:02 +0200
Message-Id: <20210816125436.688497376@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@mind.be>

[ Upstream commit 164844135a3f215d3018ee9d6875336beb942413 ]

Currently ksz8_port_vlan_filtering() sets or clears the VLAN Enable
hardware flag.  That controls discarding of packets with a VID that
has not been enabled for any port on the switch.

Since it is a global flag, set the dsa_switch::vlan_filtering_is_global
flag so that the DSA core understands this can't be controlled per
port.

When VLAN filtering is enabled, the switch should also discard packets
with a VID that's not enabled on the ingress port.  Set or clear each
external port's VLAN Ingress Filter flag in ksz8_port_vlan_filtering()
to make that happen.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz8795.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1e101ab56cea..108a14db1f1a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -790,8 +790,14 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
 	if (switchdev_trans_ph_prepare(trans))
 		return 0;
 
+	/* Discard packets with VID not enabled on the switch */
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
+	/* Discard packets with VID not enabled on the ingress port */
+	for (port = 0; port < dev->phy_port_cnt; ++port)
+		ksz_port_cfg(dev, port, REG_PORT_CTRL_2, PORT_INGRESS_FILTER,
+			     flag);
+
 	return 0;
 }
 
@@ -1266,6 +1272,11 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	/* set the real number of ports */
 	dev->ds->num_ports = dev->port_cnt + 1;
 
+	/* VLAN filtering is partly controlled by the global VLAN
+	 * Enable flag
+	 */
+	dev->ds->vlan_filtering_is_global = true;
+
 	return 0;
 }
 
-- 
2.30.2



