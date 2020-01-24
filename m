Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0FA148044
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgAXLJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgAXLJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:09:20 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3CAB20663;
        Fri, 24 Jan 2020 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864159;
        bh=tVMI2M0j68CsPEnkb7i4XDH9dYbot6ijKizilztbtf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Km7FT3jEULWXNE+CGmkLVuDXPrU4kEO5gl39eBH9DLaCjo4MwreL21eZ3nAdITr9b
         5gp2+s/t+WV/D1mjSlAKLXZYYfSaqLiNA916DOnUfRfBcMnlx6PfWWR0SSXMwRXFkI
         Xt/JCLkNABtrPQlP6x+TsJr3s82Vb0Ust2IzJGpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/639] ath10k: fix dma unmap direction for management frames
Date:   Fri, 24 Jan 2020 10:25:45 +0100
Message-Id: <20200124093109.099932051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 6e8a8991e2103dcb6a9cff28f460390e8e360848 ]

The management frames transmitted are dma mapped with
direction TO_DEVICE, but incorrectly mapped with
direction FROM_DEVICE during tx complete and error cases.

Fix the direction of dma during dma unmap of the
transmitted management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Fixes: 38a1390e02b7 ("ath10k: dma unmap mgmt tx buffer if wmi cmd send fails")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 448e3a8c33a6d..a09d7a07e90a8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -3853,7 +3853,7 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 				ath10k_warn(ar, "failed to transmit management frame by ref via WMI: %d\n",
 					    ret);
 				dma_unmap_single(ar->dev, paddr, skb->len,
-						 DMA_FROM_DEVICE);
+						 DMA_TO_DEVICE);
 				ieee80211_free_txskb(ar->hw, skb);
 			}
 		} else {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index aefc92d2c09b9..0f6ff7a78e49d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2340,7 +2340,7 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 
 	msdu = pkt_addr->vaddr;
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
-			 msdu->len, DMA_FROM_DEVICE);
+			 msdu->len, DMA_TO_DEVICE);
 	info = IEEE80211_SKB_CB(msdu);
 
 	if (status)
-- 
2.20.1



