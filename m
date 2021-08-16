Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9E83ED679
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbhHPNVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240566AbhHPNTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87CB632AE;
        Mon, 16 Aug 2021 13:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119688;
        bh=X7VHotr/bJrTUcEe9GqHBUXNv2zRVTyyICQnBuZmeRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn95xL8NI1/x6xPKr5HBgBIgiDgM/0I3gOVzBjNOaCLNOJA5U7UMbvlxX9bg47TL0
         F5y/m8J8zzSrBAVGluX0NEyJKXHRoU5t831P3B4WHc4C+OVh5+syn2ZL/vJ/k/ffk8
         /xtwgL32ap4HEWhbltTxbp2lhSozmOWS6oxqpBlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 096/151] net: dsa: microchip: ksz8795: Fix VLAN filtering
Date:   Mon, 16 Aug 2021 15:02:06 +0200
Message-Id: <20210816125447.236089526@linuxfoundation.org>
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
index 4bd735c5183c..8e2a8103d590 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1078,8 +1078,14 @@ static int ksz8_port_vlan_filtering(struct dsa_switch *ds, int port, bool flag,
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
+	/* Discard packets with VID not enabled on the switch */
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
+	/* Discard packets with VID not enabled on the ingress port */
+	for (port = 0; port < dev->phy_port_cnt; ++port)
+		ksz_port_cfg(dev, port, REG_PORT_CTRL_2, PORT_INGRESS_FILTER,
+			     flag);
+
 	return 0;
 }
 
@@ -1662,6 +1668,11 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	 */
 	dev->ds->untag_bridge_pvid = true;
 
+	/* VLAN filtering is partly controlled by the global VLAN
+	 * Enable flag
+	 */
+	dev->ds->vlan_filtering_is_global = true;
+
 	return 0;
 }
 
-- 
2.30.2



