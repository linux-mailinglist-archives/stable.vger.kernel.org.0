Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271B14F2838
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiDEIL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiDEIFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A017469282;
        Tue,  5 Apr 2022 01:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5A1617D7;
        Tue,  5 Apr 2022 08:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B849C34112;
        Tue,  5 Apr 2022 08:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145686;
        bh=EPZiKiBy+kuacmEzwYHvQMUapudOZHYHm3CdwShSsZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEEyCCP4Lcz4a87Fy/TW6KfRUjXBDz2vmN4lT5Amb5w6oehsYlC8HrNkFnu68IXuw
         6sn6aVa3IUnYBRzaj4m2ZMyMeTfZFnbHy3L+erXw0l/0hxQ8RM62ushAx3HQ5JaXwa
         DP+6NqBDP01Scg3JVSmMHUlfYjs46N7nUuuC1bpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0493/1126] mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
Date:   Tue,  5 Apr 2022 09:20:40 +0200
Message-Id: <20220405070422.097937806@linuxfoundation.org>
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
index 0911b6f973b5..38cc50603d20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1264,8 +1264,11 @@ mt7915_mcu_wtbl_generic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	generic = (struct wtbl_generic *)tlv;
 
 	if (sta) {
+		if (vif->type == NL80211_IFTYPE_STATION)
+			generic->partial_aid = cpu_to_le16(vif->bss_conf.aid);
+		else
+			generic->partial_aid = cpu_to_le16(sta->aid);
 		memcpy(generic->peer_addr, sta->addr, ETH_ALEN);
-		generic->partial_aid = cpu_to_le16(sta->aid);
 		generic->muar_idx = mvif->mt76.omac_idx;
 		generic->qos = sta->wme;
 	} else {
-- 
2.34.1



