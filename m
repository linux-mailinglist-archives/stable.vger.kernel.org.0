Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F4411D8D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349015AbhITRVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348493AbhITRT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1A861A54;
        Mon, 20 Sep 2021 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157211;
        bh=ADblYM3WS4+RhF6KwGVshdfH+T3cB1VhJK8CEi2fRYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGkTgwcV8cTuZiZJVt0iakwaCJ2t4A5eQs4VFtZSHryyAxcnnTHWJkwBQepuO2G7U
         IJ3P1xsKK4uT/+fmvwGPVH0MXRUCpsCb1/gBI+H5POdKp/PO6XGlhyaI5SAf3Q+q8X
         bHCH5u98R0rcK1S5vzpg8e6jvxS6CTYjstStF4RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Kang Chang <gary.chang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/217] mac80211: Fix insufficient headroom issue for AMSDU
Date:   Mon, 20 Sep 2021 18:41:34 +0200
Message-Id: <20210920163927.097991575@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit f50d2ff8f016b79a2ff4acd5943a1eda40c545d4 ]

ieee80211_amsdu_realloc_pad() fails to account for extra_tx_headroom,
the original reserved headroom might be eaten. Add the necessary
extra_tx_headroom.

Fixes: 6e0456b54545 ("mac80211: add A-MSDU tx support")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20210816085128.10931-2-pkshih@realtek.com
[fix indentation]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c7e8935224c0..e7b63ba8c184 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3080,7 +3080,9 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
 		return true;
 
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(*amsdu_hdr)))
+	if (!ieee80211_amsdu_realloc_pad(local, skb,
+					 sizeof(*amsdu_hdr) +
+					 local->hw.extra_tx_headroom))
 		return false;
 
 	data = skb_push(skb, sizeof(*amsdu_hdr));
-- 
2.30.2



