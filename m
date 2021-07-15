Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854933CAAAE
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbhGOTPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244054AbhGOTMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36FBA613E6;
        Thu, 15 Jul 2021 19:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376152;
        bh=AEFMNni0q72L8/+5niW7zEZN13RimeOt/iWZevfRFVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byFy2i6eGcPwPXDxhxtNkTeQrAyo9lZdK//lyrBpxwMtA37Az6VoLPZgLwKVe1HUq
         lHAKH13LdOHOlFdwnekl1ZnU5aXY9Or7C8jJCNHwyIegRtyW6JAiut5qUsxlTO3UF9
         dhTw76P0SWCBrZBOtVw4mrlAD65Gd47LIRe2gKvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 148/266] cfg80211: fix default HE tx bitrate mask in 2G band
Date:   Thu, 15 Jul 2021 20:38:23 +0200
Message-Id: <20210715182639.621011292@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 9df66d5b9f45c39b3925d16e8947cc10009b186d ]

In 2G band, a HE sta can only supports HT and HE, but not supports VHT.
In this case, default HE tx bitrate mask isn't filled, when we use iw to
set bitrates without any parameter.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20210609075944.51130-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fc9286afe3c9..912977bf3ec8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4781,11 +4781,10 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 		       sband->ht_cap.mcs.rx_mask,
 		       sizeof(mask->control[i].ht_mcs));
 
-		if (!sband->vht_cap.vht_supported)
-			continue;
-
-		vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
-		vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
+		if (sband->vht_cap.vht_supported) {
+			vht_tx_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+			vht_build_mcs_mask(vht_tx_mcs_map, mask->control[i].vht_mcs);
+		}
 
 		he_cap = ieee80211_get_he_iftype_cap(sband, wdev->iftype);
 		if (!he_cap)
-- 
2.30.2



