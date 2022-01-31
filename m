Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A094A4150
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358668AbiAaLDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358800AbiAaLCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50854C06136E;
        Mon, 31 Jan 2022 03:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E586460B28;
        Mon, 31 Jan 2022 11:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA944C340F0;
        Mon, 31 Jan 2022 11:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626855;
        bh=/JNizw2DE/Nlkh/hEPWIG7X7g8UTIItZA4wTHSrZrjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/jzkdWNXmXiTPXWFfBSpR4PMjawCu3c+VkTQv8BJcg5y2ZgXv5qw3nRKMCs5JlZf
         /zFufVZxB7UGv806EcKG3MUnbtvnxMGfmRHxsO56L2kutozvNlW4H6ff8HNGjedtaB
         Lg6ceGjYfKdWwzqRTBOwF5QZBNN0PRyxAwrLXdIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/64] ipv4: remove sparse error in ip_neigh_gw4()
Date:   Mon, 31 Jan 2022 11:56:46 +0100
Message-Id: <20220131105217.726529190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3c42b2019863b327caa233072c50739d4144dd16 ]

./include/net/route.h:373:48: warning: incorrect type in argument 2 (different base types)
./include/net/route.h:373:48:    expected unsigned int [usertype] key
./include/net/route.h:373:48:    got restricted __be32 [usertype] daddr

Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220127013404.1279313-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/route.h b/include/net/route.h
index 6c516840380db..b85d1912d84fd 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -359,7 +359,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
 	if (unlikely(!neigh))
 		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
 
-- 
2.34.1



