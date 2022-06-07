Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33223541ACF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380528AbiFGViz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380824AbiFGViP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:38:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A4E8B97;
        Tue,  7 Jun 2022 12:05:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 159BB6184D;
        Tue,  7 Jun 2022 19:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C33DC385A2;
        Tue,  7 Jun 2022 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628717;
        bh=EvHff7RLEks0ueha8CxQImz90j4dNeG3LekJ1DQmmow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0yoEwurDzUL8X8Y7rd3ppTiNrhZjhoTg7tybB/hf2l3Sn9kFSoicun15qFg+LZPK
         w8VyODJt/5y7yNVi4fMJPoQptRShhDWhRCU3zpxEQCxgrAjAIKA9wPVakqPirSL5C8
         8dSPnwIK87nRjGWAzg/Bf3b2skI7VV5pmt8/ipng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 431/879] mt76: mt7915: fix unbounded shift in mt7915_mcu_beacon_mbss
Date:   Tue,  7 Jun 2022 18:59:09 +0200
Message-Id: <20220607165015.379960149@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit aa796f12091aa4758366f5171fd9cba2ff574ba3 ]

Fix the following smatch static checker warning:
	drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:1872 mt7915_mcu_beacon_mbss()
	error: undefined (user controlled) shift '(((1))) << (data[2])'

Rely on mac80211 definitions for ieee80211_bssid_index subelement.

Fixes: 6b7f9aff7c67 ("mt76: mt7915: introduce 802.11ax multi-bss support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e7a6f80e7755..736c9c342baa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1854,7 +1854,8 @@ mt7915_mcu_beacon_mbss(struct sk_buff *rskb, struct sk_buff *skb,
 			continue;
 
 		for_each_element(sub_elem, elem->data + 1, elem->datalen - 1) {
-			const u8 *data;
+			const struct ieee80211_bssid_index *idx;
+			const u8 *idx_ie;
 
 			if (sub_elem->id || sub_elem->datalen < 4)
 				continue; /* not a valid BSS profile */
@@ -1862,14 +1863,19 @@ mt7915_mcu_beacon_mbss(struct sk_buff *rskb, struct sk_buff *skb,
 			/* Find WLAN_EID_MULTI_BSSID_IDX
 			 * in the merged nontransmitted profile
 			 */
-			data = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
-						sub_elem->data,
-						sub_elem->datalen);
-			if (!data || data[1] < 1 || !data[2])
+			idx_ie = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
+						  sub_elem->data,
+						  sub_elem->datalen);
+			if (!idx_ie || idx_ie[1] < sizeof(*idx))
 				continue;
 
-			mbss->offset[data[2]] = cpu_to_le16(data - skb->data);
-			mbss->bitmap |= cpu_to_le32(BIT(data[2]));
+			idx = (void *)(idx_ie + 2);
+			if (!idx->bssid_index || idx->bssid_index > 31)
+				continue;
+
+			mbss->offset[idx->bssid_index] =
+				cpu_to_le16(idx_ie - skb->data);
+			mbss->bitmap |= cpu_to_le32(BIT(idx->bssid_index));
 		}
 	}
 }
-- 
2.35.1



