Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50FB3B647A
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhF1PIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237316AbhF1PFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C020F61D81;
        Mon, 28 Jun 2021 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891418;
        bh=bptRCqEJ8bWyjVb1m8aqTTm0rNWtT6SP2b/8nDtdCHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSg7QZqOvF4B28t7dL6TbAqHyuh4JvNUodj5NrQmn7mVQG4QeLHwW5s/BrmyMqDZU
         VxI51LtNw67MlaXrvM7iljq3Eo9E4tCBDq83sZxn7CRuEbKl9YOP5ozUh8vUogR8wO
         f4l2mpV4jAujBAFNRNTItyL2VmXTTxQPrPFWeOoNxEk7ue75KEJ1axZ0xuqmz8z7Vp
         EK7AAYk6rZV+W3W5/P/TYwVy0L+yO7HihDuPfO/f7AxCzBd8SXSByguYoeZaUcp+An
         OGK6mQ2jiabm4va+mUewSYJ6yelaG7xFMpm445HkDs9QnkYM4FxpRjDrvELO5v/9mZ
         jsXj70Fov0iYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 47/57] mac80211: drop multicast fragments
Date:   Mon, 28 Jun 2021 10:42:46 -0400
Message-Id: <20210628144256.34524-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a9799541ca34652d9996e45f80e8e03144c12949 ]

These are not permitted by the spec, just drop them.

Link: https://lore.kernel.org/r/20210609161305.23def022b750.Ibd6dd3cdce573dae262fcdc47f8ac52b883a9c50@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ae0fba044cd0..bde924968cd2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1853,17 +1853,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		I802_DEBUG_INC(rx->local->dot11MulticastReceivedFrameCount);
-		goto out_no_led;
-	}
-
 	if (rx->sta)
 		cache = &rx->sta->frags;
 
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
+	if (is_multicast_ether_addr(hdr->addr1))
+		return RX_DROP_MONITOR;
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -1992,7 +1990,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

