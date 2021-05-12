Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC537CA5F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbhELQ3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236175AbhELQVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C1946127A;
        Wed, 12 May 2021 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834395;
        bh=ofRdwmNGjMVERvYMDSuH+wYu29kfFs1ywL22evLozE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=io4EaklKFVqpMcIhc+v6betVFKdG74lQq/kyAKWy6r5YuGpS9Treybp7XWcrk7bm/
         KbJBDy+bT+c1jc6Du1E1BRoJsELuk0ZWsbz8+V46mnfE9oQaE3y6nGf6S51ucA04+Z
         wL1hou7CPgsLwq1uIbPdOYE/vPXLnYIB6mJCqx+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 527/601] mwl8k: Fix a double Free in mwl8k_probe_hw
Date:   Wed, 12 May 2021 16:50:04 +0200
Message-Id: <20210512144845.207315292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index abf3b0233ccc..e98e7680eb53 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1474,6 +1474,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	if (txq->skb == NULL) {
 		dma_free_coherent(&priv->pdev->dev, size, txq->txd,
 				  txq->txd_dma);
+		txq->txd = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.30.2



