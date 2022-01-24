Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3544499FA9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841985AbiAXXAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835925AbiAXWhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349ACC05486B;
        Mon, 24 Jan 2022 12:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1A5CB811FB;
        Mon, 24 Jan 2022 20:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA694C340E5;
        Mon, 24 Jan 2022 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057984;
        bh=ZAAVcAfRBcJykvbAOIAdnOcapjFkib2az6P5abi5NX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1nelFjewmZ37pP7RyZcGdO/Kbc4U0FVJ2vQ6Z8dSNoGGCtfcqIZ1PCanB8JeUu1v
         SUKAoqcPVNWuWGusJhJe/hQP49zAfRyAfJM07MmlXNg2kU7xMYq5fwB79s3l5Fi3e0
         CD0RjJGU9KWsezBns5TL2B38aCOV3HQUkelkHgMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0143/1039] ath11k: reset RSN/WPA present state for open BSS
Date:   Mon, 24 Jan 2022 19:32:12 +0100
Message-Id: <20220124184129.982882234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karthikeyan Kathirvel <kathirve@codeaurora.org>

[ Upstream commit 64bc3aa02ae78b1fcb1b850e0eb1f0622002bfaa ]

The ath11k driver is caching the information about RSN/WPA IE in the
configured beacon template. The cached information is used during
associations to figure out whether 4-way PKT/2-way GTK peer flags need to
be set or not.

But the code never cleared the state when no such IE was found. This can
for example happen when moving from an WPA/RSN to an open setup. The
(seemingly connected) peer was then not able to communicate over the
link because the firmware assumed a different (encryption enabled) state
for the peer.

Tested-on: IPQ6018 hw1.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Fixes: 01e34233c645 ("ath11k: fix wmi peer flags in peer assoc command")
Cc: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Reported-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Karthikeyan Kathirvel <kathirve@codeaurora.org>
[sven@narfation.org: split into separate patches, clean up commit message]
Signed-off-by: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211115100441.33771-2-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index cdee7545e876a..9ed7eb09bdb70 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1137,11 +1137,15 @@ static int ath11k_mac_setup_bcn_tmpl(struct ath11k_vif *arvif)
 
 	if (cfg80211_find_ie(WLAN_EID_RSN, ies, (skb_tail_pointer(bcn) - ies)))
 		arvif->rsnie_present = true;
+	else
+		arvif->rsnie_present = false;
 
 	if (cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
 				    WLAN_OUI_TYPE_MICROSOFT_WPA,
 				    ies, (skb_tail_pointer(bcn) - ies)))
 		arvif->wpaie_present = true;
+	else
+		arvif->wpaie_present = false;
 
 	ret = ath11k_wmi_bcn_tmpl(ar, arvif->vdev_id, &offs, bcn);
 
-- 
2.34.1



