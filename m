Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057F74F44EA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353098AbiDEMIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358096AbiDEK16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0727168302;
        Tue,  5 Apr 2022 03:15:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 980EC6179E;
        Tue,  5 Apr 2022 10:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7C6C385A0;
        Tue,  5 Apr 2022 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153726;
        bh=otq49y8QEyJ+LXqzxJkfjS2K0k2wRoeqF2v+AnN+pbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2L+DZyzxD1GzkNNqPKQs7mdo+YZ8VBKzh6tTNdZk1xtVMIKwCFQ/9kCauGlkpBchb
         GabKWJZd/X9AD2VhOachvxmr2PIpQQdKAiJoyHpIpUcEX8UovlSVrPYdW0GTclkhzJ
         s+S5p3N1fJ1WNnrQKHs8O2KSbW0zbETWFNYQH6/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/599] mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
Date:   Tue,  5 Apr 2022 09:29:41 +0200
Message-Id: <20220405070307.375354224@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a56b1b0f145ef2d6bb9312dedf3ab8558ef50a5b ]

mac80211 provides aid in vif->bss_conf.aid for sta mode and not in
sta->aid. Fix mt7915_mcu_wtbl_generic_tlv routine using proper value for
aid in sta mode.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 9a7f317a098f..6e73964b8b0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1259,8 +1259,11 @@ mt7915_mcu_wtbl_generic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	generic = (struct wtbl_generic *)tlv;
 
 	if (sta) {
+		if (vif->type == NL80211_IFTYPE_STATION)
+			generic->partial_aid = cpu_to_le16(vif->bss_conf.aid);
+		else
+			generic->partial_aid = cpu_to_le16(sta->aid);
 		memcpy(generic->peer_addr, sta->addr, ETH_ALEN);
-		generic->partial_aid = cpu_to_le16(sta->aid);
 		generic->muar_idx = mvif->omac_idx;
 		generic->qos = sta->wme;
 	} else {
-- 
2.34.1



