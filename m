Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1676086E3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiJVHzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiJVHxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:53:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DAF2CA7DF;
        Sat, 22 Oct 2022 00:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61C8FB82E25;
        Sat, 22 Oct 2022 07:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8BEC433C1;
        Sat, 22 Oct 2022 07:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424764;
        bh=0OomcN+6Xegv5qPSVKWmYj5hvP0ZwQmGX72HULQDYjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ActyNUO6elPBw+Tmtj6DaUxcAbXNeFwBPofTbUdU5r1VmWy/c+YcpBABVfMmVSBPz
         aEuoHDM3y7HBpVmxU09IiasFIMMwYcDJc0xNwFRJdT4GxXuICVsgnbe1CHK2kIxI5M
         ZM138nbVlfYXMjm92mmkX9GZ7T3+nRilQ0xnaHm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesus Fernandez Manzano <jesus.manzano@galgus.net>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 260/717] wifi: ath11k: fix number of VHT beamformee spatial streams
Date:   Sat, 22 Oct 2022 09:22:19 +0200
Message-Id: <20221022072500.677344792@linuxfoundation.org>
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

From: Jesus Fernandez Manzano <jesus.manzano@galgus.net>

[ Upstream commit 55b5ee3357d7bb98ee578cf9b84a652e7a1bc199 ]

The number of spatial streams used when acting as a beamformee in VHT
mode are reported by the firmware as 7 (8 sts - 1) both in IPQ6018 and
IPQ8074 which respectively have 2 and 4 sts each. So the firmware should
report 1 (2 - 1) and 3 (4 - 1).

Fix this by checking that the number of VHT beamformee sts reported by
the firmware is not greater than the number of receiving antennas - 1.
The fix is based on the same approach used in this same function for
sanitizing the number of sounding dimensions reported by the firmware.

Without this change, acting as a beamformee in VHT mode is not working
properly.

Tested-on: IPQ6018 hw1.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jesus Fernandez Manzano <jesus.manzano@galgus.net>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220616173947.21901-1-jesus.manzano@galgus.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 06b86dcc3826..94d9a7190953 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4949,6 +4949,8 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 	if (vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)) {
 		nsts = vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 		nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		if (nsts > (ar->num_rx_chains - 1))
+			nsts = ar->num_rx_chains - 1;
 		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 	}
 
@@ -4989,7 +4991,7 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 {
 	bool subfer, subfee;
-	int sound_dim = 0;
+	int sound_dim = 0, nsts = 0;
 
 	subfer = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE));
 	subfee = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE));
@@ -4999,6 +5001,11 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 		subfer = false;
 	}
 
+	if (ar->num_rx_chains < 2) {
+		*vht_cap &= ~(IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE);
+		subfee = false;
+	}
+
 	/* If SU Beaformer is not set, then disable MU Beamformer Capability */
 	if (!subfer)
 		*vht_cap &= ~(IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE);
@@ -5011,7 +5018,9 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 	*vht_cap &= ~IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
 
-	/* TODO: Need to check invalid STS and Sound_dim values set by FW? */
+	nsts = (*vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
+	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+	*vht_cap &= ~IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
 	/* Enable Sounding Dimension Field only if SU BF is enabled */
 	if (subfer) {
@@ -5023,9 +5032,15 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 		*vht_cap |= sound_dim;
 	}
 
-	/* Use the STS advertised by FW unless SU Beamformee is not supported*/
-	if (!subfee)
-		*vht_cap &= ~(IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
+	/* Enable Beamformee STS Field only if SU BF is enabled */
+	if (subfee) {
+		if (nsts > (ar->num_rx_chains - 1))
+			nsts = ar->num_rx_chains - 1;
+
+		nsts <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		nsts &=  IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+		*vht_cap |= nsts;
+	}
 }
 
 static struct ieee80211_sta_vht_cap
-- 
2.35.1



