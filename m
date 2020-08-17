Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D06246F83
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388323AbgHQRsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388747AbgHQQNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:13:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB4022B47;
        Mon, 17 Aug 2020 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680793;
        bh=+9EXPqoIyCzRIzx+tL1ubNAp2MTIgCJ+CofNbAVfw90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/0k6hs0WhKM0fvI4rCO7vMyoxXoRhCIyog30P0dzlAq6UQv73x+LlR5f0gNoUyAH
         put5F+I9mCqi3c41ZSo0YScGbsTDaeZ71F7R+J5kxLwrItLySKpWehWxyuhK7Yq29L
         SSgidW2Br0DNcfdlhABINJkqwoHBYnVYUU7mMyJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/168] ath10k: Acquire tx_lock in tx error paths
Date:   Mon, 17 Aug 2020 17:16:30 +0200
Message-Id: <20200817143736.693645478@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

[ Upstream commit a738e766e3ed92c4ee5ec967777276b5ce11dd2c ]

ath10k_htt_tx_free_msdu_id() has a lockdep assertion that htt->tx_lock
is held. Acquire the lock in a couple of error paths when calling that
function to ensure this condition is met.

Fixes: 6421969f248fd ("ath10k: refactor tx pending management")
Fixes: e62ee5c381c59 ("ath10k: Add support for htt_data_tx_desc_64 descriptor")
Signed-off-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604105901.1.I5b8b0c7ee0d3e51a73248975a9da61401b8f3900@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7cff0d52338fe..fd011bdabb963 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1329,7 +1329,9 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
 err:
 	return res;
 }
@@ -1536,7 +1538,9 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
 err:
 	return res;
 }
-- 
2.25.1



