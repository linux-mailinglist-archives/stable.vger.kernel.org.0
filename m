Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9438937C246
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhELPId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232784AbhELPG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4BFD61434;
        Wed, 12 May 2021 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831671;
        bh=VIjfpJRN1YKm5fUqy2sljdQWhp1yPdeIpfemmghl7Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjcAsgwVVlZtehoto+8GxEp9syr85al1Bm2P7IiMuVI0xYJWAcY7ZfUj87JAwIG4O
         lRPwC68SOPhoGooDZFA5k1QSTlf8mlNm46Yk/MXGKIsspJhUXhrzfJaf9bQrHKbmL5
         VPc4GmdYq1+hFxj3B0ADViKSdTvCpXfbqbtzkCSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 213/244] mwl8k: Fix a double Free in mwl8k_probe_hw
Date:   Wed, 12 May 2021 16:49:44 +0200
Message-Id: <20210512144749.808793434@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index c4db6417748f..1b76b2419186 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1469,6 +1469,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	txq->skb = kcalloc(MWL8K_TX_DESCS, sizeof(*txq->skb), GFP_KERNEL);
 	if (txq->skb == NULL) {
 		pci_free_consistent(priv->pdev, size, txq->txd, txq->txd_dma);
+		txq->txd = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.30.2



