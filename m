Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434C94A4265
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359593AbiAaLLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377043AbiAaLJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289ECC0604C2;
        Mon, 31 Jan 2022 03:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB087B82A71;
        Mon, 31 Jan 2022 11:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B50C340E8;
        Mon, 31 Jan 2022 11:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627169;
        bh=RU/aoYH9VVAzoILzyFoXl7OLpyGsCBshNoSXoZibb58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOMDMKGSBObc2qqfBg7hFwSY2MMf6DTFE5pRkwLCz0Gl/t0VUdZDUNbi35Msx7jeF
         rjKsSkViATkAw7cOPA+p1OH4AlQkcrc6+UV8gMTSFOwclZ0xqC11NXY15QtwDLb2Vi
         LuBhn3ygnG4i4/cN9VDEG7gIcl99hW5lMW3/YdKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Yi <tim.yi@pica8.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/100] net: bridge: vlan: fix memory leak in __allowed_ingress
Date:   Mon, 31 Jan 2022 11:56:57 +0100
Message-Id: <20220131105223.675973580@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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
index 1f508d998fb2d..852f4b54e8811 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -543,10 +543,10 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		if (!br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) {
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



