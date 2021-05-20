Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF838AB17
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhETLUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240679AbhETLTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120FE61D75;
        Thu, 20 May 2021 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505417;
        bh=zxuLGrBTmBa/HsIIrpnILXloFIxoiESPmeAb8Nk0y74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl8abSZVyKKcZ8kUbrHkLImax0XBIgNrQNmTtcd437x9BDoxqfOyGE8WbJX0Kvcoc
         fTduQVG7698e2NcOvFDyFzpPPwxa9hBERNOcDB5HS26cCFb1OXuiRxAU5oUGi95EMw
         tcmsFwibwMEk9kTwZFIRnBmBMd0iR8GOUrlNXEdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 126/190] mwl8k: Fix a double Free in mwl8k_probe_hw
Date:   Thu, 20 May 2021 11:23:10 +0200
Message-Id: <20210520092106.371129919@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
 drivers/net/wireless/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 088429d0a634..d448480b8406 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1459,6 +1459,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
 		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
+		txq->txd = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.30.2



