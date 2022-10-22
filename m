Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87322608699
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiJVHvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiJVHth (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:49:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F318A6ED;
        Sat, 22 Oct 2022 00:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC993B82E1F;
        Sat, 22 Oct 2022 07:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D1C433C1;
        Sat, 22 Oct 2022 07:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424713;
        bh=U3Vw3D6HP5pNxYddemRgXmagrQL9/QTUYvo5batzupQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv/G7kYX6td22lczASPYB0cioo5OG5Jklu4AVc0szDAXH4IMXxuzXHIYHHokUl62F
         3sg8jHnXZeDlm+4rfIXp7/v4ECPqJD1FLl4fh099Nu6gYao8jY4nvdZahr25e312k7
         jn+UF+7EPxtFFefk0ibuYlFzLZ+c/cF2+5G1EufA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 248/717] wifi: mt76: mt7915: fix mcs value in ht mode
Date:   Sat, 22 Oct 2022 09:22:07 +0200
Message-Id: <20221022072458.768674217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 17fa2acc0d07..ec8a5083466f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1460,7 +1460,7 @@ mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
 	struct sta_phy phy = {};
 	int ret, nrates = 0;
 
-#define __sta_phy_bitrate_mask_check(_mcs, _gi, _he)				\
+#define __sta_phy_bitrate_mask_check(_mcs, _gi, _ht, _he)			\
 	do {									\
 		u8 i, gi = mask->control[band]._gi;				\
 		gi = (_he) ? gi : gi == NL80211_TXRATE_FORCE_SGI;		\
@@ -1473,15 +1473,17 @@ mt7915_mcu_add_rate_ctrl_fixed(struct mt7915_dev *dev,
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



