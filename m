Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9635A3ED686
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhHPNVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240651AbhHPNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EECF632C5;
        Mon, 16 Aug 2021 13:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119712;
        bh=kAnqGYLajYNlCcsfuaLy8ZmPfiFFgbhWALTVdS3LdKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bz7uYvkyXNUeX5E8h9MsXMmAB158FlRBDE8cNPaov8jhAgTv6Zs2CifXcylJkOc4n
         xKW+DJ7wMRHyjmSwG+PClR0/xbeGT8tBjU0oyEJ7ttOvUoTGWOFPz+bmBH4ADyT8Fz
         ftBkrFG54tqXosa2cQWnJneujPfus6nLJq8lk274=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 100/151] net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
Date:   Mon, 16 Aug 2021 15:02:10 +0200
Message-Id: <20210816125447.372901010@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit cd391280bf4693ceddca8f19042cff42f98c1a89 ]

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

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4d78219da253..50109218baad 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -912,6 +912,7 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 {
 	struct hellcreek *hellcreek = ds->priv;
 	u16 entries;
+	int ret = 0;
 	size_t i;
 
 	mutex_lock(&hellcreek->reg_lock);
@@ -944,12 +945,14 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 		if (!(entry.portmask & BIT(port)))
 			continue;
 
-		cb(entry.mac, 0, entry.is_static, data);
+		ret = cb(entry.mac, 0, entry.is_static, data);
+		if (ret)
+			break;
 	}
 
 	mutex_unlock(&hellcreek->reg_lock);
 
-	return 0;
+	return ret;
 }
 
 static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
-- 
2.30.2



