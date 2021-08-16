Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7433ED4B1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhHPNFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236742AbhHPNEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18E16329F;
        Mon, 16 Aug 2021 13:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119055;
        bh=/qdlWZ6rnPDmYmM2mQ/qaFs31uYRuuKtfbvzC0cRV8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2jE85UX61UZ9FnOBinGqQnDy+mLuLiYDzkrmOvqQ3fjXRCr0ao57SSZo3k32OchX
         1rYckEaEX9mMsND1Naqu9ddCEIyfwyo80C3YEic2vgoZCR2V5wOwSOEiN8ZIaV0Mck
         Livjlznq6Tl65yXjAgCIN/ohcoSzd2srg3SmL2zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/62] net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
Date:   Mon, 16 Aug 2021 15:02:05 +0200
Message-Id: <20210816125429.330949031@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
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
index a07d8051ec3e..eab861352bf2 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1312,7 +1312,9 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		/* We need to hide the dsa_8021q VLANs from the user. */
 		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
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



