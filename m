Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E1729AFA6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756214AbgJ0OMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754856AbgJ0OHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:07:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEAEC2072D;
        Tue, 27 Oct 2020 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807645;
        bh=W4SVHfnlniV+OzCG2/5tioMg3s7Sslnwjj8C4Q635yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgmXOk8Y7LRqTQcJzWh2o6VwIN+qNz9qG/x/aEJc8w7zW0DYXLXxVtFaLRRkOcuY9
         7Lh9BtxxJdVQAMU2IhT/FyGyUdWfnRcnS9b0s4AB9L64ewgEIYDBQ7yAV8ccKe5fdb
         ZFezzrJeyGM/cauIPRlRSM8UYGJ0YetxInSRTYnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/139] rtl8xxxu: prevent potential memory leak
Date:   Tue, 27 Oct 2020 14:50:21 +0100
Message-Id: <20201027134908.177231508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit 86279456a4d47782398d3cb8193f78f672e36cac ]

Free the skb if usb_submit_urb fails on rx_urb. And free the urb
no matter usb_submit_urb succeeds or not in rtl8xxxu_submit_int_urb.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200906040424.22022-1-chiu@endlessm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 18d5984b78dab..e73613b9f2f59 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5422,7 +5422,6 @@ static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		usb_free_urb(urb);
 		goto error;
 	}
 
@@ -5431,6 +5430,7 @@ static int rtl8xxxu_submit_int_urb(struct ieee80211_hw *hw)
 	rtl8xxxu_write32(priv, REG_USB_HIMR, val32);
 
 error:
+	usb_free_urb(urb);
 	return ret;
 }
 
@@ -5756,6 +5756,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
+	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -5806,6 +5807,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		rx_urb->hw = hw;
 
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
+		if (ret) {
+			if (ret != -ENOMEM) {
+				skb = (struct sk_buff *)rx_urb->urb.context;
+				dev_kfree_skb(skb);
+			}
+			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+		}
 	}
 exit:
 	/*
-- 
2.25.1



