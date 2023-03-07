Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC36AE95F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjCGRXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCGRWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2E292719
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4804B819AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B37C433EF;
        Tue,  7 Mar 2023 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209513;
        bh=9daRASjByjTlk5jqNUsIH1zGyA6eUmHzOeCCpIEKZrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Wpok5WnyLvDlEZucf7lioO4R3bBXK75LKjcgLpqrTBdOyAjNuvNw2sBLZapLGjc7
         boMBknpOYiP8q/KwCpLBoWohNV1oag8v1luredKzad06337uuaAEmi2B4krvWAn8id
         gjvEteKUAhHFejOBj7WEHKdo2bZ+IGiTfaImXrFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0243/1001] wifi: mt76: mt7996: update register for CFEND_RATE
Date:   Tue,  7 Mar 2023 17:50:15 +0100
Message-Id: <20230307170032.358807452@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 793445cf812506375cbe4c59d0fb9f648f716e88 ]

In newer chipsets, CFEND_RATE setting has been moved to different hw
module.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h | 15 ++++++++-------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0b3e28748e76b..ce4242f90e9f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1690,7 +1690,7 @@ void mt7996_mac_set_timing(struct mt7996_phy *phy)
 	else
 		val = MT7996_CFEND_RATE_11B;
 
-	mt76_rmw_field(dev, MT_AGG_ACR0(band_idx), MT_AGG_ACR_CFEND_RATE, val);
+	mt76_rmw_field(dev, MT_RATE_HRCR0(band_idx), MT_RATE_HRCR0_CFEND_RATE, val);
 	mt76_clear(dev, MT_ARB_SCR(band_idx),
 		   MT_ARB_SCR_TX_DISABLE | MT_ARB_SCR_RX_DISABLE);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 60781d046216a..d8a2c1a744b25 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -21,6 +21,7 @@ static const struct __base mt7996_reg_base[] = {
 	[WF_ETBF_BASE]		= { { 0x820ea000, 0x820fa000, 0x830ea000 } },
 	[WF_LPON_BASE]		= { { 0x820eb000, 0x820fb000, 0x830eb000 } },
 	[WF_MIB_BASE]		= { { 0x820ed000, 0x820fd000, 0x830ed000 } },
+	[WF_RATE_BASE]		= { { 0x820ee000, 0x820fe000, 0x830ee000 } },
 };
 
 static const struct __map mt7996_reg_map[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index 42980b97b4d41..7a28cae34e34b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -33,6 +33,7 @@ enum base_rev {
 	WF_ETBF_BASE,
 	WF_LPON_BASE,
 	WF_MIB_BASE,
+	WF_RATE_BASE,
 	__MT_REG_BASE_MAX,
 };
 
@@ -235,13 +236,6 @@ enum base_rev {
 						 FIELD_PREP(MT_WTBL_LMAC_ID, _id) | \
 						 FIELD_PREP(MT_WTBL_LMAC_DW, _dw))
 
-/* AGG: band 0(0x820e2000), band 1(0x820f2000), band 2(0x830e2000) */
-#define MT_WF_AGG_BASE(_band)			__BASE(WF_AGG_BASE, (_band))
-#define MT_WF_AGG(_band, ofs)			(MT_WF_AGG_BASE(_band) + (ofs))
-
-#define MT_AGG_ACR0(_band)			MT_WF_AGG(_band, 0x054)
-#define MT_AGG_ACR_CFEND_RATE			GENMASK(13, 0)
-
 /* ARB: band 0(0x820e3000), band 1(0x820f3000), band 2(0x830e3000) */
 #define MT_WF_ARB_BASE(_band)			__BASE(WF_ARB_BASE, (_band))
 #define MT_WF_ARB(_band, ofs)			(MT_WF_ARB_BASE(_band) + (ofs))
@@ -300,6 +294,13 @@ enum base_rev {
 #define MT_WF_RMAC_RSVD0(_band)			MT_WF_RMAC(_band, 0x03e0)
 #define MT_WF_RMAC_RSVD0_EIFS_CLR		BIT(21)
 
+/* RATE: band 0(0x820ee000), band 1(0x820fe000), band 2(0x830ee000) */
+#define MT_WF_RATE_BASE(_band)			__BASE(WF_RATE_BASE, (_band))
+#define MT_WF_RATE(_band, ofs)			(MT_WF_RATE_BASE(_band) + (ofs))
+
+#define MT_RATE_HRCR0(_band)			MT_WF_RATE(_band, 0x050)
+#define MT_RATE_HRCR0_CFEND_RATE		GENMASK(14, 0)
+
 /* WFDMA0 */
 #define MT_WFDMA0_BASE				0xd4000
 #define MT_WFDMA0(ofs)				(MT_WFDMA0_BASE + (ofs))
-- 
2.39.2



