Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C51D1F4397
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgFIRym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733130AbgFIRyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BF4207ED;
        Tue,  9 Jun 2020 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725280;
        bh=phxy64nO8Wf40GLRS00pHWHki1XrTITKJ4PREB/auzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsOr1zwPPPxjEAiRKKztN/O2iKdi8W4W7UzGMlioO57X9pavHEs9ywqqC7dA/ds53
         Y8gJvrvID5FzkxvFe62S7y1Urj+TTOkUoulOTCYk4tjCjYFutsWBAX6q1uDiAs+ciT
         8jv1iUQou2fPeLnfFK9xXz3wsBEBd2jRlUS0WOGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 14/41] net: dsa: felix: send VLANs on CPU port as egress-tagged
Date:   Tue,  9 Jun 2020 19:45:16 +0200
Message-Id: <20200609174113.500646507@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 183be6f967fe37c3154bfac39e913c3bafe89d1b ]

As explained in other commits before (b9cd75e66895 and 87b0f983f66f),
ocelot switches have a single egress-untagged VLAN per port, and the
driver would deny adding a second one while an egress-untagged VLAN
already exists.

But on the CPU port (where the VLAN configuration is implicit, because
there is no net device for the bridge to control), the DSA core attempts
to add a VLAN using the same flags as were used for the front-panel
port. This would make adding any untagged VLAN fail due to the CPU port
rejecting the configuration:

bridge vlan add dev swp0 vid 100 pvid untagged
[ 1865.854253] mscc_felix 0000:00:00.5: Port already has a native VLAN: 1
[ 1865.860824] mscc_felix 0000:00:00.5: Failed to add VLAN 100 to port 5: -16

(note that port 5 is the CPU port and not the front-panel swp0).

So this hardware will send all VLANs as tagged towards the CPU.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -100,13 +100,17 @@ static void felix_vlan_add(struct dsa_sw
 			   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
+	u16 flags = vlan->flags;
 	u16 vid;
 	int err;
 
+	if (dsa_is_cpu_port(ds, port))
+		flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
+
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		err = ocelot_vlan_add(ocelot, port, vid,
-				      vlan->flags & BRIDGE_VLAN_INFO_PVID,
-				      vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+				      flags & BRIDGE_VLAN_INFO_PVID,
+				      flags & BRIDGE_VLAN_INFO_UNTAGGED);
 		if (err) {
 			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
 				vid, port, err);


