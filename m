Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3433ED546
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237867AbhHPNKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhHPNJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67AEF610A0;
        Mon, 16 Aug 2021 13:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119269;
        bh=G6c9ewwS1dYqYBPz05GBhktHfN0y2HFkGjgLrWlI4Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3uVhoKDm4HkELAhyll+18dP2+DLb0fLjU0ENG6t7O4A+COKvUXbgibIN/Wb0sd5z
         k318RTcLWL0Lv46ZcPbqoXeIqyHLgrOM3RRMkD6u/0c0ner9t/9jZt/AM8857GIkLI
         nR7QEQCMiZxZmIG65kGtRf7f20spm2ii5pgRkUMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/96] net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
Date:   Mon, 16 Aug 2021 15:02:07 +0200
Message-Id: <20210816125436.853865220@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 21b52fed928e96d2f75d2f6aa9eac7a4b0b55d22 ]

rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
multiple netlink skbs if the buffer provided by user space is too small
(one buffer will typically handle a few hundred FDB entries).

When the current buffer becomes full, nlmsg_put() in
dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
point, and then the dump resumes on the same port with a new skb, and
FDB entries up to the saved index are simply skipped.

Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
drivers, then drivers must check for the -EMSGSIZE error code returned
by it. Otherwise, when a netlink skb becomes full, DSA will no longer
save newly dumped FDB entries to it, but the driver will continue
dumping. So FDB entries will be missing from the dump.

Fix the broken backpressure by propagating the "cb" return code and
allow rtnl_fdb_dump() to restart the FDB dump with a new skb.

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 855371fcbf85..c03d76c10868 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1566,7 +1566,9 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		/* We need to hide the dsa_8021q VLANs from the user. */
 		if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
 			l2_lookup.vlanid = 0;
-		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
+		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
+		if (rc)
+			return rc;
 	}
 	return 0;
 }
-- 
2.30.2



