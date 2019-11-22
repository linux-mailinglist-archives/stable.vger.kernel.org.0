Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280C4106A38
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfKVKct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:32:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbfKVKcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:32:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962422071C;
        Fri, 22 Nov 2019 10:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418768;
        bh=tOHwYIJ+ZNa6Ys/BfqqTmWqfcuoUDV1G9q0KLw6kepc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1KyK+yMBXaetiAb6GfOA5iBGKw56dc25MHB6HmEaUgihKqFmisQTQAccgd18BmZj
         6cu+QG1XIraJe/045BC+dKMBdPL0w+0maoQuJZZ4AShLgM9nnmsnMHt4Xba6Th0Fwl
         JLN/LCBZ7MK/J+adFM3tapS79qxfnfocwc+H/BlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Stromdahl <erik.stromdahl@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 028/159] ath10k: wmi: disable softirqs while calling ieee80211_rx
Date:   Fri, 22 Nov 2019 11:26:59 +0100
Message-Id: <20191122100725.950086268@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Stromdahl <erik.stromdahl@gmail.com>

[ Upstream commit 37f62c0d5822f631b786b29a1b1069ab714d1a28 ]

This is done in order not to trig the below warning in
ieee80211_rx_napi:

WARN_ON_ONCE(softirq_count() == 0);

ieee80211_rx_napi requires that softirq's are disabled during
execution.

The High latency bus drivers (SDIO and USB) sometimes call the wmi
ep_rx_complete callback from non softirq context, resulting in a trigger
of the above warning.

Calling ieee80211_rx_ni with softirq's already disabled (e.g., from
softirq context) should be safe as the local_bh_disable and
local_bh_enable functions (called from ieee80211_rx_ni) are fully
reentrant.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b867875aa6e66..f7ce99f67b5c5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2294,7 +2294,8 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
-	ieee80211_rx(ar->hw, skb);
+	ieee80211_rx_ni(ar->hw, skb);
+
 	return 0;
 }
 
-- 
2.20.1



