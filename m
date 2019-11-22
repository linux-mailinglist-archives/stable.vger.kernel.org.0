Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070B4106F00
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbfKVKzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbfKVKzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:55:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 585122071C;
        Fri, 22 Nov 2019 10:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420106;
        bh=Fq/yIuL9dKOTU0E1sOLDaD+7dLeb3Xgyd2LlguKHxZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmO0yVdfIyDS2Q31VxhtOaf7NanjGWRbeTj+0Un/YEeU6u7z+3OXlLIxjCbJIDVN9
         +wMyx1nC2gzT/wwWHio4dalL6avBpUh28b7qYiTguATQwWZqtiTajHbBuwqhLhCrO0
         WvEPc5jhiC8Z8gDn2IIrVwR3/mhq1/o2nuflbhL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/122] mac80211: minstrel: fix sampling/reporting of CCK rates in HT mode
Date:   Fri, 22 Nov 2019 11:29:29 +0100
Message-Id: <20191122100836.397252290@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 972b66b86f85f4e8201db454f4c3e9d990cf9836 ]

Long/short preamble selection cannot be sampled separately, since it
depends on the BSS state. Because of that, sampling attempts to
currently not used preamble modes are not counted in the statistics,
which leads to CCK rates being sampled too often.

Fix statistics accounting for long/short preamble by increasing the
index where necessary.
Fix excessive CCK rate sampling by dropping unsupported sample attempts.

This improves throughput on 2.4 GHz channels

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index bc97d31907f60..e57811e4b91f6 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -282,7 +282,8 @@ minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 				break;
 
 		/* short preamble */
-		if (!(mi->supported[group] & BIT(idx)))
+		if ((mi->supported[group] & BIT(idx + 4)) &&
+		    (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
 			idx += 4;
 	}
 	return &mi->groups[group].rates[idx];
@@ -1077,18 +1078,23 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		return;
 
 	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
+	sample_idx %= MCS_GROUP_RATES;
+
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP] &&
+	    (sample_idx >= 4) != txrc->short_preamble)
+		return;
+
 	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	rate->count = 1;
 
-	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+	if (sample_group == &minstrel_mcs_groups[MINSTREL_CCK_GROUP]) {
 		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
 		rate->idx = mp->cck_rates[idx];
 	} else if (sample_group->flags & IEEE80211_TX_RC_VHT_MCS) {
 		ieee80211_rate_set_vht(rate, sample_idx % MCS_GROUP_RATES,
 				       sample_group->streams);
 	} else {
-		rate->idx = sample_idx % MCS_GROUP_RATES +
-			    (sample_group->streams - 1) * 8;
+		rate->idx = sample_idx + (sample_group->streams - 1) * 8;
 	}
 
 	rate->flags = sample_group->flags;
-- 
2.20.1



