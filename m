Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08355657E3B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiL1Pvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiL1Pva (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39906186FB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A1C61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94DFC433D2;
        Wed, 28 Dec 2022 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242689;
        bh=Mu9PiKrStsCHimDyzBVAY48ByRF4CSmzDMSPGqPB6Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAxLFbyQ4hMBWhoaBohMRoCUrcFeYvC2KH+adlybuK06Q9i4HsFQj8iEqS1YEXJ1x
         fdFlJYvBhWE0dSDaxS1Imoi9F/s6D+N8Les51I/dN3FBBIa5teWE6eClygHqD6xrJX
         U+V56LCdPLFcnY/f+rmaYOl0I4o3BV/mUYHuEYHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Carson Vandegriffe <carson.vandegriffe@candelatech.com>,
        Chad Monroe <chad.monroe@smartrg.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0440/1073] wifi: mt76: mt7915: fix mt7915_mac_set_timing()
Date:   Wed, 28 Dec 2022 15:33:48 +0100
Message-Id: <20221228144339.979023251@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 0c881dc08fd71ca2673f31a64989fbb28eac26f4 ]

Correct mac timiing settings for different hardware generations.
This improves 40-60Mbps performance.

Fixes: 9aac2969fe5f ("mt76: mt7915: update mac timing settings")
Reported-By: Carson Vandegriffe <carson.vandegriffe@candelatech.com>
Tested-by: Chad Monroe <chad.monroe@smartrg.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 49aa5c056063..68e1cf5a1044 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1146,7 +1146,7 @@ void mt7915_mac_set_timing(struct mt7915_phy *phy)
 		  FIELD_PREP(MT_TIMEOUT_VAL_CCA, 48);
 	u32 ofdm = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, 60) |
 		   FIELD_PREP(MT_TIMEOUT_VAL_CCA, 28);
-	int offset;
+	int eifs_ofdm = 360, sifs = 10, offset;
 	bool a_band = !(phy->mt76->chandef.chan->band == NL80211_BAND_2GHZ);
 
 	if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
@@ -1164,17 +1164,26 @@ void mt7915_mac_set_timing(struct mt7915_phy *phy)
 	reg_offset = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, offset) |
 		     FIELD_PREP(MT_TIMEOUT_VAL_CCA, offset);
 
+	if (!is_mt7915(&dev->mt76)) {
+		if (!a_band) {
+			mt76_wr(dev, MT_TMAC_ICR1(phy->band_idx),
+				FIELD_PREP(MT_IFS_EIFS_CCK, 314));
+			eifs_ofdm = 78;
+		} else {
+			eifs_ofdm = 84;
+		}
+	} else if (a_band) {
+		sifs = 16;
+	}
+
 	mt76_wr(dev, MT_TMAC_CDTR(phy->band_idx), cck + reg_offset);
 	mt76_wr(dev, MT_TMAC_ODTR(phy->band_idx), ofdm + reg_offset);
 	mt76_wr(dev, MT_TMAC_ICR0(phy->band_idx),
-		FIELD_PREP(MT_IFS_EIFS_OFDM, a_band ? 84 : 78) |
+		FIELD_PREP(MT_IFS_EIFS_OFDM, eifs_ofdm) |
 		FIELD_PREP(MT_IFS_RIFS, 2) |
-		FIELD_PREP(MT_IFS_SIFS, 10) |
+		FIELD_PREP(MT_IFS_SIFS, sifs) |
 		FIELD_PREP(MT_IFS_SLOT, phy->slottime));
 
-	mt76_wr(dev, MT_TMAC_ICR1(phy->band_idx),
-		FIELD_PREP(MT_IFS_EIFS_CCK, 314));
-
 	if (phy->slottime < 20 || a_band)
 		val = MT7915_CFEND_RATE_DEFAULT;
 	else
-- 
2.35.1



