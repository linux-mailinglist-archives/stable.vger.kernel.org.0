Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E593CAAB6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243247AbhGOTPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241276AbhGOTMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873DE613DB;
        Thu, 15 Jul 2021 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376155;
        bh=9VgLUQBs92xOKfCw9yNr7isD9zAUSEpSnUkmlmOKwBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGrvNo36e6jd4pPQGuQNu3bFwSvMct17/Wycp0lEzNt+FIEN5OD3HvwUcf4xgYJ/g
         Os6Sr+YvpdxxsiX+4TvSNhRMRkMbU4dQykyDXidVfkOJkFFhgsBSP3ZaBRdQONhD6t
         LEv5QZKTYJitQTtxIFUFOr/8b86LT2Sgpw1q4ah8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiraviyam Mariyappan <tmariyap@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 149/266] mac80211: consider per-CPU statistics if present
Date:   Thu, 15 Jul 2021 20:38:24 +0200
Message-Id: <20210715182639.745551813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d656a4c6ead6c3f252b2f2532bc9735598f7e317 ]

If we have been keeping per-CPU statistics, consider them
regardless of USES_RSS, because we may not actually fill
those, for example in non-fast-RX cases when the connection
is not compatible with fast-RX. If we didn't fill them, the
additional data will be zero and not affect anything, and
if we did fill them then it's more correct to consider them.

This fixes an issue in mesh mode where some statistics are
not updated due to USES_RSS being set, but fast-RX isn't
used.

Reported-by: Thiraviyam Mariyappan <tmariyap@codeaurora.org>
Link: https://lore.kernel.org/r/20210610220814.13b35f5797c5.I511e9b33c5694e0d6cef4b6ae755c873d7c22124@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 13250cadb420..e18c3855f616 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2088,10 +2088,9 @@ static struct ieee80211_sta_rx_stats *
 sta_get_last_rx_stats(struct sta_info *sta)
 {
 	struct ieee80211_sta_rx_stats *stats = &sta->rx_stats;
-	struct ieee80211_local *local = sta->local;
 	int cpu;
 
-	if (!ieee80211_hw_check(&local->hw, USES_RSS))
+	if (!sta->pcpu_rx_stats)
 		return stats;
 
 	for_each_possible_cpu(cpu) {
@@ -2191,9 +2190,7 @@ static void sta_set_tidstats(struct sta_info *sta,
 	int cpu;
 
 	if (!(tidstats->filled & BIT(NL80211_TID_STATS_RX_MSDU))) {
-		if (!ieee80211_hw_check(&local->hw, USES_RSS))
-			tidstats->rx_msdu +=
-				sta_get_tidstats_msdu(&sta->rx_stats, tid);
+		tidstats->rx_msdu += sta_get_tidstats_msdu(&sta->rx_stats, tid);
 
 		if (sta->pcpu_rx_stats) {
 			for_each_possible_cpu(cpu) {
@@ -2272,7 +2269,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->rx_beacon = sdata->u.mgd.count_beacon_signal;
 
 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
-
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME) |
 			 BIT_ULL(NL80211_STA_INFO_STA_FLAGS) |
 			 BIT_ULL(NL80211_STA_INFO_BSS_PARAM) |
@@ -2307,8 +2303,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 
 	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES64) |
 			       BIT_ULL(NL80211_STA_INFO_RX_BYTES)))) {
-		if (!ieee80211_hw_check(&local->hw, USES_RSS))
-			sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
+		sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
 
 		if (sta->pcpu_rx_stats) {
 			for_each_possible_cpu(cpu) {
-- 
2.30.2



