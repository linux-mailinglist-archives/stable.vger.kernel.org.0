Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7535450DD1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhKOSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhKOSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896176334D;
        Mon, 15 Nov 2021 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997815;
        bh=smzL/0WohvzhaRRKxwUNT9IJSFgBYfCQejHPZ4BW+Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whOTAwQe1QLcu4UxSHKmct2PjngV6rGhq+yUkK7av8LGLsJ1ORUPTgr2Kd9GLedIF
         2dbO89P/WXEChYg0IWa5eplR08kHAQDWw8eRTGRsBdyXwxUmF9aN7f8iwg/STaUhS7
         z6s5iwrcWlYmHnuoov0+UiLnVCzs9YT22t4VUtSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/575] ath10k: sdio: Add missing BH locking around napi_schdule()
Date:   Mon, 15 Nov 2021 18:00:09 +0100
Message-Id: <20211115165353.599752296@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 019edd01d174ce4bb2e517dd332922514d176601 ]

On a i.MX-based board with a QCA9377 Wifi chip, the following errors
are seen after launching the 'hostapd' application:

hostapd /etc/wifi.conf
Configuration file: /etc/wifi.conf
wlan0: interface state UNINITIALIZED->COUNTRY_UPDATE
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
Using interface wlan0 with hwaddr 00:1f:7b:31:04:a0 and ssid "thessid"
IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: interface state COUNTRY_UPDATE->ENABLED
wlan0: AP-ENABLED
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
...

Fix this problem by adding the BH locking around napi-schedule(),
in the same way it was done in commit e63052a5dd3c ("mlx5e: add
add missing BH locking around napi_schdule()").

Its commit log provides the following explanation:

"It's not correct to call napi_schedule() in pure process
context. Because we use __raise_softirq_irqoff() we require
callers to be in a context which will eventually lead to
softirq handling (hardirq, bh disabled, etc.).

With code as is users will see:

NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
"

Fixes: cfee8793a74d ("ath10k: enable napi on RX path for sdio")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210824144339.2796122-1-festevam@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 81ddaafb6721c..0fe639710a8bb 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1363,8 +1363,11 @@ static void ath10k_rx_indication_async_work(struct work_struct *work)
 		ep->ep_ops.ep_rx_complete(ar, skb);
 	}
 
-	if (test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags))
+	if (test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags)) {
+		local_bh_disable();
 		napi_schedule(&ar->napi);
+		local_bh_enable();
+	}
 }
 
 static int ath10k_sdio_read_rtc_state(struct ath10k_sdio *ar_sdio, unsigned char *state)
-- 
2.33.0



