Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58A409526
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343818AbhIMOiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345450AbhIMOgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:36:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9F161BD3;
        Mon, 13 Sep 2021 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541232;
        bh=iJmkxdP9a+uM6MXxWtufDqdkKFCdZNsCVbh00mj8EGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBSa21HVGsz6SCiFPjzkMIgFeYWVoRnNblbjrOKBEEb1KacbS3zYvNqrAk9poWp/s
         NzC97i4y3loiILwelOu0xp7CLJ3Q31kNEYSDIHCz2XJ4DIsnmn/yGCeXd2ufy3+nE7
         5hd0aJxWbn78r22HUCh3/22X/TaCsVqOHeOVXYnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chih-Kang Chang <gary.chang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 217/334] mac80211: Fix insufficient headroom issue for AMSDU
Date:   Mon, 13 Sep 2021 15:14:31 +0200
Message-Id: <20210913131120.755565771@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 8509778ff31f..fa09a369214d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3242,7 +3242,9 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
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



