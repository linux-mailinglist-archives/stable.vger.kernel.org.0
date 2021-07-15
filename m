Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B460C3CA78A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbhGOSzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241250AbhGOSyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC256610C7;
        Thu, 15 Jul 2021 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375081;
        bh=bGPPZWBLMVLgaINi7y8s9K25vCFRqscWNsCygy0K0NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um2jZKmX9PufKtyUN5ghZ32DV9ki9HaInlzxKvB1IQi1OukSq1S4uyirBGfmb+2Vm
         uUy710MuJYpR+J/vllErxv4Qdfcnw1f6fm8aseNgyaSTs3nAY/jUG75b1EJFhUSxKT
         1vqr22o2Eo1nhAa8WmrnQnvQ4yzmUAmkCbYPOmyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/215] cfg80211: fix default HE tx bitrate mask in 2G band
Date:   Thu, 15 Jul 2021 20:38:01 +0200
Message-Id: <20210715182618.789466193@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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
index daf3f29c7f0c..8fb0478888fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4625,11 +4625,10 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
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



