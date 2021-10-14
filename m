Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6035142DC98
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhJNPAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232406AbhJNO7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1699E60E97;
        Thu, 14 Oct 2021 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223427;
        bh=zucOki2Nq/ooBU1V28C0oTcLPgXu2BJvSfjaQpbCCTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFxZa07GS67nqiuFL6QVSJl3w/2HQMMo+Y+/fxT6VVmTgc6Mtmo+G50cVjU0W2prJ
         dSvd9rftAQiP3ei9NChTRj5N7n+H7ecUUWCDeDuoNAdErlBwfuUiBYxsgC7cQLgIIa
         Nrg5L59/EQZEB/dRikeihQRd0Zkkcx0C4gE7W1sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/33] net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
Date:   Thu, 14 Oct 2021 16:53:50 +0200
Message-Id: <20211014145209.395932335@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dbe0b88064494b7bb6a9b2aa7e085b14a3112d44 ]

bridge_fill_linkxstats() is using nla_reserve_64bit().

We must use nla_total_size_64bit() instead of nla_total_size()
for corresponding data structure.

Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 08190db0a2dc..79e306ec1416 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1437,7 +1437,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 	}
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
-	       nla_total_size(sizeof(struct br_mcast_stats)) +
+	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0



