Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF9499277
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346643AbiAXUVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42424 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380297AbiAXUQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:16:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED93C61008;
        Mon, 24 Jan 2022 20:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF0C340E5;
        Mon, 24 Jan 2022 20:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055365;
        bh=CduslETHRLwjfiGrfLsJKn1rG/0fkfQDPT6G9Vg21pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nO7oJS9XlLXjl1NjODflMdNQpLlTCOWaHZBO9OEJFyJXzIYUrzXr6SSMfniOAXSK
         huJimBwInJW2cG6XFXH6Pa24ZlyxsDtVwEAV6UXV8Rd4CTlBKVbtfy5k8/N35PGWXm
         zpicjp6aniMgJIoEof53oZDqaQLCl6/0QpIuPBVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Karthikeyan Kathirvel <kathirve@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/846] ath11k: clear the keys properly via DISABLE_KEY
Date:   Mon, 24 Jan 2022 19:34:05 +0100
Message-Id: <20220124184105.406553407@linuxfoundation.org>
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
index 89a64ebd620f3..aac10740f5752 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2655,9 +2655,7 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
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
index c22ec921b2e97..e75e6ebdf2a65 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1671,7 +1671,8 @@ int ath11k_wmi_vdev_install_key(struct ath11k *ar,
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



