Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF924A4304
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358895AbiAaLQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:16:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34120 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359006AbiAaLOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FF69B82A64;
        Mon, 31 Jan 2022 11:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AEAC340E8;
        Mon, 31 Jan 2022 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627673;
        bh=99WXz5UJ2KQSkBJVIoXmnyEOcDHEt1YaAxIJSmIyad0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNo0loOflPfeQboxWdjGOum4Levpvmg+HuqWU1Mo+j496+ew/rc4HICVeO7F3Il6b
         HKEH12lqdb2FGOF/KUIXQ6x9mm1G7M0xt1URXBQ5gydFWtIgwFAUGHOet0nzv/JOSa
         l05qJq+nLpn3TezsccDpEac8N3f7UROtJl8Gmv54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Yi <tim.yi@pica8.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/171] net: bridge: vlan: fix memory leak in __allowed_ingress
Date:   Mon, 31 Jan 2022 11:57:05 +0100
Message-Id: <20220131105235.432187773@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Yi <tim.yi@pica8.com>

[ Upstream commit fd20d9738395cf8e27d0a17eba34169699fccdff ]

When using per-vlan state, if vlan snooping and stats are disabled,
untagged or priority-tagged ingress frame will go to check pvid state.
If the port state is forwarding and the pvid state is not
learning/forwarding, untagged or priority-tagged frame will be dropped
but skb memory is not freed.
Should free skb when __allowed_ingress returns false.

Fixes: a580c76d534c ("net: bridge: vlan: add per-vlan state")
Signed-off-by: Tim Yi <tim.yi@pica8.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20220127074953.12632-1-tim.yi@pica8.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 06f5caee495aa..10e63ea6a13e1 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -560,10 +560,10 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		    !br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
 			if (*state == BR_STATE_FORWARDING) {
 				*state = br_vlan_get_pvid_state(vg);
-				return br_vlan_state_allowed(*state, true);
-			} else {
-				return true;
+				if (!br_vlan_state_allowed(*state, true))
+					goto drop;
 			}
+			return true;
 		}
 	}
 	v = br_vlan_find(vg, *vid);
-- 
2.34.1



