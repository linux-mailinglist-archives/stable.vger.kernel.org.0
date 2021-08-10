Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC4A3E8011
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhHJRqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236135AbhHJRoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4124361153;
        Tue, 10 Aug 2021 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617173;
        bh=rDS+T/bSYJHtSBoCHfROASL+OmGu6kaC/U4rdsey30s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFFRThDy8/X9NhcGPc4qezXTxyua4F6bYg/C5JCXIfb0wzOvR1+/CqAKYDIp1MY/O
         fDlyBDC+KEr+aPJtOYamt29/E05gbDB9t/k0UETKSdxo9lPhPo71n9gMUTfMN0Ylwm
         sAfGOFx4C/r79InelGb4Y8XwnXhGO3gNLT2SJBvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/135] net: dsa: sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too
Date:   Tue, 10 Aug 2021 19:29:27 +0200
Message-Id: <20210810172956.791232073@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 589918df93226a1e5f104306c185b6dcf2bd8051 ]

Similar but not quite the same with what was done in commit b11f0a4c0c81
("net: dsa: sja1105: be stateless when installing FDB entries") for
SJA1105E/T, it is desirable to drop the priv->vlan_aware check and
simply go ahead and install FDB entries in the VLAN that was given by
the bridge.

As opposed to SJA1105E/T, in SJA1105P/Q/R/S and SJA1110, the FDB is a
maskable TCAM, and we are installing VLAN-unaware FDB entries with the
VLAN ID masked off. However, such FDB entries might completely obscure
VLAN-aware entries where the VLAN ID is included in the search mask,
because the switch looks up the FDB from left to right and picks the
first entry which results in a masked match. So it depends on whether
the bridge installs first the VLAN-unaware or the VLAN-aware FDB entries.

Anyway, if we had a VLAN-unaware FDB entry towards one set of DESTPORTS
and a VLAN-aware one towards other set of DESTPORTS, the result is that
the packets in VLAN-aware mode will be forwarded towards the DESTPORTS
specified by the VLAN-unaware entry.

To solve this, simply do not use the masked matching ability of the FDB
for VLAN ID, and always match precisely on it. In VLAN-unaware mode, we
configure the switch for shared VLAN learning, so the VLAN ID will be
ignored anyway during lookup, so it is redundant to mask it off in the
TCAM.

This patch conflicts with net-next commit 0fac6aa098ed ("net: dsa: sja1105:
delete the best_effort_vlan_filtering mode") which changed this line:
	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
into:
	if (priv->vlan_aware) {

When merging with net-next, the lines added by this patch should take
precedence in the conflict resolution (i.e. the "if" condition should be
deleted in both cases).

Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 52d8cc1a95fa..e65be1380803 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1389,13 +1389,8 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
-		l2_lookup.mask_vlanid = VLAN_VID_MASK;
-		l2_lookup.mask_iotag = BIT(0);
-	} else {
-		l2_lookup.mask_vlanid = 0;
-		l2_lookup.mask_iotag = 0;
-	}
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
@@ -1482,13 +1477,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
-		l2_lookup.mask_vlanid = VLAN_VID_MASK;
-		l2_lookup.mask_iotag = BIT(0);
-	} else {
-		l2_lookup.mask_vlanid = 0;
-		l2_lookup.mask_iotag = 0;
-	}
+	l2_lookup.mask_vlanid = VLAN_VID_MASK;
+	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-- 
2.30.2



