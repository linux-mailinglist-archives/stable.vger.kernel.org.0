Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0BB428F5B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhJKN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238066AbhJKNzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D7761108;
        Mon, 11 Oct 2021 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960393;
        bh=Kyzx9gzkhlh9cQvf98cQU5z7YWyKKORuGEOaduWYYeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tt1p1x4gy+YQkzyNuGZdvouYp5tqoyW3zEkyK7c7+Nx9WEZKPiEY0xaIep8WE4ppU
         H1AKhhAiEHJ3KleDfZ7RhaYkZio1q28oA64+TrNNlJahlLA7gjZHC+/LjboEwYp3ON
         LvYFeK57hYKT9IV3ZqwzI8ezJoZ/MxTeCU37Ad7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/83] net: bridge: fix under estimation in br_get_linkxstats_size()
Date:   Mon, 11 Oct 2021 15:46:08 +0200
Message-Id: <20211011134510.050199985@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0854a0513321cf70bea5fa483ebcaa983cc7c62e ]

Commit de1799667b00 ("net: bridge: add STP xstats")
added an additional nla_reserve_64bit() in br_fill_linkxstats(),
but forgot to update br_get_linkxstats_size() accordingly.

This can trigger the following in rtnl_stats_get()

	WARN_ON(err == -EMSGSIZE);

Fixes: de1799667b00 ("net: bridge: add STP xstats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index bfe6ab1914c8..31b00ba5dcc8 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1591,6 +1591,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
 	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
+	       (p ? nla_total_size_64bit(sizeof(p->stp_xstats)) : 0) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0



