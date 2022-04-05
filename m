Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF44F28B5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiDEIVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiDEIIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42036C904;
        Tue,  5 Apr 2022 01:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2CC61748;
        Tue,  5 Apr 2022 08:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681E1C385A0;
        Tue,  5 Apr 2022 08:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145742;
        bh=sLwL2qpxVBnB32ES/8Ty5wpNoUexmJ1gY52PilcPFao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aL9S0aXbFgOJVDjIqNZwnfaAwVGe0mS1axCs5HKQOAuRSAcj1POBa1VnbWYzq/vCN
         /4Pa04r0I4wfaQjufMn2GoBXL9dT8bJ88SFDdQT/ZnmaR9UkISm2Ic/i/NP4mjNXNh
         VlGNkG6IyPkzeXz6Y7fif2ortiBX3YObK4J+qV5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0506/1126] mt76: mt7915: fix possible memory leak in mt7915_mcu_add_sta
Date:   Tue,  5 Apr 2022 09:20:53 +0200
Message-Id: <20220405070422.479819690@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit a43736cd12d82913102eb49cb56787a5553e028f ]

Free allocated skb in mt7915_mcu_add_sta routine in case of failures.

Fixes: 89bbd3730f382 ("mt76: mt7915: rework starec TLV tags")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index b2b3b5068789..1afeb7493268 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2399,8 +2399,10 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 	}
 
 	ret = mt7915_mcu_sta_wtbl_tlv(dev, skb, vif, sta);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	if (sta && sta->ht_cap.ht_supported) {
 		/* starec amsdu */
@@ -2414,8 +2416,10 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 	}
 
 	ret = mt7915_mcu_add_group(dev, vif, sta);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 out:
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_EXT_CMD(STA_REC_UPDATE), true);
-- 
2.34.1



