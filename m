Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034D260412F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiJSKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiJSKjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:39:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ECE15626B;
        Wed, 19 Oct 2022 03:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A4DFB822D8;
        Wed, 19 Oct 2022 08:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E80C433C1;
        Wed, 19 Oct 2022 08:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169467;
        bh=mq8aG3PtaIpytEmkRarYYnE2UdSfF3zSy5rZl30dsz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwHvII86Pg6LdAFn/a6yjs+dgURQ5+7duyhvgHtzqtKxDnhMcTjPYBrPmWpDWsouG
         hb9sH+sXSKeHwe4G5vX2+a8Ex102p6eR7voyjYi6SPBA0SplU1m6oTa+Cvt3VjvoYA
         s9jHc0dCGNjf8nW8RJvAD25tDovrhmY7gdU/LmUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 287/862] wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_sta_set_decap_offload
Date:   Wed, 19 Oct 2022 10:26:14 +0200
Message-Id: <20221019083302.689314366@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 59c20b91786d5f140ee7be2f24c242b5f8986046 ]

Add mt7921_mutex_acquire at mt7921_[start, stop]_ap to fix the race
with the context holding dev->muxtex and the driver might access the
device in low power state.

Fixes: 24299fc869f7 ("mt76: mt7921: enable rx header traslation offload")
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 63fd33dcd3af..7214735011d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1404,6 +1404,8 @@ static void mt7921_sta_set_decap_offload(struct ieee80211_hw *hw,
 	struct mt7921_sta *msta = (struct mt7921_sta *)sta->drv_priv;
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 
+	mt7921_mutex_acquire(dev);
+
 	if (enabled)
 		set_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid.flags);
 	else
@@ -1411,6 +1413,8 @@ static void mt7921_sta_set_decap_offload(struct ieee80211_hw *hw,
 
 	mt76_connac_mcu_sta_update_hdr_trans(&dev->mt76, vif, &msta->wcid,
 					     MCU_UNI_CMD(STA_REC_UPDATE));
+
+	mt7921_mutex_release(dev);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.35.1



