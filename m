Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EBD4998FE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453906AbiAXVbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450847AbiAXVVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA1FC0604DC;
        Mon, 24 Jan 2022 12:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95B25B8122A;
        Mon, 24 Jan 2022 20:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DC2C340E5;
        Mon, 24 Jan 2022 20:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055368;
        bh=RaMl5+ISXyTRiKTb8Ed11NgVfcYQt+qBb892HL6Q3T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ8laAa6YE94NZWFmubzh1aio0qEdqigYEW8v2jCMysJ5Wa/dRGo/QM4sRPikxnJ+
         AX6W7gOThZ2MW86rn5txYbqBf0WgPF2WWqTXfq8xpZy8IE5qjgMzGWbwxeemhp0c74
         0n0BUYQR2b7CFnBeNSkK+c0bLyK7Hkysp7Z3rpl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/846] ath11k: reset RSN/WPA present state for open BSS
Date:   Mon, 24 Jan 2022 19:34:06 +0100
Message-Id: <20220124184105.443452636@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index aac10740f5752..2df60c74809d3 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -767,11 +767,15 @@ static int ath11k_mac_setup_bcn_tmpl(struct ath11k_vif *arvif)
 
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



