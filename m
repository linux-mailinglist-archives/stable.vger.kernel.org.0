Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F5137C67B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhELPvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236879AbhELPrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB33961C9B;
        Wed, 12 May 2021 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833031;
        bh=PNu7+jadj9x9BmJTVziJwL/PZSEIZ6YdtI/TsPT2bJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AddP0M3RV53MPbdcgPhklB4m1LzbIfOnupv1+nQI1wUVKz2eCmlUS5/P+BC/AAP8o
         PAIkyaPmAtYoufXsT3kP7N5No7eUBD06dC+LAJ+LDil8oQhuBhj1VkQ4+mJrz4Chi/
         1bEjRybkGVz0lh86bC7uYIWMHkRLuYyPkv3/SXc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 487/530] ath10k: Fix a use after free in ath10k_htc_send_bundle
Date:   Wed, 12 May 2021 16:49:57 +0200
Message-Id: <20210512144835.763338058@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 8392df5d7e0b6a7d21440da1fc259f9938f4dec3 ]

In ath10k_htc_send_bundle, the bundle_skb could be freed by
dev_kfree_skb_any(bundle_skb). But the bundle_skb is used later
by bundle_skb->len.

As skb_len = bundle_skb->len, my patch replaces bundle_skb->len to
skb_len after the bundle_skb was freed.

Fixes: c8334512f3dd1 ("ath10k: add htt TX bundle for sdio")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210329120154.8963-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 31df6dd04bf6..540dd59112a5 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -665,7 +665,7 @@ static int ath10k_htc_send_bundle(struct ath10k_htc_ep *ep,
 
 	ath10k_dbg(ar, ATH10K_DBG_HTC,
 		   "bundle tx status %d eid %d req count %d count %d len %d\n",
-		   ret, ep->eid, skb_queue_len(&ep->tx_req_head), cn, bundle_skb->len);
+		   ret, ep->eid, skb_queue_len(&ep->tx_req_head), cn, skb_len);
 	return ret;
 }
 
-- 
2.30.2



