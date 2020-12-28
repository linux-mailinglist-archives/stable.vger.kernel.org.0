Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE942E4264
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgL1OCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436819AbgL1OCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66EA4207A9;
        Mon, 28 Dec 2020 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164119;
        bh=LyuqagvAZnhjEVnA+8H7ULKSX4ToYQRil6fFJvJUzKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ck7FqFLQU1O9S4/wKBbCTelnjM3nNuyw3Vfu3gA4oJ2HDwnRbEVeM2xh2zF5kxFhg
         bjgpizu+TSNx17qFp1D0uOBMtSrEYO4rZhv7o9lLyazD3p1WuRzFN1vXRJvoQf0Ge2
         mGVBmeX0L+7LD3To7NujzntEWZ8sZF0HHsAf5ioY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/717] ath11k: fix wmi init configuration
Date:   Mon, 28 Dec 2020 13:41:05 +0100
Message-Id: <20201228125024.206493233@linuxfoundation.org>
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

From: Karthikeyan Periyasamy <periyasa@codeaurora.org>

[ Upstream commit 36c7c640ffeb87168e5ff79b7a36ae3a020bd378 ]

Assign the correct hw_op ath11k_init_wmi_config_ipq8074 to
the hw IPQ8074. Also update the correct TWT radio count.
Incorrect TWT radio count cause TWT feature fails on radio2
because physical device count is hardcoded to 2. so set
the value dynamically.

Found this during code review.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.1.0.1-01238-QCAHKSWPL_SILICONZ-2

Fixes: 2d4bcbed5b7d53e1 ("ath11k: initialize wmi config based on hw_params")
Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1604512020-25197-1-git-send-email-periyasa@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index 11a411b76fe42..66331da350129 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -127,7 +127,7 @@ static void ath11k_init_wmi_config_ipq8074(struct ath11k_base *ab,
 	config->beacon_tx_offload_max_vdev = ab->num_radios * TARGET_MAX_BCN_OFFLD;
 	config->rx_batchmode = TARGET_RX_BATCHMODE;
 	config->peer_map_unmap_v2_support = 1;
-	config->twt_ap_pdev_count = 2;
+	config->twt_ap_pdev_count = ab->num_radios;
 	config->twt_ap_sta_count = 1000;
 }
 
@@ -157,7 +157,7 @@ static int ath11k_hw_mac_id_to_srng_id_qca6390(struct ath11k_hw_params *hw,
 
 const struct ath11k_hw_ops ipq8074_ops = {
 	.get_hw_mac_from_pdev_id = ath11k_hw_ipq8074_mac_from_pdev_id,
-	.wmi_init_config = ath11k_init_wmi_config_qca6390,
+	.wmi_init_config = ath11k_init_wmi_config_ipq8074,
 	.mac_id_to_pdev_id = ath11k_hw_mac_id_to_pdev_id_ipq8074,
 	.mac_id_to_srng_id = ath11k_hw_mac_id_to_srng_id_ipq8074,
 };
-- 
2.27.0



