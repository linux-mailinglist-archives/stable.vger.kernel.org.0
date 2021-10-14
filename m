Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27BE42DC55
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhJNO6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232323AbhJNO5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53D7061183;
        Thu, 14 Oct 2021 14:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223349;
        bh=sWaWquMstVZ/tf6YcQP+74XX8JCn6l1Yp706SCL3YwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0r2bTf0av8kUJ7CAjQ/6lm/rCRw80cndhQsfbrSsgE7MJMrMZc+jS4+cBID8rbQc
         SBRm6AytpG1w/db+JB7qKhxQ2U7PM08hGXfoJAQHPnq72uG9W0dXwUKKY81GvWs6Sq
         wWyVkUWs/BBSrF+64mvKfY+vQ5ulMykC9d77e5cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/25] net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
Date:   Thu, 14 Oct 2021 16:53:45 +0200
Message-Id: <20211014145208.027416738@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145207.575041491@linuxfoundation.org>
References: <20211014145207.575041491@linuxfoundation.org>
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
index 4f831225d34f..ca8757090ae3 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1298,7 +1298,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 	}
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
-	       nla_total_size(sizeof(struct br_mcast_stats)) +
+	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0



