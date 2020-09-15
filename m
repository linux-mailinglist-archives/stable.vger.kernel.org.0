Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439BD26B4D2
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgIOXcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgIOOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8CB722450;
        Tue, 15 Sep 2020 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180020;
        bh=V2DRi+TKjZ/jc7g2dNn/kJvTQ7yDgockCmmwLbjxl7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntCCUsIurUY2q22iaHag6JQYodKDV0HsrY3Cge5Q22QJ67CeoLaxUV7j1Gevz+Z74
         JgmlrJrZPAFdMEVrFFWIpXK9AaA4IL8jHWpyZA9nsJFTfSi1H2Wilpg7KwL0OyAgiK
         oo1V4S+2Nqub6oohICGN7qHplvLzwc7dOQtmMXkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aviad Brikman <aviad.brikman@celeno.com>,
        Shay Bar <shay.bar@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 076/177] wireless: fix wrong 160/80+80 MHz setting
Date:   Tue, 15 Sep 2020 16:12:27 +0200
Message-Id: <20200915140657.282121286@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Bar <shay.bar@celeno.com>

[ Upstream commit 3579994476b65cb5e272ff0f720a1fd31322e53f ]

Fix cfg80211_chandef_usable():
consider IEEE80211_VHT_CAP_EXT_NSS_BW when verifying 160/80+80 MHz.

Based on:
"Table 9-272 — Setting of the Supported Channel Width Set subfield and Extended NSS BW
Support subfield at a STA transmitting the VHT Capabilities Information field"
>From "Draft P802.11REVmd_D3.0.pdf"

Signed-off-by: Aviad Brikman <aviad.brikman@celeno.com>
Signed-off-by: Shay Bar <shay.bar@celeno.com>
Link: https://lore.kernel.org/r/20200826143139.25976-1-shay.bar@celeno.com
[reformat the code a bit and use u32_get_bits()]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/chan.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index cddf92c5d09ef..7a7cc4ade2b36 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/bitfield.h>
 #include <net/cfg80211.h>
 #include "core.h"
 #include "rdev-ops.h"
@@ -892,6 +893,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	struct ieee80211_sta_vht_cap *vht_cap;
 	struct ieee80211_edmg *edmg_cap;
 	u32 width, control_freq, cap;
+	bool support_80_80 = false;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
@@ -944,9 +946,13 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
-		if (chandef->chan->band != NL80211_BAND_6GHZ &&
-		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		cap = vht_cap->cap;
+		support_80_80 =
+			(cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ) ||
+			(cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
+			 cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) ||
+			u32_get_bits(cap, IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) > 1;
+		if (chandef->chan->band != NL80211_BAND_6GHZ && !support_80_80)
 			return false;
 		/* fall through */
 	case NL80211_CHAN_WIDTH_80:
@@ -966,7 +972,8 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
-		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ &&
+		    !(vht_cap->cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))
 			return false;
 		break;
 	default:
-- 
2.25.1



