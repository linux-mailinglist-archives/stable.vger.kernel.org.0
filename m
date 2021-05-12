Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59137CA89
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbhELQas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237988AbhELQYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:24:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C47561DB7;
        Wed, 12 May 2021 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834483;
        bh=PNu7+jadj9x9BmJTVziJwL/PZSEIZ6YdtI/TsPT2bJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1qNhwffOrsChqlw9sC7ZlqQLNa2xUGQmcTTMnOEgxqmg6z2r/8EHp0p4GcDH9ZD8
         27F6vchxAxJWSqDo7LvsmZa7jkeH5eDpCDaR0xEtuiiQrHG6Zsbpf/Nzbog2ENQClg
         ruNzlDLY6VpUDWtLsuRiI8AHGh9W50J7XfLa9PAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 555/601] ath10k: Fix a use after free in ath10k_htc_send_bundle
Date:   Wed, 12 May 2021 16:50:32 +0200
Message-Id: <20210512144846.133817548@linuxfoundation.org>
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



