Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3644C3E8109
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhHJRzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235196AbhHJRwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E343D600CD;
        Tue, 10 Aug 2021 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617408;
        bh=BhDQJDPccAjt+ix6W+2EKZ1ujkyoqWXiKZ+4ToL/7Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2JJ3Cf8iFJoNXzr4ubgON8j5rI7Lh+vYv+pOd//agufx+1THYL1S9xHMtTno3GGo
         lbTvhgQHFvD06E95FUMtVzfoI6J8jkVc0GGS0ecimxeEjgT0YhiJG+L5BgemNCdfXv
         eSEbV8UQEBJlu1P89aQhFlbOaDSU+C2UJUqY7SBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 045/175] net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag
Date:   Tue, 10 Aug 2021 19:29:13 +0200
Message-Id: <20210810173002.433410131@linuxfoundation.org>
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

[ Upstream commit 47c2c0c2312118a478f738503781de1d1a6020d2 ]

On SJA1105P/Q/R/S and SJA1110, the L2 Lookup Table entries contain a
maskable "inner/outer tag" bit which means:
- when set to 1: match single-outer and double tagged frames
- when set to 0: match untagged and single-inner tagged frames
- when masked off: match all frames regardless of the type of tag

This driver does not make any meaningful distinction between inner tags
(matches on TPID) and outer tags (matches on TPID2). In fact, all VLAN
table entries are installed as SJA1110_VLAN_D_TAG, which means that they
match on both inner and outer tags.

So it does not make sense that we install FDB entries with the IOTAG bit
set to 1.

In VLAN-unaware mode, we set both TPID and TPID2 to 0xdadb, so the
switch will see frames as outer-tagged or double-tagged (never inner).
So the FDB entries will match if IOTAG is set to 1.

In VLAN-aware mode, we set TPID to 0x8100 and TPID2 to 0x88a8. So the
switch will see untagged and 802.1Q-tagged packets as inner-tagged, and
802.1ad-tagged packets as outer-tagged. So untagged and 802.1Q-tagged
packets will not match FDB entries if IOTAG is set to 1, but 802.1ad
tagged packets will. Strange.

To fix this, simply mask off the IOTAG bit from FDB entries, and make
them match regardless of whether the VLAN tag is inner or outer.

Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 19d321ac6532..4b05a2424623 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1435,10 +1435,8 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	/* Search for an existing entry in the FDB table */
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
-	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	tmp = l2_lookup;
@@ -1528,10 +1526,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
-	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-- 
2.30.2



