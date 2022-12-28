Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB5D657CFC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiL1PiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiL1PiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:38:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440221659A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD3FEB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5CEC433D2;
        Wed, 28 Dec 2022 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241886;
        bh=WdydrDjmFfmFi2uwdAoP3asV+PVKKKriPAKw0MdvNAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdScqF2N2jTPT3pWJHxDU/LyeVPOnJJPvsDFG03rR0CiiTYFSLvBvJt/PGjmm6jAq
         9oLKV128YIl20W77KFvTWK+dZ+pgMOWcmq6hrETvZMcip4hKRQmgubZEuSiEkeGC5L
         SYFnh/TP7c5KFIwahFQ85ByNVww3Mb2cab2xVboY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0301/1146] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
Date:   Wed, 28 Dec 2022 15:30:40 +0100
Message-Id: <20221228144338.316185921@linuxfoundation.org>
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
index 0f3a80f66b61..ead4d4e04328 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -466,7 +466,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
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
index c61f83a7333b..c7460fbba014 100644
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



