Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122322469D6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgHQP0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgHQP0q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB92023A1D;
        Mon, 17 Aug 2020 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678006;
        bh=sCWwWWUVOqcvE+OPfFNQArOmoRTzDJBr21kMFMHQVAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPQ54youknZpqA2mlgJzpk1MGAsyP/3LrsNJ9A3IKIA9C3Vc4rr6ALn3gRXXiNt7O
         VxG+PtVlh96gWs59eVHzbDbGjNM/0a8l2Uv1YabFQlTLIbaH9RIW13M7/AI7tXVEoz
         xlxTxfixj+mBQyEQNzgg8neOHP8uWsV9LCWd0mzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 156/464] ath10k: Acquire tx_lock in tx error paths
Date:   Mon, 17 Aug 2020 17:11:49 +0200
Message-Id: <20200817143841.280799598@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 4fd10ac3a9417..bbe869575855a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1591,7 +1591,9 @@ static int ath10k_htt_tx_32(struct ath10k_htt *htt,
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_msdu_id:
+	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
+	spin_unlock_bh(&htt->tx_lock);
 err:
 	return res;
 }
@@ -1798,7 +1800,9 @@ static int ath10k_htt_tx_64(struct ath10k_htt *htt,
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



