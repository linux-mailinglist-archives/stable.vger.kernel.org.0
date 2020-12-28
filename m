Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA672E3C6B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436901AbgL1OCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436897AbgL1OCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FF2B2064B;
        Mon, 28 Dec 2020 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164115;
        bh=IWRDa28+widSSeJiMsMFp8MUt95eHCJui1hA1mkbdE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNqvikbE71DsiDU+FyKTE1L1smFfAy+n+OMjkMsU98qQwF+vVSTpqAGgNX8c5t6tH
         ZldyOwckYDtaliHRuMIekuzDMEyIhTsMWIHnO5ipx+MvYkWcPX09HItWBRjTq/sKLQ
         FliBLAebSX9ljN4gFVRqzqhJ7lnviTWUiNyKnTh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/717] ath11k: Initialize complete alpha2 for regulatory change
Date:   Mon, 28 Dec 2020 13:41:03 +0100
Message-Id: <20201228125024.109673721@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 383a32cde4172db19d4743d4c782c00af39ff275 ]

The function ath11k_wmi_send_init_country_cmd is taking 3 byte from alpha2
of the structure wmi_init_country_params. But the function
ath11k_reg_notifier is only initializing 2 bytes. The third byte is
therefore always an uninitialized value.

The command can happen to look like

  0c 00 87 02 01 00 00 00 00 00 00 00 43 41 f8 00

instead of

  0c 00 87 02 01 00 00 00 00 00 00 00 43 41 00 00

Tested-on: IPQ8074 hw2.0 WLAN.HK.2.1.0.1-01161-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 WLAN.HK.2.1.0.1-01228-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 WLAN.HK.2.1.0.1-01238-QCAHKSWPL_SILICONZ-2
Tested-on: IPQ8074 hw2.0 WLAN.HK.2.4.0.1.r1-00019-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 WLAN.HK.2.4.0.1.r1-00026-QCAHKSWPL_SILICONZ-2

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201021140555.4114715-1-sven@narfation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index f6a1f0352989d..83f75f8855ebe 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -80,6 +80,7 @@ ath11k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	 */
 	init_country_param.flags = ALPHA_IS_SET;
 	memcpy(&init_country_param.cc_info.alpha2, request->alpha2, 2);
+	init_country_param.cc_info.alpha2[2] = 0;
 
 	ret = ath11k_wmi_send_init_country_cmd(ar, init_country_param);
 	if (ret)
-- 
2.27.0



