Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FE12F089
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbfE3DRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731241AbfE3DRp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABFBE246F4;
        Thu, 30 May 2019 03:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186264;
        bh=6QpzbCYWRPZJFeldcE3ktARIpqyvLNnqWXqDwDhS1JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9Dp81mRDaLUJkpxtA+r3Egoc7el598+cxsDVtwnVbyl2HJBVhxOaCBA1G+ZcFanH
         uHILY6kbzuDS9BNGpQMf8Rdve2JfHvgB/JVwZ5sdwC9mCTdXSVrJA29sOiI7AYYGAC
         CF09jbvt5N9S+pgvSZOHEQNpnndV1cl0b+uGvbAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 200/276] rtlwifi: fix potential NULL pointer dereference
Date:   Wed, 29 May 2019 20:05:58 -0700
Message-Id: <20190530030537.617010332@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 60209d482b97743915883d293c8b85226d230c19 ]

In case dev_alloc_skb fails, the fix safely returns to avoid
potential NULL pointer dereference.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c       | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c       | 4 ++++
 6 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
index 63874512598bb..b5f91c994c798 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -622,6 +622,8 @@ void rtl88e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index f3bff66e85d0c..81ec0e6e07c1f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -646,6 +646,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	if (cmd_send_packet)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 84a0d0eb72e1e..a933490928ba9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -766,6 +766,8 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
index bf9859f74b6f5..52f108744e969 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
@@ -470,6 +470,8 @@ void rtl8723e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index f2441fbb92f1e..307c2bd77f060 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -584,6 +584,8 @@ void rtl8723be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, sizeof(u1rsvdpageloc));
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index d868a034659fb..d7235f6165fdf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1645,6 +1645,8 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8812[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8812, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
@@ -1781,6 +1783,8 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8821[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8821, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
-- 
2.20.1



