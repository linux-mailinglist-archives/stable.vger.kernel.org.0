Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB17042907D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243224AbhJKOJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57621 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240662AbhJKOHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D3EC6113D;
        Mon, 11 Oct 2021 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960833;
        bh=p8EIqganXBSgfIhwUEgVGdYWV4IIQSnmkjcbYmI7p4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztzIPdpxlk4QCf5qp9c1Nb6SPUJpZJOHm7ngrG9wCn2hVV7EoVaPa/qbiKnPOG8SB
         g9IXtpLbB8OuwXJuUYA57rLpe6Q+mGekFV/QjEQN0J2Afhjac0qbSW11k0Wf2JnHoO
         dsjlbWf5QSflJoVq0Yu0TEmereznqHaRu1IVswYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 089/151] net: bridge: fix under estimation in br_get_linkxstats_size()
Date:   Mon, 11 Oct 2021 15:46:01 +0200
Message-Id: <20211011134520.712387374@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 69c0002f413f..2abfbd4b8a15 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1658,6 +1658,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
 	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
+	       (p ? nla_total_size_64bit(sizeof(p->stp_xstats)) : 0) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0



