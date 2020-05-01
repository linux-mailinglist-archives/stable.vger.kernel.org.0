Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71401C151B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbgEANpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731904AbgEANpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9C920757;
        Fri,  1 May 2020 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340716;
        bh=t6QrlUuqm7H12f/LEkP2lMqOz6UI8P+PkX2WkGbdVLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BG/obyQfqY0I6wy2glMBa9lP5/Br6rXRIy4IKQGb417h4OUFgRCmALOq5tdfIrNAz
         23+Kmbq8aR0PxQ939q+WwU86IH2TpkojBQ0kqM2hHPNk8i4ndzRCYyeChM/ssU0BRr
         /28W3yrHXt22y8OKcQfA/lNJPw2tf/khKagp9WXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tamizh chelvam <tamizhr@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 085/106] mac80211: fix channel switch trigger from unknown mesh peer
Date:   Fri,  1 May 2020 15:23:58 +0200
Message-Id: <20200501131553.836958250@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tamizh chelvam <tamizhr@codeaurora.org>

[ Upstream commit 93e2d04a1888668183f3fb48666e90b9b31d29e6 ]

Previously mesh channel switch happens if beacon contains
CSA IE without checking the mesh peer info. Due to that
channel switch happens even if the beacon is not from
its own mesh peer. Fixing that by checking if the CSA
originated from the same mesh network before proceeding
for channel switch.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Link: https://lore.kernel.org/r/1585403604-29274-1-git-send-email-tamizhr@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d09b3c789314d..36978a0e50001 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1257,15 +1257,15 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
 			mesh_neighbour_update(sdata, mgmt->sa, &elems,
 					      rx_status);
+
+		if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
+		    !sdata->vif.csa_active)
+			ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 	}
 
 	if (ifmsh->sync_ops)
 		ifmsh->sync_ops->rx_bcn_presp(sdata,
 			stype, mgmt, &elems, rx_status);
-
-	if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
-	    !sdata->vif.csa_active)
-		ieee80211_mesh_process_chnswitch(sdata, &elems, true);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1373,6 +1373,9 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(pos, len - baselen, true, &elems,
 			       mgmt->bssid, NULL);
 
+	if (!mesh_matches_local(sdata, &elems))
+		return;
+
 	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
-- 
2.20.1



