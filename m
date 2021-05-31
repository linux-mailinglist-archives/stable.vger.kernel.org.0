Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D579395CD0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhEaNiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231990AbhEaNfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7ED561401;
        Mon, 31 May 2021 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467526;
        bh=891bHmpN95ZD6fwRgVJVLBZFvKFAEX193O2rvDRXrio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zuqHMJky8/woai5YVDh+/guL1rLeY29JZuuw8c24wOSflCR4zbMLDzDEKnoYDYqwz
         bMKUEB+cFO5myRanpskqqQ7ut/YB1Gv584tGI10b3lMKHeSdHTGaXI0IstP0migl4m
         JAMKVRI1KlKuBDjP1AEeMIXPkUQbyZa/BezfpeDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/116] net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count
Date:   Mon, 31 May 2021 15:14:33 +0200
Message-Id: <20210531130643.424966581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b94cbc909f1d80378a1f541968309e5c1178c98b ]

DSA implements a bunch of 'standardized' ethtool statistics counters,
namely tx_packets, tx_bytes, rx_packets, rx_bytes. So whatever the
hardware driver returns in .get_sset_count(), we need to add 4 to that.

That is ok, except that .get_sset_count() can return a negative error
code, for example:

b53_get_sset_count
-> phy_ethtool_get_sset_count
   -> return -EIO

-EIO is -5, and with 4 added to it, it becomes -1, aka -EPERM. One can
imagine that certain error codes may even become positive, although
based on code inspection I did not see instances of that.

Check the error code first, if it is negative return it as-is.

Based on a similar patch for dsa_master_get_strings from Dan Carpenter:
https://patchwork.kernel.org/project/netdevbpf/patch/YJaSe3RPgn7gKxZv@mwanda/

Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 11f1560de639..b887d9edb9c3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -598,13 +598,15 @@ static int dsa_slave_get_sset_count(struct net_device *dev, int sset)
 	struct dsa_switch *ds = dp->ds;
 
 	if (sset == ETH_SS_STATS) {
-		int count;
+		int count = 0;
 
-		count = 4;
-		if (ds->ops->get_sset_count)
-			count += ds->ops->get_sset_count(ds, dp->index, sset);
+		if (ds->ops->get_sset_count) {
+			count = ds->ops->get_sset_count(ds, dp->index, sset);
+			if (count < 0)
+				return count;
+		}
 
-		return count;
+		return count + 4;
 	}
 
 	return -EOPNOTSUPP;
-- 
2.30.2



