Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712B8106AFB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfKVKkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbfKVKkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D9C820717;
        Fri, 22 Nov 2019 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419220;
        bh=Kx5WbgmCL5mfO8gSfx6FdAr1u5gtEdfOWa2t00s3loc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uL4XCYx0WGIsftveOaSamaEpk5Y7T6FgRcYEFrbg85N3hxdfv8eH8roly/6apw7nk
         mIUMKfjV6L1x3rCZbjgnnJA/cv1dG5zNfIJuBVbae/u6nuFvAzFEH+daagf/DNzrql
         0d2RWE9Blz4nl49BHyex95Ly5V9NzG2+Ob/BnbVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Stromdahl <erik.stromdahl@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 039/222] ath10k: wmi: disable softirqs while calling ieee80211_rx
Date:   Fri, 22 Nov 2019 11:26:19 +0100
Message-Id: <20191122100848.969878741@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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
index bbfe7be214e12..c208fed048554 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2384,7 +2384,8 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		   status->freq, status->band, status->signal,
 		   status->rate_idx);
 
-	ieee80211_rx(ar->hw, skb);
+	ieee80211_rx_ni(ar->hw, skb);
+
 	return 0;
 }
 
-- 
2.20.1



