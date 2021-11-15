Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0B45140B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348916AbhKOUAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344185AbhKOTYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA4E63478;
        Mon, 15 Nov 2021 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002400;
        bh=k1kcdyPnokAmjTWnwFNtH05VwvYs8bm4sjIfymJgdnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFFZAvyTLFMilY1GGrZ5q4HqDugMnuUCPc3zOIdNWpvaSpi8tnJ6yyuRcrav5fswE
         GvTPkCbv1YFHxFzUq0CmZd2BoR2FC6NVIh1YEi+8QDE1DdwXzII5OfREMLDjA0nhW+
         ul5SDiq3my5AJVpQdLoz85QwLT98NkEv4o4h2pH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/917] net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled
Date:   Mon, 15 Nov 2021 18:00:46 +0100
Message-Id: <20211115165447.466323240@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 829e050eea69c7442441b714b6f5b339b5b8c367 ]

Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
that return a count. When BRIDGE_CFM is not enabled these functions
simply return -EOPNOTSUPP but do not modify count parameter and
calling function then works with uninitialized variables.
Modify these inline functions to return zero in count parameter.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Cc: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 37ca76406f1e8..fd5e7e74573ce 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1911,11 +1911,13 @@ static inline int br_cfm_status_fill_info(struct sk_buff *skb,
 
 static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 
 static inline int br_cfm_peer_mep_count(struct net_bridge *br, u32 *count)
 {
+	*count = 0;
 	return -EOPNOTSUPP;
 }
 #endif
-- 
2.33.0



