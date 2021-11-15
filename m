Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEC6450BC7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhKOR3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237846AbhKOR0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE69961452;
        Mon, 15 Nov 2021 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996584;
        bh=wfmODWx8KWlxOZj3IvM5a5c7Q5tg+UCCdlTR8q5L97A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRvT1kBc2tJoE+QNZQ4LmSEH9Lhif/8K30uddczaKK5lkdK/vTowQPC3fj5Nm4jeQ
         aWE3mQAPy8IX80+OSySDrl+mm8SAQQeV5Kc66EC4E4W/Lh3s7/VVD4XitF8Wt0ruae
         +uGOf0w+gb4OGi/u5EhXXVXkKrKyUbBL1ZrycIxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/355] ath10k: Fix missing frame timestamp for beacon/probe-resp
Date:   Mon, 15 Nov 2021 18:01:57 +0100
Message-Id: <20211115165320.011812320@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 91604a14a8f46..796bd93c599b1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2541,6 +2541,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
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



