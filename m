Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2957A498A68
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbiAXTDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345879AbiAXTBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53369C061A83;
        Mon, 24 Jan 2022 10:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CD14B8121B;
        Mon, 24 Jan 2022 18:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BEAC340E5;
        Mon, 24 Jan 2022 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050704;
        bh=fkB1Uenr+wOd5Si9NwVeQ3Cj6i2+Q4Nx/VagxEJT/Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmRuewr7Xh+iiNhTMzLbA2CUGDG9jJkQz2VvIxZ6NfdVBac0dOuHZdCKRfPQP/Mok
         cbE/v2Bsu9hVivdbFeb2qV90GUikfmH4kJdgy5z6JwosYjxqXJ41L0ML+ESlWRYoNH
         5JKVTvSu3gx0MDjpwFrSXThVA1edSiHr5TyEJMc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 087/157] ath10k: Fix tx hanging
Date:   Mon, 24 Jan 2022 19:42:57 +0100
Message-Id: <20220124183935.544944696@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Gottschall <s.gottschall@dd-wrt.com>

[ Upstream commit e8a91863eba3966a447d2daa1526082d52b5db2a ]

While running stress tests in roaming scenarios (switching ap's every 5
seconds, we discovered a issue which leads to tx hangings of exactly 5
seconds while or after scanning for new accesspoints. We found out that
this hanging is triggered by ath10k_mac_wait_tx_complete since the
empty_tx_wq was not wake when the num_tx_pending counter reaches zero.
To fix this, we simply move the wake_up call to htt_tx_dec_pending,
since this call was missed on several locations within the ath10k code.

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20210505085806.11474-1-s.gottschall@dd-wrt.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 3 +++
 drivers/net/wireless/ath/ath10k/txrx.c   | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ae5b33fe5ba82..374ce35940d07 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -158,6 +158,9 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
+
+	if (htt->num_pending_tx == 0)
+		wake_up(&htt->empty_tx_wq);
 }
 
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index beeb6be06939b..b6c050452b757 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -89,8 +89,6 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
-	if (htt->num_pending_tx == 0)
-		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-- 
2.34.1



