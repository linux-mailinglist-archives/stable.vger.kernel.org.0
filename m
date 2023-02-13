Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9F76948E5
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBMOyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjBMOyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18615BB7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E9166106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB8C433D2;
        Mon, 13 Feb 2023 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300047;
        bh=L8Ft1INuuRK3MqeSeLCNiNTKfgLWcBkv5nKVRYgr6dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tL8rBcgOa44wszLIu8URx/JnCOPx5zf3WBCJtGlNbOYAf99woKhIWnr0gcWYHD8b6
         FCa6M9ttRU5Eh9x+kqhlOp0mfimAYhzG7qCrCOpeVSs2Zrc7PAHxmNedv8wq0fKZ9S
         yjrvtimiOI1D5txIcrugdtW2lEd/ln8nkCskhseY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/114] net: dsa: mt7530: dont change PVC_EG_TAG when CPU port becomes VLAN-aware
Date:   Mon, 13 Feb 2023 15:47:58 +0100
Message-Id: <20230213144744.376677544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0b6d6425103a676e2b6a81f3fd35d7ea4f9b90ec ]

Frank reports that in a mt7530 setup where some ports are standalone and
some are in a VLAN-aware bridge, 8021q uppers of the standalone ports
lose their VLAN tag on xmit, as seen by the link partner.

This seems to occur because once the other ports join the VLAN-aware
bridge, mt7530_port_vlan_filtering() also calls
mt7530_port_set_vlan_aware(ds, cpu_dp->index), and this affects the way
that the switch processes the traffic of the standalone port.

Relevant is the PVC_EG_TAG bit. The MT7530 documentation says about it:

EG_TAG: Incoming Port Egress Tag VLAN Attribution
0: disabled (system default)
1: consistent (keep the original ingress tag attribute)

My interpretation is that this setting applies on the ingress port, and
"disabled" is basically the normal behavior, where the egress tag format
of the packet (tagged or untagged) is decided by the VLAN table
(MT7530_VLAN_EGRESS_UNTAG or MT7530_VLAN_EGRESS_TAG).

But there is also an option of overriding the system default behavior,
and for the egress tagging format of packets to be decided not by the
VLAN table, but simply by copying the ingress tag format (if ingress was
tagged, egress is tagged; if ingress was untagged, egress is untagged;
aka "consistent). This is useful in 2 scenarios:

- VLAN-unaware bridge ports will always encounter a miss in the VLAN
  table. They should forward a packet as-is, though. So we use
  "consistent" there. See commit e045124e9399 ("net: dsa: mt7530: fix
  tagged frames pass-through in VLAN-unaware mode").

- Traffic injected from the CPU port. The operating system is in god
  mode; if it wants a packet to exit as VLAN-tagged, it sends it as
  VLAN-tagged. Otherwise it sends it as VLAN-untagged*.

*This is true only if we don't consider the bridge TX forwarding offload
feature, which mt7530 doesn't support.

So for now, make the CPU port always stay in "consistent" mode to allow
software VLANs to be forwarded to their egress ports with the VLAN tag
intact, and not stripped.

Link: https://lore.kernel.org/netdev/trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36/
Fixes: e045124e9399 ("net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode")
Reported-by: Frank Wunderlich <frank-w@public-files.de>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230205140713.1609281-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e74c6b4061728..a884f6f6a8c2c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1309,14 +1309,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 		if (!priv->ports[port].pvid)
 			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
 				   MT7530_VLAN_ACC_TAGGED);
-	}
 
-	/* Set the port as a user port which is to be able to recognize VID
-	 * from incoming packets before fetching entry within the VLAN table.
-	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER) |
-		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+		/* Set the port as a user port which is to be able to recognize
+		 * VID from incoming packets before fetching entry within the
+		 * VLAN table.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port),
+			   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER) |
+			   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
+	} else {
+		/* Also set CPU ports to the "user" VLAN port attribute, to
+		 * allow VLAN classification, but keep the EG_TAG attribute as
+		 * "consistent" (i.o.w. don't change its value) for packets
+		 * received by the switch from the CPU, so that tagged packets
+		 * are forwarded to user ports as tagged, and untagged as
+		 * untagged.
+		 */
+		mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
+			   VLAN_ATTR(MT7530_VLAN_USER));
+	}
 }
 
 static void
-- 
2.39.0



