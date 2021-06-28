Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F29A3B63FA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhF1PCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhF1PAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1911B61D70;
        Mon, 28 Jun 2021 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891255;
        bh=q4Ch5aLwhkpOI3OBAmrvkqhgZqn6fNoRPF7U7SBdh5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H13XXLkzRiuMQ8aj6ziJO+pc6fAP1tajv6Sxnpc2pFjhR9bWjZgdD8YcUQvoT7xZA
         tBimytL76Ungt9cDlJ3aaZ49C+MiNLEs5U4mO2Mfm/62NDY37DCdZmuJh09REt9neA
         e8hXFverWafWXE9XQbr9uW1lJ/Tn0SP8UH1qZcUsaMdjfcU//Jj+c/CwRiIlK5zk8M
         uFo4UCIU7GA/RNXcx+D2kAFKA1xqn5ZCGunlWuhKOq67p4+Pmfg0OlOLr7o6xQ9/li
         lS3aJLnHM1jBWcZroyc7Po58JiHAMIqPgk3fnbWhdbAmUczIolmBz1cwwxZEvQaUh/
         mrRZVlLMhgVXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 58/71] mac80211: drop multicast fragments
Date:   Mon, 28 Jun 2021 10:39:50 -0400
Message-Id: <20210628144003.34260-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 721caa5a5430..3a069cb188b7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1988,17 +1988,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -2127,7 +2125,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

