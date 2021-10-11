Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FDD428EF7
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhJKNxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236486AbhJKNwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B34C361078;
        Mon, 11 Oct 2021 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960232;
        bh=TuC5ZZ5nDUaTlNvLHC8R4HdzG4bjO5PQWafZAqtPmW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQPpYT4+TK5A+Yzv1rALf7tYbSlK04FY6jZ2jS/iecK+Sbu1D5zvyTilohcStu09c
         c22UOvKOMYckjV/nRAs5qraQWNiu+xtS3VWhC5gX2/UPwR0HPTvDKYix3dpeFoj06H
         Y4nF9j/cV8TcesXFhh8hoOYiZM1fykOFkMxUMpZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/52] net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
Date:   Mon, 11 Oct 2021 15:46:02 +0200
Message-Id: <20211011134504.869490172@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
index 8a664148f57a..cbcbc19efcb3 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1536,7 +1536,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
 	}
 
 	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
-	       nla_total_size(sizeof(struct br_mcast_stats)) +
+	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
 	       nla_total_size(0);
 }
 
-- 
2.33.0



