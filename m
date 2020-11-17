Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B338E2B6524
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbgKQNv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbgKQNao (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4965420781;
        Tue, 17 Nov 2020 13:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619844;
        bh=cbFw7fZXmmag279UZnQGkQqUWaLeGr3nXZCkLbCTL/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od60M0UGtQxQXn+S11ua4bYIl3XnQTYbZuPXsSb8J7tYfbcIY3YABxQSTnspQCZTJ
         wubxSEGioqlPRiw1HMkUQCW+nWuwTcdIxIJe2J+sgGEZC+p2oM6y4AEXoBMyUtTLiI
         l+Q7jHcyLWxEnxgg4TpGYbTcXUYsP8kgmPAE7mJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 022/255] mac80211: dont require VHT elements for HE on 2.4 GHz
Date:   Tue, 17 Nov 2020 14:02:42 +0100
Message-Id: <20201117122140.023541783@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c2f46814521113f6699a74e0a0424cbc5b305479 ]

After the previous similar bugfix there was another bug here,
if no VHT elements were found we also disabled HE. Fix this to
disable HE only on the 5 GHz band; on 6 GHz it was already not
disabled, and on 2.4 GHz there need (should) not be any VHT.

Fixes: 57fa5e85d53c ("mac80211: determine chandef from HE 6 GHz operation")
Link: https://lore.kernel.org/r/20201013140156.535a2fc6192f.Id6e5e525a60ac18d245d86f4015f1b271fce6ee6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2e400b0ff6961..0f30f50c46b1b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5359,6 +5359,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
 	bool is_6ghz = req->bss->channel->band == NL80211_BAND_6GHZ;
+	bool is_5ghz = req->bss->channel->band == NL80211_BAND_5GHZ;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
@@ -5507,7 +5508,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (vht_ie && vht_ie[1] >= sizeof(struct ieee80211_vht_cap))
 		memcpy(&assoc_data->ap_vht_cap, vht_ie + 2,
 		       sizeof(struct ieee80211_vht_cap));
-	else if (!is_6ghz)
+	else if (is_5ghz)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT |
 				IEEE80211_STA_DISABLE_HE;
 	rcu_read_unlock();
-- 
2.27.0



