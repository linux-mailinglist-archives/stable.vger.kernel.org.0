Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEC167866
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgBUIsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbgBUHrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E90024650;
        Fri, 21 Feb 2020 07:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271226;
        bh=I6NtYLAPNib460xwCVxXUT8qx07WuH0UxST/BdX8blg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzlgMZud36xM76U7VQexBxusJraGwT+gsC0kYpI7RzN78ISWyeQNP+CrysAUzZA1c
         aLSohVxhZbtKdA6F2l+3A68MnZG7lVMOq326ZJZCopAptUlyMrby8/bFfzEeF9AD2c
         Wt3rB51pFewQai0060t2jdX+7U7ep8g7nb2/1A1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 087/399] ath10k: Correct the DMA direction for management tx buffers
Date:   Fri, 21 Feb 2020 08:36:52 +0100
Message-Id: <20200221072410.803417902@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 6ba8b3b6bd772f575f7736c8fd893c6981fcce16 ]

The management packets, send to firmware via WMI, are
mapped using the direction DMA_TO_DEVICE. Currently in
case of wmi cleanup, these buffers are being unmapped
using an incorrect DMA direction. This can cause unwanted
behavior when the host driver is handling a restart
of the wlan firmware.

We might see a trace like below

[<ffffff8008098b18>] __dma_inv_area+0x28/0x58
[<ffffff8001176734>] ath10k_wmi_mgmt_tx_clean_up_pending+0x60/0xb0 [ath10k_core]
[<ffffff80088c7c50>] idr_for_each+0x78/0xe4
[<ffffff80011766a4>] ath10k_wmi_detach+0x4c/0x7c [ath10k_core]
[<ffffff8001163d7c>] ath10k_core_stop+0x58/0x68 [ath10k_core]
[<ffffff800114fb74>] ath10k_halt+0xec/0x13c [ath10k_core]
[<ffffff8001165110>] ath10k_core_restart+0x11c/0x1a8 [ath10k_core]
[<ffffff80080c36bc>] process_one_work+0x16c/0x31c

Fix the incorrect DMA direction during the wmi
management tx buffer cleanup.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: dc405152bb6 ("ath10k: handle mgmt tx completion event")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9f564e2b7a148..214d65108b294 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9476,7 +9476,7 @@ static int ath10k_wmi_mgmt_tx_clean_up_pending(int msdu_id, void *ptr,
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
+			 msdu->len, DMA_TO_DEVICE);
 	ieee80211_free_txskb(ar->hw, msdu);
 
 	return 0;
-- 
2.20.1



