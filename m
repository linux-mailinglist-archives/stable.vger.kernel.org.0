Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBD428EDA
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbhJKNwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237179AbhJKNv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53DE360E78;
        Mon, 11 Oct 2021 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960166;
        bh=3/QReXRSeAKxehflE55cwE51/yzs/olITV8ZRFQgeJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD9VSk06L69+Ypp4strrvJeBNqGlC78vy9hEfbiuv3joK1mU8ChS7xGXGa2ZVFd8T
         cgJ2tP3l6ut8BmSAw2yPX10kmHsQXcZZEsoF1DS8x7WOcLGGkYpjK5d7rS/X2Fi9O/
         PAknG3w0me++vKv/PPWAZc5JN1m8hlV+5XeCLHpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/52] rtnetlink: fix if_nlmsg_stats_size() under estimation
Date:   Mon, 11 Oct 2021 15:46:10 +0200
Message-Id: <20211011134505.131880250@linuxfoundation.org>
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
index 6fbc9cb09dc0..a53b101ce41a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4950,7 +4950,7 @@ nla_put_failure:
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
 				  u32 filter_mask)
 {
-	size_t size = 0;
+	size_t size = NLMSG_ALIGN(sizeof(struct if_stats_msg));
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_64, 0))
 		size += nla_total_size_64bit(sizeof(struct rtnl_link_stats64));
-- 
2.33.0



