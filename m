Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FAB37CE7D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbhELRFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238304AbhELQox (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B982E61E6C;
        Wed, 12 May 2021 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836067;
        bh=wDvyzyS+v5NW4V8V4Zb/1JqtHOs8wdtrfyQcFP0NfAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srhoo8ch+WJ6zj+e4rhPpxbFCEGchEFX8lqU/LQ8Msnh17Zo/3IWsL+al3h6cC47A
         9ku9FbmzPXw5O3KLRwtJZfa6mQ/zsIf9V3+pLtabSAD2CvOZ2RkBSBuRmuOAE/WvXh
         DBsP393tq1tAPsoBcha/S7jqMW69OJVI/yUV/oLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 595/677] mwl8k: Fix a double Free in mwl8k_probe_hw
Date:   Wed, 12 May 2021 16:50:41 +0200
Message-Id: <20210512144857.145123216@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit a8e083ee8e2a6c94c29733835adae8bf5b832748 ]

In mwl8k_probe_hw, hw->priv->txq is freed at the first time by
dma_free_coherent() in the call chain:
if(!priv->ap_fw)->mwl8k_init_txqs(hw)->mwl8k_txq_init(hw, i).

Then in err_free_queues of mwl8k_probe_hw, hw->priv->txq is freed
at the second time by mwl8k_txq_deinit(hw, i)->dma_free_coherent().

My patch set txq->txd to NULL after the first free to avoid the
double free.

Fixes: a66098daacee2 ("mwl8k: Marvell TOPDOG wireless driver")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210402182627.4256-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index c9f8c056aa51..84b32a5f01ee 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1473,6 +1473,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	if (txq->skb == NULL) {
 		dma_free_coherent(&priv->pdev->dev, size, txq->txd,
 				  txq->txd_dma);
+		txq->txd = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.30.2



