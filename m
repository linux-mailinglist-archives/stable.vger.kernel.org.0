Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81508694977
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjBMO7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjBMO64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF07BBBBC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94387B81262
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D26C433EF;
        Mon, 13 Feb 2023 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300318;
        bh=zgBfq7s1Cxit47btw0Uli2ILQbpP6G3PcYn3JgUGv7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Khc3HoWAJ04fDEnpiHTyCmV6L8DMLRpg+27YdEgS/AwKV0STTg//mr3pUoTnSaf81
         dU3O3DiYOdHddq3GtxxgNj3iDcXUU+jAlXbtLQlgIMPu0Tq+K5yq6O/D3pGaurW9Cg
         +CYyknCcu5hhE5a1EV0CxG+Oz+KHTps9WuwQwrBY=
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
Subject: [PATCH 5.15 28/67] net: dsa: mt7530: dont change PVC_EG_TAG when CPU port becomes VLAN-aware
Date:   Mon, 13 Feb 2023 15:49:09 +0100
Message-Id: <20230213144733.704951997@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 704ba461a6000..c1505de23957f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1290,14 +1290,26 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
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



