Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64432E418A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438637AbgL1OIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438631AbgL1OIQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D08020715;
        Mon, 28 Dec 2020 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164456;
        bh=DG8z1ZiAGb8buuS+lTbifoT3aSILK7prZfeU9Rw4JiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4AdPzOeljGjupo6/JUSQ/a2Y+P736ALwmbj9dLsjCwGgrPWNVpcROcyaryuRXgwK
         8ABjtoEsxVPVohynotc9sBLcsZnmCwepuF7J6Lysg9UlzJ24zcIIrGbKCjVXX3HKYG
         A59uNP3TVFck7D5dgy0QvwhZD91KA/4ejG6h2FvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/717] ath11k: Fix the rx_filter flag setting for peer rssi stats
Date:   Mon, 28 Dec 2020 13:43:05 +0100
Message-Id: <20201228125029.929660428@linuxfoundation.org>
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

From: Maharaja Kennadyrajan <mkenna@codeaurora.org>

[ Upstream commit 11af6de4799ee6eeae3730f18fd417414d212e2d ]

Set the rx_filter in ath11k_mac_config_mon_status_default(),
only when the rx_filter value exists in ath11k_debug_rx_filter().

Without this change, rx_filter gets set to 0 and peer rssi stats
aren't updating properly from firmware.

Tested-on: IPQ8074 WLAN.HK.2.1.0.1-01230-QCAHKSWPL_SILICONZ-4

Fixes: ec48d28ba291 ("ath11k: Fix rx_filter flags setting for per peer rx_stats")

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1605091117-11005-1-git-send-email-mkenna@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7a2c9708693ec..f5e49e1c11ed7 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4094,7 +4094,8 @@ static int ath11k_mac_config_mon_status_default(struct ath11k *ar, bool enable)
 
 	if (enable) {
 		tlv_filter = ath11k_mac_mon_status_filter_default;
-		tlv_filter.rx_filter = ath11k_debugfs_rx_filter(ar);
+		if (ath11k_debugfs_rx_filter(ar))
+			tlv_filter.rx_filter = ath11k_debugfs_rx_filter(ar);
 	}
 
 	for (i = 0; i < ab->hw_params.num_rxmda_per_pdev; i++) {
-- 
2.27.0



