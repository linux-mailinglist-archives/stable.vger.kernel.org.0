Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A190D6578CC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiL1Oy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiL1OyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD9F3B3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECDD61544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1254EC433D2;
        Wed, 28 Dec 2022 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239258;
        bh=a/wLJ97HZrYzmsj7pNmmK+UOr4Bw3OLWE45N67egTyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leMdRjjAVAUKwpY6g4ElYh4CsK36iewTJMlTK587T3WfTo2K9LyY7Unj3FKrMjG6i
         FVNPddPFHn9QiiRNwlPNlaDd1j23KzW8AYAZmtD+CvtQGiH6oaHmu6+xy3Dat1qVuW
         w+c49gQK9UK9ylYcTTKtdj0PGks5ogMjTfLPdF60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/731] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
Date:   Wed, 28 Dec 2022 15:34:55 +0100
Message-Id: <20221228144302.009460362@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit b8f6efccbb9dc0ff5dee7e20d69a4747298ee603 ]

When using wpa_supplicant v2.10, this driver is no longer able to
associate with any AP and fails in the EAPOL 4-way handshake while
sending the 2/4 message to the AP. The problem is not present in
wpa_supplicant v2.9 or older. The problem stems from HostAP commit
144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
which changes the way EAPOL frames are sent, from them being send
at L2 frames to them being sent via nl80211 control port.

An EAPOL frame sent as L2 frame is passed to the WiFi driver with
skb->protocol ETH_P_PAE, while EAPOL frame sent via nl80211 control
port has skb->protocol set to ETH_P_802_3 . The later happens in
ieee80211_tx_control_port(), where the EAPOL frame is encapsulated
into 802.3 frame.

The rsi_91x driver handles ETH_P_PAE EAPOL frames as high-priority
frames and sends them via highest-priority transmit queue, while
the ETH_P_802_3 frames are sent as regular frames. The EAPOL 4-way
handshake frames must be sent as highest-priority, otherwise the
4-way handshake times out.

Therefore, to fix this problem, inspect the skb control flags and
if flag IEEE80211_TX_CTRL_PORT_CTRL_PROTO is set, assume this is
an EAPOL frame and transmit the frame via high-priority queue just
like other ETH_P_PAE frames.

Fixes: 0eb42586cf87 ("rsi: data packet descriptor enhancements")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221104163339.227432-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 4 +++-
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 6bfaab48b507..6b64a103f39f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -465,7 +465,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 							      tid, 0);
 			}
 		}
-		if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+
+		if (IEEE80211_SKB_CB(skb)->control.flags &
+		    IEEE80211_TX_CTRL_PORT_CTRL_PROTO) {
 			q_num = MGMT_SOFT_Q;
 			skb->priority = q_num;
 		}
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index dca81a4bbdd7..30d2eccbcadd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -162,12 +162,16 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	u8 header_size;
 	u8 vap_id = 0;
 	u8 dword_align_bytes;
+	bool tx_eapol;
 	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
 	vif = info->control.vif;
 	tx_params = (struct skb_info *)info->driver_data;
 
+	tx_eapol = IEEE80211_SKB_CB(skb)->control.flags &
+		   IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+
 	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
@@ -231,7 +235,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		}
 	}
 
-	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+	if (tx_eapol) {
 		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");
 
 		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
-- 
2.35.1



