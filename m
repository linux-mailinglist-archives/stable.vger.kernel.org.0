Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B783F48E57D
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiANISc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbiANISN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:18:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB538C061751;
        Fri, 14 Jan 2022 00:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A19A61DDA;
        Fri, 14 Jan 2022 08:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31608C36AF8;
        Fri, 14 Jan 2022 08:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148291;
        bh=M/kT1BlTrVRbK+6m5FwyenZKLb/O9n0j8HrCqKkK7rA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vD27Mk55iM8G40c2X81RRueHKn43gpNHegajnftMGnQlj9ZaU8u3dqtfkjXDT+esF
         3a1dp9sp8LzKt1jumC5qNhwfDAaSafpFe5MhMEtlahUiBnA3O8BuYW9pLhpgEc62Nr
         BD5n1Ar3DVlhtVW9Or0SuDODtrBnziHAO5ZnFg2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 5.10 12/25] ath11k: Fix buffer overflow when scanning with extraie
Date:   Fri, 14 Jan 2022 09:16:20 +0100
Message-Id: <20220114081543.115550627@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit a658c929ded7ea3aee324c8c2a9635a5e5a38e7f upstream.

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
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211207142913.1734635-1-sven@narfation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2036,7 +2036,7 @@ int ath11k_wmi_send_scan_start_cmd(struc
 	void *ptr;
 	int i, ret, len;
 	u32 *tmp_ptr;
-	u8 extraie_len_with_pad = 0;
+	u16 extraie_len_with_pad = 0;
 	struct hint_short_ssid *s_ssid = NULL;
 	struct hint_bssid *hint_bssid = NULL;
 
@@ -2055,7 +2055,7 @@ int ath11k_wmi_send_scan_start_cmd(struc
 		len += sizeof(*bssid) * params->num_bssid;
 
 	len += TLV_HDR_SIZE;
-	if (params->extraie.len)
+	if (params->extraie.len && params->extraie.len <= 0xFFFF)
 		extraie_len_with_pad =
 			roundup(params->extraie.len, sizeof(u32));
 	len += extraie_len_with_pad;
@@ -2162,7 +2162,7 @@ int ath11k_wmi_send_scan_start_cmd(struc
 		      FIELD_PREP(WMI_TLV_LEN, len);
 	ptr += TLV_HDR_SIZE;
 
-	if (params->extraie.len)
+	if (extraie_len_with_pad)
 		memcpy(ptr, params->extraie.ptr,
 		       params->extraie.len);
 


