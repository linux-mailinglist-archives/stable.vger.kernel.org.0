Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7770429157
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbhJKORc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244394AbhJKOPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:15:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F48E6135A;
        Mon, 11 Oct 2021 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961121;
        bh=670TjurDcEU5M/I1uMhLiuLmgmXJiTzK4Np0a9rCzvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkLaw5QPzKbHgqyJHsDCoUj6jtUJCJK68YuuWs02R5amBp0NUNnHn/EjiED1omnBY
         XAb1osRizDqqm3hJJbUM1uoxGMP5qOPs4saIPjahTh+7AnpKJuMxjC7RXsQskxfRmK
         RqK6nAAZsCHGidV+3eCZqlVY3jMpg9hOrXKYvlD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/28] rtnetlink: fix if_nlmsg_stats_size() under estimation
Date:   Mon, 11 Oct 2021 15:47:13 +0200
Message-Id: <20211011134641.466976541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d34367991933d28bd7331f67a759be9a8c474014 ]

rtnl_fill_statsinfo() is filling skb with one mandatory if_stats_msg structure.

nlmsg_put(skb, pid, seq, type, sizeof(struct if_stats_msg), flags);

But if_nlmsg_stats_size() never considered the needed storage.

This bug did not show up because alloc_skb(X) allocates skb with
extra tailroom, because of added alignments. This could very well
be changed in the future to have deterministic behavior.

Fixes: 10c9ead9f3c6 ("rtnetlink: add new RTM_GETSTATS message to dump link stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 055fd09ac111..83de32e34bb5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4512,7 +4512,7 @@ nla_put_failure:
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
 				  u32 filter_mask)
 {
-	size_t size = 0;
+	size_t size = NLMSG_ALIGN(sizeof(struct if_stats_msg));
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_64, 0))
 		size += nla_total_size_64bit(sizeof(struct rtnl_link_stats64));
-- 
2.33.0



