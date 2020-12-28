Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C87E2E3DDB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437827AbgL1OUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437823AbgL1OUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A2DB2245C;
        Mon, 28 Dec 2020 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165197;
        bh=cPasQO7LZpTRQC1SlF1z+2fUswQxkMPTqJybbRKynOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZoTOUKBvGpaaAfpWr87rhJPp1qya0NSWuMR7KHDVYRnDqXwd2PvkC8i9VOCTlhFy
         m4rF9u4ZVJWA2/uGASfU7fI8JcLX7c/adxmhWLrV80QVxG9a9Yurx7peU1jn4n+J0H
         9wqZV86eUD4jboa/l6D5jcen9a5wtLb6VRQ7uu0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/717] mac80211: fix a mistake check for rx_stats update
Date:   Mon, 28 Dec 2020 13:46:54 +0100
Message-Id: <20201228125040.900007631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit f879ac8ed6c83ce05fcb53815a8ea83c5b6099a1 ]

It should be !is_multicast_ether_addr() in ieee80211_rx_h_sta_process()
for the rx_stats update, below commit remove the !, this patch is to
change it back.

It lead the rx rate "iw wlan0 station dump" become invalid for some
scenario when IEEE80211_HW_USES_RSS is set.

Fixes: 09a740ce352e ("mac80211: receive and process S1G beacons")
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Link: https://lore.kernel.org/r/1607483189-3891-1-git-send-email-wgong@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1e2e5a406d587..2a5a11f92b03e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1758,7 +1758,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
 		sta->rx_stats.last_rx = jiffies;
 	} else if (!ieee80211_is_s1g_beacon(hdr->frame_control) &&
-		   is_multicast_ether_addr(hdr->addr1)) {
+		   !is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
 		 * match the current local configuration when processed.
-- 
2.27.0



