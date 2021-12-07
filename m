Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6BB46BDBC
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbhLGOeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhLGOeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 09:34:08 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A5EC061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 06:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1638887433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=M/6VW7i7W+xthc4rrARhEy/BbZdY9QLtRROjfHQerbo=;
        b=UzoljNDWkgQnQwRzMb4XekfUMSiDgAsdMPdJhoqkHCuIkUdlVBnh/SqIbGLiNg8hBSNC9Y
        BL6JAUVjz6FgCYWG5guqnc4QvA9CdSuaaiVl/4WStufgvwPnxaSNgHMubcSDjkjsDb10U5
        HTORV6os2TbTUmEcrHvUZzHqk74QZ0Y=
From:   Sven Eckelmann <sven@narfation.org>
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Sven Eckelmann <sven@narfation.org>, stable@vger.kernel.org
Subject: [PATCH] ath11k: Fix buffer overflow when scanning with extraie
Date:   Tue,  7 Dec 2021 15:29:13 +0100
Message-Id: <20211207142913.1734635-1-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If cfg80211 is providing extraie's for a scanning process then ath11k will
copy that over to the firmware. The extraie.len is a 32 bit value in struct
element_info and describes the amount of bytes for the vendor information
elements.

The WMI_TLV packet is having a special WMI_TAG_ARRAY_BYTE section. This
section can have a (payload) length up to 65535 bytes because the
WMI_TLV_LEN can store up to 16 bits. The code was missing such a check and
could have created a scan request which cannot be parsed correctly by the
firmware.

But the bigger problem was the allocation of the buffer. It has to align
the TLV sections by 4 bytes. But the code was using an u8 to store the
newly calculated length of this section (with alignment). And the new
calculated length was then used to allocate the skbuff. But the actual code
to copy in the data is using the extraie.len and not the calculated
"aligned" length.

The length of extraie with IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS enabled
was 264 bytes during tests with a QCA Milan card. But it only allocated 8
bytes (264 bytes % 256) for it. As consequence, the code to memcpy the
extraie into the skb was then just overwriting data after skb->end. Things
like shinfo were therefore corrupted. This could usually be seen by a crash
in skb_zcopy_clear which tried to call a ubuf_info callback (using a bogus
address).

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-02892.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Cc: stable@vger.kernel.org
Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6da16d095e37..d817ea468ab5 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2115,7 +2115,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 	void *ptr;
 	int i, ret, len;
 	u32 *tmp_ptr;
-	u8 extraie_len_with_pad = 0;
+	u16 extraie_len_with_pad = 0;
 	struct hint_short_ssid *s_ssid = NULL;
 	struct hint_bssid *hint_bssid = NULL;
 
@@ -2134,7 +2134,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		len += sizeof(*bssid) * params->num_bssid;
 
 	len += TLV_HDR_SIZE;
-	if (params->extraie.len)
+	if (params->extraie.len && params->extraie.len <= 0xFFFF)
 		extraie_len_with_pad =
 			roundup(params->extraie.len, sizeof(u32));
 	len += extraie_len_with_pad;
@@ -2241,7 +2241,7 @@ int ath11k_wmi_send_scan_start_cmd(struct ath11k *ar,
 		      FIELD_PREP(WMI_TLV_LEN, len);
 	ptr += TLV_HDR_SIZE;
 
-	if (params->extraie.len)
+	if (extraie_len_with_pad)
 		memcpy(ptr, params->extraie.ptr,
 		       params->extraie.len);
 
-- 
2.30.2

