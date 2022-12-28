Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63F6657EEB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiL1P7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiL1P7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A5818B31
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A21D1B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F284CC433EF;
        Wed, 28 Dec 2022 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243149;
        bh=yIf4KSem7E/fWvBQLQCsiwU7oK+kb5gqbt+mhSoTSqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7VY6PGg6lcZN1etcPeYqIXatACoAdyH8RovS2qrJEJcygOM++0LDbZ32MJo9kUUY
         D3a8Gf5Dgeh93GxvUiWlN7XEcW8V7IeJRXLShQSkQpGZyOrRfmaDwBeRbj3ZOTbynL
         Z9wchba60Lb49pUAxaVy++UXeNCXG/V253wTLC0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0456/1146] wifi: mt76: mt7915: fix reporting of TX AGGR histogram
Date:   Wed, 28 Dec 2022 15:33:15 +0100
Message-Id: <20221228144342.567501682@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 528d13e7f033b54d50e0077922dd52f005d648cf ]

Fix stats clash between bins [4-7] in 802.11 tx aggregation histogram.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 7ae9c4bd9c86..e6bf6e04d4b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1609,7 +1609,7 @@ void mt7915_mac_update_stats(struct mt7915_phy *phy)
 
 	aggr0 = phy->band_idx ? ARRAY_SIZE(dev->mt76.aggr_stats) / 2 : 0;
 	if (is_mt7915(&dev->mt76)) {
-		for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
+		for (i = 0, aggr1 = aggr0 + 8; i < 4; i++) {
 			val = mt76_rr(dev, MT_MIB_MB_SDR1(phy->band_idx, (i << 4)));
 			mib->ba_miss_cnt +=
 				FIELD_GET(MT_MIB_BA_MISS_COUNT_MASK, val);
-- 
2.35.1



