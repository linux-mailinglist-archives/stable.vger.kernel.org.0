Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76B5949FB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355409AbiHOX4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355931AbiHOXxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:53:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC847C694E;
        Mon, 15 Aug 2022 13:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E1F9B81180;
        Mon, 15 Aug 2022 20:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71315C433C1;
        Mon, 15 Aug 2022 20:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594660;
        bh=AdxVgbtTJsF2IQ+9ibzYx6Y6HoJF5R+Vmz7gu23cD4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wTJL//cRbnAISOk6P6LyfjMtlYKsmIr+sOFREp/vT9uZaHDZIaJ4f7AanMxkClI+
         4blXENUvXj2lijXWjk1sO29PBK06FjOinF/a8UcoNkfw7VgCDRhxbc4z+Bd9Gc57FQ
         yk88q8cvpLz51w+NkhRHCmpnH5cNMSigEunqLJXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0485/1157] mt76: mt7915: fix incorrect testmode ipg on band 1 caused by wmm_idx
Date:   Mon, 15 Aug 2022 19:57:21 +0200
Message-Id: <20220815180459.017553126@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 6e744cfeee02c2d8676eb55d5b3720808812f41f ]

Fix the issue that the measured inter packet gap didn't fit its
setting value.

Fixes: c2d3b1926f30 ("mt76: mt7915: add support for ipg in testmode")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/testmode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index 20f63644e929..0f5c1e5bffe1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -168,13 +168,14 @@ mt7915_tm_set_tam_arb(struct mt7915_phy *phy, bool enable, bool mu)
 }
 
 static int
-mt7915_tm_set_wmm_qid(struct mt7915_dev *dev, u8 qid, u8 aifs, u8 cw_min,
+mt7915_tm_set_wmm_qid(struct mt7915_phy *phy, u8 qid, u8 aifs, u8 cw_min,
 		      u16 cw_max, u16 txop)
 {
+	struct mt7915_vif *mvif = (struct mt7915_vif *)phy->monitor_vif->drv_priv;
 	struct mt7915_mcu_tx req = { .total = 1 };
 	struct edca *e = &req.edca[0];
 
-	e->queue = qid;
+	e->queue = qid + mvif->mt76.wmm_idx * MT76_CONNAC_MAX_WMM_SETS;
 	e->set = WMM_PARAM_SET;
 
 	e->aifs = aifs;
@@ -182,7 +183,7 @@ mt7915_tm_set_wmm_qid(struct mt7915_dev *dev, u8 qid, u8 aifs, u8 cw_min,
 	e->cw_max = cpu_to_le16(cw_max);
 	e->txop = cpu_to_le16(txop);
 
-	return mt7915_mcu_update_edca(dev, &req);
+	return mt7915_mcu_update_edca(phy->dev, &req);
 }
 
 static int
@@ -244,7 +245,7 @@ mt7915_tm_set_ipg_params(struct mt7915_phy *phy, u32 ipg, u8 mode)
 
 	mt7915_tm_set_slot_time(phy, slot_time, sifs);
 
-	return mt7915_tm_set_wmm_qid(dev,
+	return mt7915_tm_set_wmm_qid(phy,
 				     mt76_connac_lmac_mapping(IEEE80211_AC_BE),
 				     aifsn, cw, cw, 0);
 }
-- 
2.35.1



