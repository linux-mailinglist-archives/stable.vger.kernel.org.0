Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7FA49944A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389001AbiAXUkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385440AbiAXUdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F94C07E293;
        Mon, 24 Jan 2022 11:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D09A6B81188;
        Mon, 24 Jan 2022 19:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E06C340E5;
        Mon, 24 Jan 2022 19:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053503;
        bh=cyEpis7cdHp2yQhSzlz5kj4WBDYG6wah1Bg5GbBcldQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN0blTtYlIOxxty8vxeSVJeTSguuAnZ4vj0hy8fAkxuYQNUNMarQQWWmYmmXX5/8k
         HbP9H789XMwcWKIp77YcKAcPPo3hrQf1UBQx9ruGRXuLg5shrZ4+OqMrpEphpOfbAI
         Q514LlppqjaHAB3TI62bRAmWse2OLvmCFFTrJJhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/563] ath11k: clear the keys properly via DISABLE_KEY
Date:   Mon, 24 Jan 2022 19:37:32 +0100
Message-Id: <20220124184027.407123622@linuxfoundation.org>
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

[ Upstream commit 436a4e88659842a7cf634d7cc088c8f2cc94ebf5 ]

DISABLE_KEY sets the key_len to 0, firmware will not delete the keys if
key_len is 0. Changing from security mode to open mode will cause mcast
to be still encrypted without vdev restart.

Set the proper key_len for DISABLE_KEY cmd to clear the keys in
firmware.

Tested-on: IPQ6018 hw1.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Reported-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Karthikeyan Kathirvel <kathirve@codeaurora.org>
[sven@narfation.org: split into separate patches, clean up commit message]
Signed-off-by: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211115100441.33771-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 +---
 drivers/net/wireless/ath/ath11k/wmi.c | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 0924bc8b35205..304e158f09751 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2395,9 +2395,7 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
 		return 0;
 
 	if (cmd == DISABLE_KEY) {
-		/* TODO: Check if FW expects  value other than NONE for del */
-		/* arg.key_cipher = WMI_CIPHER_NONE; */
-		arg.key_len = 0;
+		arg.key_cipher = WMI_CIPHER_NONE;
 		arg.key_data = NULL;
 		goto install;
 	}
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e84127165d858..acf1641ce88fd 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1665,7 +1665,8 @@ int ath11k_wmi_vdev_install_key(struct ath11k *ar,
 	tlv = (struct wmi_tlv *)(skb->data + sizeof(*cmd));
 	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_BYTE) |
 		      FIELD_PREP(WMI_TLV_LEN, key_len_aligned);
-	memcpy(tlv->value, (u8 *)arg->key_data, key_len_aligned);
+	if (arg->key_data)
+		memcpy(tlv->value, (u8 *)arg->key_data, key_len_aligned);
 
 	ret = ath11k_wmi_cmd_send(wmi, skb, WMI_VDEV_INSTALL_KEY_CMDID);
 	if (ret) {
-- 
2.34.1



