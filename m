Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2059B6AE95D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCGRXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjCGRWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AA28C95F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 631A6B819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884A4C433D2;
        Tue,  7 Mar 2023 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209507;
        bh=XZ9HTAvo0x22qKyDDdWG5QvDjbkL5LZhMMCqYzMnGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3uM+HyLz/j+ipKzKoV3z+rKkFtZXEE0hWqYWlhfzrTTzbFusdvQJVcrI20Lt/iBH
         hY6y3yNLtFQpj1DkO3nuqXohDi5xRgJfRfyBXj9j673MH2JcAA7WVFKhXRRDEKSBRP
         5XeU5p7KkCd0edP4k0FowZwV5KsMGq3XUqzm1gKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0241/1001] wifi: mt76: mt7921: fix channel switch fail in monitor mode
Date:   Tue,  7 Mar 2023 17:50:13 +0100
Message-Id: <20230307170032.279305425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 914189af23b83c9a83a0137a3a40f17de7d2c618 ]

When the chanctx enabled, IEEE80211_CONF_CHANGE_CHANNEL in .config()
would not be called anymore. mt76 cannot control RF channel for monitor.
Add monitor type set-channel flow in .change_chanctx().

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  5 +-
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 68 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 +
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 722df8eea91f7..cdb0d61903935 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1706,7 +1706,10 @@ static void mt7921_ctx_iter(void *priv, u8 *mac,
 	if (ctx != mvif->ctx)
 		return;
 
-	mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->mt76, ctx);
+	if (vif->type & NL80211_IFTYPE_MONITOR)
+		mt7921_mcu_config_sniffer(mvif, ctx);
+	else
+		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->mt76, ctx);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index fb9c0f66cb27c..bd929b5f2504f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1093,6 +1093,74 @@ int mt7921_mcu_set_sniffer(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 				 true);
 }
 
+int mt7921_mcu_config_sniffer(struct mt7921_vif *vif,
+			      struct ieee80211_chanctx_conf *ctx)
+{
+	struct cfg80211_chan_def *chandef = &ctx->def;
+	int freq1 = chandef->center_freq1, freq2 = chandef->center_freq2;
+	const u8 ch_band[] = {
+		[NL80211_BAND_2GHZ] = 1,
+		[NL80211_BAND_5GHZ] = 2,
+		[NL80211_BAND_6GHZ] = 3,
+	};
+	const u8 ch_width[] = {
+		[NL80211_CHAN_WIDTH_20_NOHT] = 0,
+		[NL80211_CHAN_WIDTH_20] = 0,
+		[NL80211_CHAN_WIDTH_40] = 0,
+		[NL80211_CHAN_WIDTH_80] = 1,
+		[NL80211_CHAN_WIDTH_160] = 2,
+		[NL80211_CHAN_WIDTH_80P80] = 3,
+		[NL80211_CHAN_WIDTH_5] = 4,
+		[NL80211_CHAN_WIDTH_10] = 5,
+		[NL80211_CHAN_WIDTH_320] = 6,
+	};
+	struct {
+		struct {
+			u8 band_idx;
+			u8 pad[3];
+		} __packed hdr;
+		struct config_tlv {
+			__le16 tag;
+			__le16 len;
+			u16 aid;
+			u8 ch_band;
+			u8 bw;
+			u8 control_ch;
+			u8 sco;
+			u8 center_ch;
+			u8 center_ch2;
+			u8 drop_err;
+			u8 pad[3];
+		} __packed tlv;
+	} __packed req = {
+		.hdr = {
+			.band_idx = vif->mt76.band_idx,
+		},
+		.tlv = {
+			.tag = cpu_to_le16(1),
+			.len = cpu_to_le16(sizeof(req.tlv)),
+			.control_ch = chandef->chan->hw_value,
+			.center_ch = ieee80211_frequency_to_channel(freq1),
+			.drop_err = 1,
+		},
+	};
+	if (chandef->chan->band < ARRAY_SIZE(ch_band))
+		req.tlv.ch_band = ch_band[chandef->chan->band];
+	if (chandef->width < ARRAY_SIZE(ch_width))
+		req.tlv.bw = ch_width[chandef->width];
+
+	if (freq2)
+		req.tlv.center_ch2 = ieee80211_frequency_to_channel(freq2);
+
+	if (req.tlv.control_ch < req.tlv.center_ch)
+		req.tlv.sco = 1; /* SCA */
+	else if (req.tlv.control_ch > req.tlv.center_ch)
+		req.tlv.sco = 3; /* SCB */
+
+	return mt76_mcu_send_msg(vif->phy->mt76->dev, MCU_UNI_CMD(SNIFFER),
+				 &req, sizeof(req), true);
+}
+
 int
 mt7921_mcu_uni_add_beacon_offload(struct mt7921_dev *dev,
 				  struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 15d6b7fe1c6c8..d4cfa26c373c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -529,6 +529,8 @@ void mt7921_set_ipv6_ns_work(struct work_struct *work);
 
 int mt7921_mcu_set_sniffer(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 			   bool enable);
+int mt7921_mcu_config_sniffer(struct mt7921_vif *vif,
+			      struct ieee80211_chanctx_conf *ctx);
 
 int mt7921_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				   enum mt76_txq_id qid, struct mt76_wcid *wcid,
-- 
2.39.2



