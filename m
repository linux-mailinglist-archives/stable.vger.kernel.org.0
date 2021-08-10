Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548CB3E810B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhHJRzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234993AbhHJRwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1464261212;
        Tue, 10 Aug 2021 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617399;
        bh=CuMbC4ASbHrw+7on6JtP5TU8DUXHrLiClPJZV3wyt4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmgrwMxbX0GtpzgGbiCDRRQbScNIOsAQQsS+YhWy9trrrXjzNAr1osrm/KeO8wjCZ
         4TxK755sOnpYz4WjJfM3SZBd+O6wx0pbYnLzVyDJ10Ezts0u9UPSofAKaQb7lyU072
         HhvO8skGtj4iRY3QqtOci+knrnuXI7v+D8bBa86I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 042/175] net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones
Date:   Tue, 10 Aug 2021 19:29:10 +0200
Message-Id: <20210810173002.335525132@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6c5fc159e0927531707895709eee1f8bfa04289f ]

The procedure to add a static FDB entry in sja1105 is concurrent with
dynamic learning performed on all bridge ports and the CPU port.

The switch looks up the FDB from left to right, and also learns
dynamically from left to right, so it is possible that between the
moment when we pick up a free slot to install an FDB entry, another slot
to the left of that one becomes free due to an address ageing out, and
that other slot is then immediately used by the switch to learn
dynamically the same address as we're trying to add statically.

The result is that we succeeded to add our static FDB entry, but it is
being shadowed by a dynamic FDB entry to its left, and the switch will
behave as if our static FDB entry did not exist.

We cannot really prevent this from happening unless we make the entire
process to add a static FDB entry a huge critical section where address
learning is temporarily disabled on _all_ ports, and then re-enabled
according to the configuration done by sja1105_port_set_learning.
However, that is kind of disruptive for the operation of the network.

What we can do alternatively is to simply read back the FDB for dynamic
entries located before our newly added static one, and delete them.
This will guarantee that our static FDB entry is now operational. It
will still not guarantee that there aren't dynamic FDB entries to the
_right_ of that static FDB entry, but at least those entries will age
out by themselves since they aren't hit, and won't bother anyone.

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 57 +++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c671d43a4724..5e88632e10b9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1308,10 +1308,11 @@ static int sja1105et_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
 int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		      const unsigned char *addr, u16 vid)
 {
-	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_l2_lookup_entry l2_lookup = {0}, tmp;
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
 	int last_unused = -1;
+	int start, end, i;
 	int bin, way, rc;
 
 	bin = sja1105et_fdb_hash(priv, addr, vid);
@@ -1363,6 +1364,29 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 	if (rc < 0)
 		return rc;
 
+	/* Invalidate a dynamically learned entry if that exists */
+	start = sja1105et_fdb_index(bin, 0);
+	end = sja1105et_fdb_index(bin, way);
+
+	for (i = start; i < end; i++) {
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						 i, &tmp);
+		if (rc == -ENOENT)
+			continue;
+		if (rc)
+			return rc;
+
+		if (tmp.macaddr != ether_addr_to_u64(addr) || tmp.vlanid != vid)
+			continue;
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+						  i, NULL, false);
+		if (rc)
+			return rc;
+
+		break;
+	}
+
 	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
@@ -1404,7 +1428,7 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid)
 {
-	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_l2_lookup_entry l2_lookup = {0}, tmp;
 	struct sja1105_private *priv = ds->priv;
 	int rc, i;
 
@@ -1462,6 +1486,35 @@ skip_finding_an_index:
 	if (rc < 0)
 		return rc;
 
+	/* The switch learns dynamic entries and looks up the FDB left to
+	 * right. It is possible that our addition was concurrent with the
+	 * dynamic learning of the same address, so now that the static entry
+	 * has been installed, we are certain that address learning for this
+	 * particular address has been turned off, so the dynamic entry either
+	 * is in the FDB at an index smaller than the static one, or isn't (it
+	 * can also be at a larger index, but in that case it is inactive
+	 * because the static FDB entry will match first, and the dynamic one
+	 * will eventually age out). Search for a dynamically learned address
+	 * prior to our static one and invalidate it.
+	 */
+	tmp = l2_lookup;
+
+	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+					 SJA1105_SEARCH, &tmp);
+	if (rc < 0) {
+		dev_err(ds->dev,
+			"port %d failed to read back entry for %pM vid %d: %pe\n",
+			port, addr, vid, ERR_PTR(rc));
+		return rc;
+	}
+
+	if (tmp.index < l2_lookup.index) {
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+						  tmp.index, NULL, false);
+		if (rc < 0)
+			return rc;
+	}
+
 	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
-- 
2.30.2



