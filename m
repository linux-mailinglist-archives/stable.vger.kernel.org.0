Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD01060A8B0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiJXNKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbiJXNJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD380A0245;
        Mon, 24 Oct 2022 05:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD1C61218;
        Mon, 24 Oct 2022 12:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32219C433D6;
        Mon, 24 Oct 2022 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614150;
        bh=4mDMvFXGpgDf50KKWVQFhIoxYos5GNWsfBZoo4/SHNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKyUj5OcL+gSYzMO3aLHASRiJUP4+GlDOBptup2I9a1rPLUXcDgYsXhyZsAtbSlv4
         qbqhLPRJmETl6qjrEqXJqKv2QISWefoiBRneRxqPlq5oRfchBop4MmGYtp9dic3MlU
         xJZAQOFiRiQ2DBtOjzMcwwTAahIkpb/pVjzqAkgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesus Fernandez Manzano <jesus.manzano@galgus.net>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/390] wifi: ath11k: fix number of VHT beamformee spatial streams
Date:   Mon, 24 Oct 2022 13:28:38 +0200
Message-Id: <20221024113027.816036777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 44282aec069d..67faf62999de 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3419,6 +3419,8 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 	if (vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)) {
 		nsts = vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 		nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		if (nsts > (ar->num_rx_chains - 1))
+			nsts = ar->num_rx_chains - 1;
 		value |= SM(nsts, WMI_TXBF_STS_CAP_OFFSET);
 	}
 
@@ -3459,7 +3461,7 @@ static int ath11k_mac_set_txbf_conf(struct ath11k_vif *arvif)
 static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 {
 	bool subfer, subfee;
-	int sound_dim = 0;
+	int sound_dim = 0, nsts = 0;
 
 	subfer = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE));
 	subfee = !!(*vht_cap & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE));
@@ -3469,6 +3471,11 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
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
@@ -3481,7 +3488,9 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 	sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 	*vht_cap &= ~IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
 
-	/* TODO: Need to check invalid STS and Sound_dim values set by FW? */
+	nsts = (*vht_cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK);
+	nsts >>= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+	*vht_cap &= ~IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
 	/* Enable Sounding Dimension Field only if SU BF is enabled */
 	if (subfer) {
@@ -3493,9 +3502,15 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
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



