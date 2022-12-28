Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F7A657EE8
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbiL1P7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiL1P7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEC118B3F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:59:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6479BB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B252DC433D2;
        Wed, 28 Dec 2022 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243141;
        bh=HehFi/ehS9YWaSp0HsfWjWiRel2hGAWS15p5BJpm8jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXmfPVDgjpXaoVRdj3gLvHRFKJD8CkOM07edyIKVPK/reUeZDyTW31dPWbvkD6jaD
         4Fz8flXNtevQWUMSixeH/Mq5MJDZ6ffIB1SyN79Muic617RAxcwRtoVi4POtZSdl2m
         xptWZc+7sqNkU4a+iSWwBjjhXvE2WV9rwPcOlZ+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Carson Vandegriffe <carson.vandegriffe@candelatech.com>,
        Chad Monroe <chad.monroe@smartrg.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0455/1146] wifi: mt76: mt7915: fix mt7915_mac_set_timing()
Date:   Wed, 28 Dec 2022 15:33:14 +0100
Message-Id: <20221228144342.540179065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index a4bcc617c1a3..7ae9c4bd9c86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1151,7 +1151,7 @@ void mt7915_mac_set_timing(struct mt7915_phy *phy)
 		  FIELD_PREP(MT_TIMEOUT_VAL_CCA, 48);
 	u32 ofdm = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, 60) |
 		   FIELD_PREP(MT_TIMEOUT_VAL_CCA, 28);
-	int offset;
+	int eifs_ofdm = 360, sifs = 10, offset;
 	bool a_band = !(phy->mt76->chandef.chan->band == NL80211_BAND_2GHZ);
 
 	if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
@@ -1169,17 +1169,26 @@ void mt7915_mac_set_timing(struct mt7915_phy *phy)
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



