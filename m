Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF5949A02E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842409AbiAXXBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382774AbiAXWxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD11C0EE12D;
        Mon, 24 Jan 2022 13:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C013461489;
        Mon, 24 Jan 2022 21:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB4BC340E5;
        Mon, 24 Jan 2022 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058516;
        bh=/G0qA44KxcJzpX12SZiZmuPSQJ7xQKjHwZtCclxgJY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtlhgyXGHcxwbG3JwCdrvKjfy87ATK/bZ9027YBCQOFJcnUqRutwepMvi2Gjzm+0A
         O8p43asqPeTAAKwKOEwMDQ7MeBqtDvz6xPKU1iJEqXhkIOYH1l0XcdYblp6Vurh7DE
         pM2QLib0ovBfSX0GaclrP9aMLBQIdu4Tz4o4IizY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0315/1039] mt76: mt7921: use correct iftype data on 6GHz cap init
Date:   Mon, 24 Jan 2022 19:35:04 +0100
Message-Id: <20220124184135.889318646@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 00ff52346d74c38787ff8b4acde8c5671d9b7fe2 ]

Set 6GHz cap to iftype data which is matched to the type of
current interface.

Fixes: 50ac15a511e3 ("mt76: mt7921: add 6GHz support")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 0b2a6b7f22eae..21e745fddc9c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -166,7 +166,7 @@ mt7921_init_he_caps(struct mt7921_phy *phy, enum nl80211_band band,
 			if (vht_cap->cap & IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN)
 				cap |= IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS;
 
-			data->he_6ghz_capa.capa = cpu_to_le16(cap);
+			data[idx].he_6ghz_capa.capa = cpu_to_le16(cap);
 		}
 		idx++;
 	}
-- 
2.34.1



