Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49409604121
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiJSKib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJSKiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:38:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA65152C68;
        Wed, 19 Oct 2022 03:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2CFB822EA;
        Wed, 19 Oct 2022 08:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226A8C433B5;
        Wed, 19 Oct 2022 08:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169472;
        bh=C8mJs/DW0I+lDN5k5E9k6cEFjftALrJf9Lm2fiFCk6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sew4FdAMXlO+w7FrWEvy5ZI2Q4pRE5WzS7+Ao7p4qQb2hyd7x9BCozKw57jkbQFfA
         8EMtPDKKBOb1JNd73t5T4TBCrAE4RwqBgnKQgrl33/n1rQDsxNCqho0bqhQbOOJYUt
         nEywpRbPEfCWe1fhi01bxL5dQ3hssbiDIS78kRls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 289/862] wifi: mt76: mt7915: fix mcs value in ht mode
Date:   Wed, 19 Oct 2022 10:26:16 +0200
Message-Id: <20221019083302.780637133@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit c6d3e16ad4362502e804a6ca01e955612f3b8222 ]

Fix the error that mcs will be reduced to a range of 0 to 7 in ht mode.

Fixes: 70fd1333cd32 ("mt76: mt7915: rework .set_bitrate_mask() to support more options")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index f83067961945..e99fdacc11ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1360,7 +1360,7 @@ mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
 	struct sta_phy phy = {};
 	int ret, nrates = 0;
 
-#define __sta_phy_bitrate_mask_check(_mcs, _gi, _he)				\
+#define __sta_phy_bitrate_mask_check(_mcs, _gi, _ht, _he)			\
 	do {									\
 		u8 i, gi = mask->control[band]._gi;				\
 		gi = (_he) ? gi : gi == NL80211_TXRATE_FORCE_SGI;		\
@@ -1373,15 +1373,17 @@ mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
 				continue;					\
 			nrates += hweight16(mask->control[band]._mcs[i]);	\
 			phy.mcs = ffs(mask->control[band]._mcs[i]) - 1;		\
+			if (_ht)						\
+				phy.mcs += 8 * i;				\
 		}								\
 	} while (0)
 
 	if (sta->deflink.he_cap.has_he) {
-		__sta_phy_bitrate_mask_check(he_mcs, he_gi, 1);
+		__sta_phy_bitrate_mask_check(he_mcs, he_gi, 0, 1);
 	} else if (sta->deflink.vht_cap.vht_supported) {
-		__sta_phy_bitrate_mask_check(vht_mcs, gi, 0);
+		__sta_phy_bitrate_mask_check(vht_mcs, gi, 0, 0);
 	} else if (sta->deflink.ht_cap.ht_supported) {
-		__sta_phy_bitrate_mask_check(ht_mcs, gi, 0);
+		__sta_phy_bitrate_mask_check(ht_mcs, gi, 1, 0);
 	} else {
 		nrates = hweight32(mask->control[band].legacy);
 		phy.mcs = ffs(mask->control[band].legacy) - 1;
-- 
2.35.1



