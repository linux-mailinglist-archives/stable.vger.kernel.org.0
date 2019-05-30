Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63A62F56B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfE3ErK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfE3DLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278C6244FC;
        Thu, 30 May 2019 03:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185894;
        bh=BqZZIOycs8gGcPlEI9PbI3jL2AyLpyzb+4LwIR0Nejw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Prff8fS6DEMPnHnXaVYKkBX3XOfzMx4kQfIJoWQfdTKc25PT22srVYlQF7zYS6xYe
         PH1LbmUeI0YUdZXi5vkV/NKrv4CKYIYO/ndoT75lMgPU95zNnkHdCvuH/+pfkmhYKS
         eaMCLClYu1aTLJoNcaPybfXTSgJU7QSh+0JbHyRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 257/405] rtlwifi: fix potential NULL pointer dereference
Date:   Wed, 29 May 2019 20:04:15 -0700
Message-Id: <20190530030553.975429029@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 203e7b574e845..e2e0bfbc24fe2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
@@ -600,6 +600,8 @@ void rtl88e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 18c76990a0898..86b1b88cc4ed8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -623,6 +623,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	if (cmd_send_packet)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 7c5b54b71a92f..67305ce915ec4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -744,6 +744,8 @@ void rtl92ee_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
index be451a6f7dbe5..33481232fad01 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
@@ -448,6 +448,8 @@ void rtl8723e_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 4d7fa27f55caa..aa56058af56ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -562,6 +562,8 @@ void rtl8723be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, sizeof(u1rsvdpageloc));
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index dc0eb692088f6..fe32d397d2875 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1623,6 +1623,8 @@ void rtl8812ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8812[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8812, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
@@ -1759,6 +1761,8 @@ void rtl8821ae_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      &reserved_page_packet_8821[0], totalpacketlen);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	skb_put_data(skb, &reserved_page_packet_8821, totalpacketlen);
 
 	rtstatus = rtl_cmd_send_packet(hw, skb);
-- 
2.20.1



