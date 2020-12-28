Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DC32E405C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502849AbgL1Ovd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:51:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441603AbgL1OTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2B6207B2;
        Mon, 28 Dec 2020 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165138;
        bh=hWySLQw4sci6BfhLpINU3VTFhfulaG8NvVAEH/4QXAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKqCO6fwbdHcsV4TIGAMNRyVvUDvrIF2HzTwAhP2CyXudQV+yW3tRPdCAmZMCVZHi
         23g6rHWqq+n0JwCeXBG4uXC/CjYEwmnYffWjx0IhejV5QAamrX65mQyBu9e93pL0R9
         POdw4vbR1ypksI1jUqklwh+yVeDDcJ9psD7Ui/Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 426/717] ath11k: Fix incorrect tlvs in scan start command
Date:   Mon, 28 Dec 2020 13:47:04 +0100
Message-Id: <20201228125041.374941956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit f57ad6a9885e8399897daee3249cabccf9c972f8 ]

Currently 6G specific tlvs have duplicate entries which is causing
scan failures. Fix this by removing the duplicate entries of the same
tlv. This also fixes out-of-bound memory writes caused due to
adding tlvs when num_hint_bssid and num_hint_s_ssid are ZEROs.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.4.0.1-01386-QCAHKSWPL_SILICONZ-1

Fixes: 74601ecfef6e ("ath11k: Add support for 6g scan hint")
Reported-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1607609124-17250-7-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 31 ---------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 8eca92520837e..04b8b002edfe0 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2198,37 +2198,6 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		}
 	}
 
-	len = params->num_hint_s_ssid * sizeof(struct hint_short_ssid);
-	tlv = ptr;
-	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_FIXED_STRUCT) |
-		      FIELD_PREP(WMI_TLV_LEN, len);
-	ptr += TLV_HDR_SIZE;
-	if (params->num_hint_s_ssid) {
-		s_ssid = ptr;
-		for (i = 0; i < params->num_hint_s_ssid; ++i) {
-			s_ssid->freq_flags = params->hint_s_ssid[i].freq_flags;
-			s_ssid->short_ssid = params->hint_s_ssid[i].short_ssid;
-			s_ssid++;
-		}
-	}
-	ptr += len;
-
-	len = params->num_hint_bssid * sizeof(struct hint_bssid);
-	tlv = ptr;
-	tlv->header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_ARRAY_FIXED_STRUCT) |
-		      FIELD_PREP(WMI_TLV_LEN, len);
-	ptr += TLV_HDR_SIZE;
-	if (params->num_hint_bssid) {
-		hint_bssid = ptr;
-		for (i = 0; i < params->num_hint_bssid; ++i) {
-			hint_bssid->freq_flags =
-				params->hint_bssid[i].freq_flags;
-			ether_addr_copy(&params->hint_bssid[i].bssid.addr[0],
-					&hint_bssid->bssid.addr[0]);
-			hint_bssid++;
-		}
-	}
-
 	ret = ath11k_wmi_cmd_send(wmi, skb,
 				  WMI_START_SCAN_CMDID);
 	if (ret) {
-- 
2.27.0



