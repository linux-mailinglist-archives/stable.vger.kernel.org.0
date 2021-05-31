Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36083395EC4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhEaOD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhEaOBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE1E61403;
        Mon, 31 May 2021 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468211;
        bh=aAVtE617rl5nQDpqiNCoWaWMLuSU+g+6+Vz1RfPlFH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LR+HTBc/rlWeb2lo7RCUYvmPXODof7tzi3kZSaAZ5KfJjwTNS5FGBRF0xvVricEIq
         j2QYTK62OXyBtTctc6JvziSbMBlaU2T+wblS6sJBXUSPTTNehObeOFxMRORvf8qXpF
         8LEeWIAgsSKlIx7Jae9F3SHsKwVyw1DhSJJ1xQ1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 114/252] net: dsa: sja1105: update existing VLANs from the bridge VLAN list
Date:   Mon, 31 May 2021 15:12:59 +0200
Message-Id: <20210531130701.847779032@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit b38e659de966a122fe2cb178c1e39c9bea06bc62 upstream.

When running this sequence of operations:

ip link add br0 type bridge vlan_filtering 1
ip link set swp4 master br0
bridge vlan add dev swp4 vid 1

We observe the traffic sent on swp4 is still untagged, even though the
bridge has overwritten the existing VLAN entry:

port    vlan ids
swp4     1 PVID

br0      1 PVID Egress Untagged

This happens because we didn't consider that the 'bridge vlan add'
command just overwrites VLANs like it's nothing. We treat the 'vid 1
pvid untagged' and the 'vid 1' as two separate VLANs, and the first
still has precedence when calling sja1105_build_vlan_table. Obviously
there is a disagreement regarding semantics, and we end up doing
something unexpected from the PoV of the bridge.

Let's actually consider an "existing VLAN" to be one which is on the
same port, and has the same VLAN ID, as one we already have, and update
it if it has different flags than we do.

The first blamed commit is the one introducing the bug, the second one
is the latest on top of which the bugfix still applies.

Fixes: ec5ae61076d0 ("net: dsa: sja1105: save/restore VLANs using a delta commit method")
Fixes: 5899ee367ab3 ("net: dsa: tag_8021q: add a context structure")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2756,11 +2756,22 @@ static int sja1105_vlan_add_one(struct d
 	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
 	struct sja1105_bridge_vlan *v;
 
-	list_for_each_entry(v, vlan_list, list)
-		if (v->port == port && v->vid == vid &&
-		    v->untagged == untagged && v->pvid == pvid)
+	list_for_each_entry(v, vlan_list, list) {
+		if (v->port == port && v->vid == vid) {
 			/* Already added */
-			return 0;
+			if (v->untagged == untagged && v->pvid == pvid)
+				/* Nothing changed */
+				return 0;
+
+			/* It's the same VLAN, but some of the flags changed
+			 * and the user did not bother to delete it first.
+			 * Update it and trigger sja1105_build_vlan_table.
+			 */
+			v->untagged = untagged;
+			v->pvid = pvid;
+			return 1;
+		}
+	}
 
 	v = kzalloc(sizeof(*v), GFP_KERNEL);
 	if (!v) {


