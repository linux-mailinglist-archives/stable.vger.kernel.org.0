Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F649A36C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368112AbiAXX5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846007AbiAXXOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7752CC061A80;
        Mon, 24 Jan 2022 13:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E0A1B8123A;
        Mon, 24 Jan 2022 21:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D85AC340E4;
        Mon, 24 Jan 2022 21:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059272;
        bh=bep6sJR3PXgQxcO9jA0MP5nJ6KAIdBpiWgtPVOcKKEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3FvMFbfw7dj8EVAXAZdxTxeWKLxGSIJtXlQjtr0KyDug1cTCTLkWffKKQwv9mB6U
         15RHwf4WVgFksZ5RKkXCwjYrdEBluS96K8hPltXYHvDyUOZte+Ms3jJylw567MofC8
         OtDOPql2NDchDRjXJ53C1x8BwRP189uYzt9vVuZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0561/1039] ath11k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE if NSS ratio enabled
Date:   Mon, 24 Jan 2022 19:39:10 +0100
Message-Id: <20220124184144.170113354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 78406044bdd0cc8987bc082b76867c63ab1c6af8 ]

When NSS ratio enabled reported by firmware, SUPPORTS_VHT_EXT_NSS_BW
is set in ath11k, meanwhile IEEE80211_VHT_EXT_NSS_BW_CAPABLE also
need to be set, otherwise it is invalid because spec in IEEE Std
802.11™‐2020 as below.

Table 9-273-Supported VHT-MCS and NSS Set subfields, it has subfield
VHT Extended NSS BW Capable, its definition is:
Indicates whether the STA is capable of interpreting the Extended NSS
BW Support subfield of the VHT Capabilities Information field.

dmesg have a message without this patch:

ieee80211 phy0: copying sband (band 1) due to VHT EXT NSS BW flag

It means mac80211 will set IEEE80211_VHT_EXT_NSS_BW_CAPABLE if ath11k not
set it in ieee80211_register_hw(). So it is better to set it in ath11k.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211013073704.15888-1-wgong@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 5d49a7ea51fae..cb41c3e5708cb 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4566,6 +4566,10 @@ ath11k_create_vht_cap(struct ath11k *ar, u32 rate_cap_tx_chainmask,
 	vht_cap.vht_supported = 1;
 	vht_cap.cap = ar->pdev->cap.vht_cap;
 
+	if (ar->pdev->cap.nss_ratio_enabled)
+		vht_cap.vht_mcs.tx_highest |=
+			cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
 	ath11k_set_vht_txbf_cap(ar, &vht_cap.cap);
 
 	rxmcs_map = 0;
-- 
2.34.1



