Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C6E3B60F0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhF1ObV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234633AbhF1OaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D87C61C8F;
        Mon, 28 Jun 2021 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890398;
        bh=KhbiyuLLERIEN3mwW3CiOReyCEtnWfy9EMZ7F+JCMOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8UcPfPpStgWu3YvDjp2XISZIhHuoC7wiMhkWAJNYBHmTck2CfvysjpPt4WWa38iu
         DEzxZxtPpH5dhbTuqySS5tGQ1Nkw3PNvwsRCC5ZoNigt+93qg6fu7bzDM8Q2R3ICGr
         SCAMVQGJcTmyo+zrpjiE1p21MRLwwC0RJZeuw9BBRkjRHrw7NwuZd4t16+ThkczHSb
         GUO2muq3Hsva2VNmdxc8ZwP2/W/hSomAjbtSVsIQUkO6gKgyICrg9EJe0WbX2O9OKi
         BIVyuu1ZTKWdFscP3+uwU9Hl6Fl7uG34hdnvMgaHrfY0mPm+ApvuOdRaUp693u9Lo/
         nBKCstB8vS5Pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/101] mac80211: drop multicast fragments
Date:   Mon, 28 Jun 2021 10:25:00 -0400
Message-Id: <20210628142607.32218-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index ef8ff0bc66f1..38b5695c2a0c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2250,17 +2250,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -2386,7 +2384,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
  out:
 	ieee80211_led_rx(rx->local);
- out_no_led:
 	if (rx->sta)
 		rx->sta->rx_stats.packets++;
 	return RX_CONTINUE;
-- 
2.30.2

