Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2328BA55
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbgJLOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389170AbgJLNdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:33:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBE3420BED;
        Mon, 12 Oct 2020 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509614;
        bh=KIAdlPqGQxBzYeo+gHSe7Aij7Mx4SkWPk5L0TTbEbic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLwAYSsxWaWArGKtn0B430Rpy8e85E5uvwNXFBFm8RGE1h6sXRp4L3Pm2oJW2EkRz
         owfcvSARAFl+Td2k6CnG/Zlaw9kVWyUHybT0Vv+nh3zzA3nqz5NQ+935cD2Zn8C+3j
         JWfmG3AuF+AVxgQRql2hhMWqUOQr9WjI2Pq1lW0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/54] mac80211: do not allow bigger VHT MPDUs than the hardware supports
Date:   Mon, 12 Oct 2020 15:26:33 +0200
Message-Id: <20201012132630.108139595@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3bd5c7a28a7c3aba07a2d300d43f8e988809e147 ]

Limit maximum VHT MPDU size by local capability.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200917125031.45009-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/vht.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 43e45bb660bcd..b1d3fa708e16b 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -170,10 +170,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	/* take some capabilities as-is */
 	cap_info = le32_to_cpu(vht_cap_ie->vht_cap_info);
 	vht_cap->cap = cap_info;
-	vht_cap->cap &= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-			IEEE80211_VHT_CAP_RXLDPC |
+	vht_cap->cap &= IEEE80211_VHT_CAP_RXLDPC |
 			IEEE80211_VHT_CAP_VHT_TXOP_PS |
 			IEEE80211_VHT_CAP_HTC_VHT |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
@@ -182,6 +179,9 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 			IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
 			IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 
+	vht_cap->cap |= min_t(u32, cap_info & IEEE80211_VHT_CAP_MAX_MPDU_MASK,
+			      own_cap.cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK);
+
 	/* and some based on our own capabilities */
 	switch (own_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
 	case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
-- 
2.25.1



