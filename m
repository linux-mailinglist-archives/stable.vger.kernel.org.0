Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B963ED687
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239367AbhHPNV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240656AbhHPNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77941632CD;
        Mon, 16 Aug 2021 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119717;
        bh=u3aC0WlkHwHUxv5QOQjX/DflPSIcjW/7B8GDa3abAqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y61BdJKfPQ1S5RlvTZ61CXiA6LblxUxSn5YcO2DrnesJk3Iq4Evyfis6JzHTx8hN1
         KHhdbdjnIm5OvwkApyw1mGkaGU9Egbbj0AtMp6YtXUpm5RE5fbfREM2bDq+KfcArNw
         4EBFTLAph8NfHoeuB79YyaQzCWuIfU4hjyzCGY7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 102/151] net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
Date:   Mon, 16 Aug 2021 15:02:12 +0200
Message-Id: <20210816125447.442562570@linuxfoundation.org>
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

[ Upstream commit 871a73a1c8f55da0a3db234e9dd816ea4fd546f2 ]

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

Fixes: 58c59ef9e930 ("net: dsa: lantiq: Add Forwarding Database access")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 314ae78bbdd6..e78026ef6d8c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1404,11 +1404,17 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 		addr[1] = mac_bridge.key[2] & 0xff;
 		addr[0] = (mac_bridge.key[2] >> 8) & 0xff;
 		if (mac_bridge.val[1] & GSWIP_TABLE_MAC_BRIDGE_STATIC) {
-			if (mac_bridge.val[0] & BIT(port))
-				cb(addr, 0, true, data);
+			if (mac_bridge.val[0] & BIT(port)) {
+				err = cb(addr, 0, true, data);
+				if (err)
+					return err;
+			}
 		} else {
-			if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) == port)
-				cb(addr, 0, false, data);
+			if (((mac_bridge.val[0] & GENMASK(7, 4)) >> 4) == port) {
+				err = cb(addr, 0, false, data);
+				if (err)
+					return err;
+			}
 		}
 	}
 	return 0;
-- 
2.30.2



