Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99E450D74
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhKOR5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239293AbhKOR4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E467E61A70;
        Mon, 15 Nov 2021 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997634;
        bh=gQdn7PyHcTvAnt7sdUC8bD/Ij970g310DEyfN3367do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VG7gyPsRHY6XNirrD4AO5JoO5RMhvNKvylNyIv3esQd+7Rlg/3Wstc4LQzoh1x4sX
         vhXvdI8aD/HtNI7ZSOXz0TLF+UUhKMpSEIX1//rp+bwFjUjyrid3AJqwlY9dszMEh3
         wkfPhPjk3wbhbkKoHdrlmUNJZJLRC8SpJCZZn/2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/575] ath10k: high latency fixes for beacon buffer
Date:   Mon, 15 Nov 2021 17:58:32 +0100
Message-Id: <20211115165350.173331894@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

[ Upstream commit e263bdab9c0e8025fb7f41f153709a9cda51f6b6 ]

Beacon buffer for high latency devices does not use DMA. other similar
buffer allocation methods in the driver have already been modified for
high latency path. Fix the beacon buffer allocation left out in the
earlier high latency changes.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
[fabio: adapt it to use ar->bus_param.dev_type ]
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210818232627.2040121-1-festevam@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 31 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 36183fdfb7f03..90dc48f66fbfe 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -982,8 +982,12 @@ static void ath10k_mac_vif_beacon_cleanup(struct ath10k_vif *arvif)
 	ath10k_mac_vif_beacon_free(arvif);
 
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 }
@@ -5466,10 +5470,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC ||
 	    vif->type == NL80211_IFTYPE_MESH_POINT ||
 	    vif->type == NL80211_IFTYPE_AP) {
-		arvif->beacon_buf = dma_alloc_coherent(ar->dev,
-						       IEEE80211_MAX_FRAME_LEN,
-						       &arvif->beacon_paddr,
-						       GFP_ATOMIC);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
+			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
+						    GFP_KERNEL);
+			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
+		} else {
+			arvif->beacon_buf =
+				dma_alloc_coherent(ar->dev,
+						   IEEE80211_MAX_FRAME_LEN,
+						   &arvif->beacon_paddr,
+						   GFP_ATOMIC);
+		}
 		if (!arvif->beacon_buf) {
 			ret = -ENOMEM;
 			ath10k_warn(ar, "failed to allocate beacon buffer: %d\n",
@@ -5684,8 +5695,12 @@ err_vdev_delete:
 
 err:
 	if (arvif->beacon_buf) {
-		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
-				  arvif->beacon_buf, arvif->beacon_paddr);
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
+			kfree(arvif->beacon_buf);
+		else
+			dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
+					  arvif->beacon_buf,
+					  arvif->beacon_paddr);
 		arvif->beacon_buf = NULL;
 	}
 
-- 
2.33.0



