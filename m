Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7275499FEE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842380AbiAXXBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839879AbiAXWwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:52:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2951C0EE126;
        Mon, 24 Jan 2022 13:08:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 405BD611C8;
        Mon, 24 Jan 2022 21:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ED6C340E5;
        Mon, 24 Jan 2022 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058503;
        bh=JAH7qg2L/G+k79KV4K1U+s1717QvvG9IoCWx99kg8+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkWtSDOnGE5Lj1uY3MmlYHfbMFAC2doSsqQGDhgGnxsZEPIX97vukwP0lS1kKkwyi
         lnzq8UR1lW35sflkVI0goIGsp0gQT5laAW4wK9yC3qjmg2NZQBqUhSRJpeOlcCwb0I
         5thGhQpuruVWZijIxDuxOQT14fPPVKF9LcdPz5Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0311/1039] mt76: fix possible OOB issue in mt76_calculate_default_rate
Date:   Mon, 24 Jan 2022 19:35:00 +0100
Message-Id: <20220124184135.760432052@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d4f3d1c4d3c2bcce76a96a6562170664b25112f0 ]

Cap max offset value to ARRAY_SIZE(mt76_rates) - 1 in
mt76_calculate_default_rate routine in order to avoid possible Out Of
Bound accesses.

Fixes: 33920b2bf0483 ("mt76: add support for setting mcast rate")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 62807dc311c19..b0869ff86c49f 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1494,7 +1494,6 @@ EXPORT_SYMBOL_GPL(mt76_init_queue);
 u16 mt76_calculate_default_rate(struct mt76_phy *phy, int rateidx)
 {
 	int offset = 0;
-	struct ieee80211_rate *rate;
 
 	if (phy->chandef.chan->band != NL80211_BAND_2GHZ)
 		offset = 4;
@@ -1503,9 +1502,11 @@ u16 mt76_calculate_default_rate(struct mt76_phy *phy, int rateidx)
 	if (rateidx < 0)
 		rateidx = 0;
 
-	rate = &mt76_rates[offset + rateidx];
+	rateidx += offset;
+	if (rateidx >= ARRAY_SIZE(mt76_rates))
+		rateidx = offset;
 
-	return rate->hw_value;
+	return mt76_rates[rateidx].hw_value;
 }
 EXPORT_SYMBOL_GPL(mt76_calculate_default_rate);
 
-- 
2.34.1



