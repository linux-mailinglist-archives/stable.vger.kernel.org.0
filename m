Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7882E4056
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392217AbgL1OuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392057AbgL1OUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F99420731;
        Mon, 28 Dec 2020 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165194;
        bh=hlcs8hfSXi00ghF6YekuCgv5AbCzDbEcRdBkqnKfU/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1R1TnEC8MHhZV5y1QVxcub6I7NNVQMMdobxcm6nvN+E2DGoy3k1LUtAEGb5pYQbM
         db8T4YeK8clo6V2OXVxpZRtuVYI+tCxh3QGnbMw9IxBEb9KZpcHo3Zefxp3FxMW0bB
         NHu2UdeJ9lAgzRc2elB1KU1EcEA6SQgUyyStzKTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/717] mac80211: dont set set TDLS STA bandwidth wider than possible
Date:   Mon, 28 Dec 2020 13:46:53 +0100
Message-Id: <20201228125040.852208999@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f65607cdbc6b0da356ef5a22552ddd9313cf87a0 ]

When we set up a TDLS station, we set sta->sta.bandwidth solely based
on the capabilities, because the "what's the current bandwidth" check
is bypassed and only applied for other types of stations.

This leads to the unfortunate scenario that the sta->sta.bandwidth is
160 MHz if both stations support it, but we never actually configure
this bandwidth unless the AP is already using 160 MHz; even for wider
bandwidth support we only go up to 80 MHz (at least right now.)

For iwlwifi, this can also lead to firmware asserts, telling us that
we've configured the TX rates for a higher bandwidth than is actually
available due to the PHY configuration.

For non-TDLS, we check against the interface's requested bandwidth,
but we explicitly skip this check for TDLS to cope with the wider BW
case. Change this to
 (a) still limit to the TDLS peer's own chandef, which gets factored
     into the overall PHY configuration we request from the driver,
     and
 (b) limit it to when the TDLS peer is authorized, because it's only
     factored into the channel context in this case.

Fixes: 504871e602d9 ("mac80211: fix bandwidth computation for TDLS peers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.fcc7d29c4590.I11f77e9e25ddf871a3c8d5604650c763e2c5887a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/vht.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index fb0e3a657d2d3..c3ca973737742 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -465,12 +465,18 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 	 * IEEE80211-2016 specification makes higher bandwidth operation
 	 * possible on the TDLS link if the peers have wider bandwidth
 	 * capability.
+	 *
+	 * However, in this case, and only if the TDLS peer is authorized,
+	 * limit to the tdls_chandef so that the configuration here isn't
+	 * wider than what's actually requested on the channel context.
 	 */
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
-	    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
-		return bw;
-
-	bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
+	    test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW) &&
+	    test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+	    sta->tdls_chandef.chan)
+		bw = min(bw, ieee80211_chan_width_to_rx_bw(sta->tdls_chandef.width));
+	else
+		bw = min(bw, ieee80211_chan_width_to_rx_bw(bss_width));
 
 	return bw;
 }
-- 
2.27.0



