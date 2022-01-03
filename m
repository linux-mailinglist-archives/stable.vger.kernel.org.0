Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2913483360
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiACOgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33898 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiACOcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:32:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD91D61120;
        Mon,  3 Jan 2022 14:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3990C36AF3;
        Mon,  3 Jan 2022 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220366;
        bh=RifEtkUqxRuMJrzn6sDhokpjTK6yc/FgFm4zxJ41hok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLU4d/WUXQPdkpEE4qfMvg3MML8KXzHpWGKijRU5Ot5Rc1eruwAt8giAZjQgNRHW9
         tczEZajGpiGQEmyaHVa2+wSiEb+tUESobnB7n60C0MyVPCPovNcPAFK7ara5UTHhqs
         RiPLnLbxwmHAliHnFYBAVWZYSTtBTDDGlVvaso5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/73] net: bridge: mcast: fix br_multicast_ctx_vlan_global_disabled helper
Date:   Mon,  3 Jan 2022 15:24:08 +0100
Message-Id: <20220103142058.430158925@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 168fed986b3a7ec7b98cab1fe84e2f282b9e6a8f ]

We need to first check if the context is a vlan one, then we need to
check the global bridge multicast vlan snooping flag, and finally the
vlan's multicast flag, otherwise we will unnecessarily enable vlan mcast
processing (e.g. querier timers).

Fixes: 7b54aaaf53cb ("net: bridge: multicast: add vlan state initialization and control")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20211228153142.536969-1-nikolay@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5951e3142fe94..bd218c2b2cd97 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1158,9 +1158,9 @@ br_multicast_port_ctx_get_global(const struct net_bridge_mcast_port *pmctx)
 static inline bool
 br_multicast_ctx_vlan_global_disabled(const struct net_bridge_mcast *brmctx)
 {
-	return br_opt_get(brmctx->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) &&
-	       br_multicast_ctx_is_vlan(brmctx) &&
-	       !(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED);
+	return br_multicast_ctx_is_vlan(brmctx) &&
+	       (!br_opt_get(brmctx->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) ||
+		!(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED));
 }
 
 static inline bool
-- 
2.34.1



