Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D38345265A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359220AbhKPCFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239552AbhKOSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CE46334A;
        Mon, 15 Nov 2021 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997812;
        bh=CSJUZH0FSSeR/W/kPQ0nzZAg9YfJrrAfzzxrBcEGhZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0XaYEggacwSdMyC/4De0JEVLXleSkZQxkkSjUYYVw5ejyRQGcMUdrDI6oqWHwpJE
         QgBH/prK4jDRQq/ZR1bsKLP6iWEXLLJ9W9+QXHgcEosSpA2DtfPha7hhK/mPlulgFa
         pfqHS5XXSbzmrJaQBWiws2YivyeT58ze38C79ZBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/575] ath10k: Fix missing frame timestamp for beacon/probe-resp
Date:   Mon, 15 Nov 2021 18:00:08 +0100
Message-Id: <20211115165353.561649010@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit e6dfbc3ba90cc2b619229be56b485f085a0a8e1c ]

When receiving a beacon or probe response, we should update the
boottime_ns field which is the timestamp the frame was received at.
(cf mac80211.h)

This fixes a scanning issue with Android since it relies on this
timestamp to determine when the AP has been seen for the last time
(via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).

Fixes: 5e3dd157d7e7 ("ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1629811733-7927-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 37b53af760d76..85fe855ece097 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2610,6 +2610,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (ieee80211_is_beacon(hdr->frame_control))
 		ath10k_mac_handle_beacon(ar, skb);
 
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		status->boottime_ns = ktime_get_boottime_ns();
+
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
-- 
2.33.0



