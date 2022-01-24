Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355A049A3F2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369200AbiAYABP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847039AbiAXXSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61DDC06F8D7;
        Mon, 24 Jan 2022 13:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC560B81218;
        Mon, 24 Jan 2022 21:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE852C340E4;
        Mon, 24 Jan 2022 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059601;
        bh=xaOjFriQ6amaUUYsrE142p7G3EPJVhpiLBHT/0meCKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFOTfOz/V69nN7vZgZ1AZ/i/S2GX9gJcpajAaWEfxHEvSyY1p1/PiMN0ZqFYBDK/6
         rMWXvIYX+Kjd2xvD4nxv1wkKsvT56wGHShTr+673jMofdzbbblwzh9Hlp/129k9VCw
         Ejd+3SirqTmF4UP4FS39Bu/ADK6OLdXcbb9iJ5/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0671/1039] mt76: connac: fix a theoretical NULL pointer dereference in mt76_connac_get_phy_mode
Date:   Mon, 24 Jan 2022 19:41:00 +0100
Message-Id: <20220124184147.929924729@linuxfoundation.org>
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

[ Upstream commit c9dbeac4988f6d4c4211b3747ec9c9c75ea87967 ]

Even if it is not a real bug since mt76_connac_get_phy_mode runs just
for mt7921 where only STA is supported, fix a theoretical NULL pointer
dereference if new added modes do not support HE

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index a5857a788da50..7733c8fad2413 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1180,7 +1180,7 @@ mt76_connac_get_phy_mode(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		if (ht_cap->ht_supported)
 			mode |= PHY_MODE_GN;
 
-		if (he_cap->has_he)
+		if (he_cap && he_cap->has_he)
 			mode |= PHY_MODE_AX_24G;
 	} else if (band == NL80211_BAND_5GHZ || band == NL80211_BAND_6GHZ) {
 		mode |= PHY_MODE_A;
@@ -1191,7 +1191,7 @@ mt76_connac_get_phy_mode(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		if (vht_cap->vht_supported)
 			mode |= PHY_MODE_AC;
 
-		if (he_cap->has_he) {
+		if (he_cap && he_cap->has_he) {
 			if (band == NL80211_BAND_6GHZ)
 				mode |= PHY_MODE_AX_6G;
 			else
-- 
2.34.1



