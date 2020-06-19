Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF420128D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393235AbgFSPxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393060AbgFSPWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5099521582;
        Fri, 19 Jun 2020 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580166;
        bh=fe6JlMkedmaY+Fx6mlPmGF1n1tIJcCuXDwOukd/h1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTc5I4Om2noozQ3boEG8qJ0UWsmYL5G9sli9tLKSoY4po8tlHXlN4on86+7OWrNJ9
         19MjHr5/NqcCPEmPxgEpGydNTKocUQv1vlRZTlXQhbtnAd4yAjdxnNLk/23QJkbRTS
         8RyJXZw4Vbikih1vVtwB5fm/boSgdS4JyriKbb84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 117/376] ath11k: use GFP_ATOMIC under spin lock
Date:   Fri, 19 Jun 2020 16:30:35 +0200
Message-Id: <20200619141715.884913816@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 69c93f9674c97dc439cdc0527811f8ad104c2e35 ]

A spin lock is taken here so we should use GFP_ATOMIC.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200427092417.56236-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index f74a0e74bf3e..34b1e8e6a7fb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -892,7 +892,7 @@ int ath11k_peer_rx_tid_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id,
 	else
 		hw_desc_sz = ath11k_hal_reo_qdesc_size(DP_BA_WIN_SZ_MAX, tid);
 
-	vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1, GFP_KERNEL);
+	vaddr = kzalloc(hw_desc_sz + HAL_LINK_DESC_ALIGN - 1, GFP_ATOMIC);
 	if (!vaddr) {
 		spin_unlock_bh(&ab->base_lock);
 		return -ENOMEM;
-- 
2.25.1



