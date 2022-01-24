Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4CB49947D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388996AbiAXUkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385443AbiAXUdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD2BC07E294;
        Mon, 24 Jan 2022 11:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6861261482;
        Mon, 24 Jan 2022 19:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29597C340E5;
        Mon, 24 Jan 2022 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053509;
        bh=WCqmV5V7bA9Ezs5dDtJnZCm+j+H3lnDU0oaDy3hIKIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnGnXvNoylRzfJge4HSOq5tlA7cfwyuBCZ4VqET7tJgWkLgDXxWPQQR8lHoI6kAzz
         Q8DGzxvORENUE6X+sbRgzB9hMNehrsTcEQXwHcd77X5SiBwl5pSOeTZgzdj2wm1KxX
         G0bHa8Gon9oHj2L/GbaIKRnWyRHUchylSxYBowMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/563] ath11k: reset RSN/WPA present state for open BSS
Date:   Mon, 24 Jan 2022 19:37:33 +0100
Message-Id: <20220124184027.439684369@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 304e158f09751..b4f8494e3c707 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -792,11 +792,15 @@ static int ath11k_mac_setup_bcn_tmpl(struct ath11k_vif *arvif)
 
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



