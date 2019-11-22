Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA45106E0E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbfKVLFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731085AbfKVLFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB27C2070E;
        Fri, 22 Nov 2019 11:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420742;
        bh=PP0VoN0gfOnQZCCZJ3I7rIYd7iS6ObVjGVuvpnxLw1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcRHX3GYLT4tLDjenrnDcswV02qWA0Lb4UkSEZkTU05Lw912R3XmQlvRsyHNTi0wz
         vDVtqDY4JUgzVi1AVX7wb8pklF2a+RGg6bGmoQixH1N/ohr9OPv8d7/uIj9GIlFYu4
         31Vp+B6NaRHgnXhAXwgwARAZm8huUVViC+KuA8vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/220] mac80211: minstrel: fix using short preamble CCK rates on HT clients
Date:   Fri, 22 Nov 2019 11:29:33 +0100
Message-Id: <20191122100928.718088746@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 37439f2d6e43ae79e22be9be159f0af157468f82 ]

mi->supported[MINSTREL_CCK_GROUP] needs to be updated
short preamble rates need to be marked as supported regardless of
whether it's currently enabled. Its state can change at any time without
a rate_update call.

Fixes: 782dda00ab8e ("mac80211: minstrel_ht: move short preamble check out of get_rate")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 67ebdeaffbbc8..ae1a180d2eee3 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1132,7 +1132,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
 	u16 sta_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
-	struct sta_info *sinfo = container_of(sta, struct sta_info, sta);
 	int use_vht;
 	int n_supported = 0;
 	int ack_dur;
@@ -1258,8 +1257,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	if (!n_supported)
 		goto use_legacy;
 
-	if (test_sta_flag(sinfo, WLAN_STA_SHORT_PREAMBLE))
-		mi->cck_supported_short |= mi->cck_supported_short << 4;
+	mi->supported[MINSTREL_CCK_GROUP] |= mi->cck_supported_short << 4;
 
 	/* create an initial rate table with the lowest supported rates */
 	minstrel_ht_update_stats(mp, mi);
-- 
2.20.1



