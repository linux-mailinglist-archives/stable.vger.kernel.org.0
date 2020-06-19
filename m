Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994AA2012B3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392862AbgFSPzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392848AbgFSPV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97D1321582;
        Fri, 19 Jun 2020 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580085;
        bh=UgH8czb3Zqf99cuf6/cq5xSM1xd308oDJ5vXdkILL9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYRsr6y89jsF1oA/X3Utv4ut4L6wOdTn3dkejmbI7cOlH1+q/oLwzfdDtzSZEdEB9
         H33UiqN/WiVsd1MWm8lMUWmNGYJlSMDmQ2tAWiaBx3J8009FwPV7ke1Ry1un0lXjng
         9ufEw5hmfusDQIqeuF6cO9Ui4GoG+D72DC9g4fkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 086/376] ath10k: fix kernel null pointer dereference
Date:   Fri, 19 Jun 2020 16:30:04 +0200
Message-Id: <20200619141714.414954120@linuxfoundation.org>
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

From: Venkateswara Naralasetty <vnaralas@codeaurora.org>

[ Upstream commit acb31476adc9ff271140cdd4d3c707ff0c97f5a4 ]

Currently sta airtime is updated without any lock in case of
host based airtime calculation. Which may result in accessing the
invalid sta pointer in case of continuous station connect/disconnect.

This patch fix the kernel null pointer dereference by updating the
station airtime with proper RCU lock in case of host based airtime
calculation.

Proceeding with the analysis of "ARM Kernel Panic".
The APSS crash happened due to OOPS on CPU 0.
Crash Signature : Unable to handle kernel NULL pointer dereference
at virtual address 00000300
During the crash,
PC points to "ieee80211_sta_register_airtime+0x1c/0x448 [mac80211]"
LR points to "ath10k_txrx_tx_unref+0x17c/0x364 [ath10k_core]".
The Backtrace obtained is as follows:
[<bf880238>] (ieee80211_sta_register_airtime [mac80211]) from
[<bf945a38>] (ath10k_txrx_tx_unref+0x17c/0x364 [ath10k_core])
[<bf945a38>] (ath10k_txrx_tx_unref [ath10k_core]) from
[<bf9428e4>] (ath10k_htt_txrx_compl_task+0xa50/0xfc0 [ath10k_core])
[<bf9428e4>] (ath10k_htt_txrx_compl_task [ath10k_core]) from
[<bf9b9bc8>] (ath10k_pci_napi_poll+0x50/0xf8 [ath10k_pci])
[<bf9b9bc8>] (ath10k_pci_napi_poll [ath10k_pci]) from
[<c059e3b0>] (net_rx_action+0xac/0x160)
[<c059e3b0>] (net_rx_action) from [<c02329a4>] (__do_softirq+0x104/0x294)
[<c02329a4>] (__do_softirq) from [<c0232b64>] (run_ksoftirqd+0x30/0x90)
[<c0232b64>] (run_ksoftirqd) from [<c024e358>] (smpboot_thread_fn+0x25c/0x274)
[<c024e358>] (smpboot_thread_fn) from [<c02482fc>] (kthread+0xd8/0xec)

Tested HW: QCA9888
Tested FW: 10.4-3.10-00047

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585736290-17661-1-git-send-email-vnaralas@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 39abf8b12903..f46b9083bbf1 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -84,9 +84,11 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
+	rcu_read_lock();
 	if (txq && txq->sta && skb_cb->airtime_est)
 		ieee80211_sta_register_airtime(txq->sta, txq->tid,
 					       skb_cb->airtime_est, 0);
+	rcu_read_unlock();
 
 	if (ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-- 
2.25.1



