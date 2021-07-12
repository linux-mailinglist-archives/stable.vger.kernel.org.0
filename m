Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F713C4E0B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhGLHQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243482AbhGLHPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9010B61409;
        Mon, 12 Jul 2021 07:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073945;
        bh=2GSrmxk/D5DTqfdx5V5PejTHTpKTn6TNsAo3GA9JEds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsrHtYttJc4tPvYAT9Rsa4gxKDUSD+7LuSzZxqRT1+PXrCWdy1rJoqHWrBiOoAS00
         d6dEUSrmDQ9zoh+UDOYB6JGz9xiK9bTXph0yd16vRWtwvi8x5MvnZkBalTEQgF0E8y
         JLPQCNGFi25DbHPI+15LW+wTfnqQylker9bML+/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hang Zhang <zh.nvgt@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 413/700] cw1200: Revert unnecessary patches that fix unreal use-after-free bugs
Date:   Mon, 12 Jul 2021 08:08:16 +0200
Message-Id: <20210712061020.324296012@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hang Zhang <zh.nvgt@gmail.com>

[ Upstream commit 3f60f4685699aa6006e58e424637e8e413e0a94d ]

A previous commit 4f68ef64cd7f ("cw1200: Fix concurrency
use-after-free bugs in cw1200_hw_scan()") tried to fix a seemingly
use-after-free bug between cw1200_bss_info_changed() and
cw1200_hw_scan(), where the former frees a sk_buff pointed
to by frame.skb, and the latter accesses the sk_buff
pointed to by frame.skb. However, this issue should be a
false alarm because:

(1) "frame.skb" is not a shared variable between the above
two functions, because "frame" is a local function variable,
each of the two functions has its own local "frame" - they
just happen to have the same variable name.

(2) the sk_buff(s) pointed to by these two "frame.skb" are
also two different object instances, they are individually
allocated by different dev_alloc_skb() within the two above
functions. To free one object instance will not invalidate
the access of another different one.

Based on these facts, the previous commit should be unnecessary.
Moreover, it also introduced a missing unlock which was
addressed in a subsequent commit 51c8d24101c7 ("cw1200: fix missing
unlock on error in cw1200_hw_scan()"). Now that the
original use-after-free is unreal, these two commits should
be reverted. This patch performs the reversion.

Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
Fixes: 51c8d24101c7 ("cw1200: fix missing unlock on error in cw1200_hw_scan()")
Signed-off-by: Hang Zhang <zh.nvgt@gmail.com>
Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210521223238.25020-1-zh.nvgt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/scan.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index 988581cc134b..1f856fbbc0ea 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -75,30 +75,27 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_ssids > WSM_SCAN_MAX_NUM_OF_SSIDS)
 		return -EINVAL;
 
-	/* will be unlocked in cw1200_scan_work() */
-	down(&priv->scan.lock);
-	mutex_lock(&priv->conf_mutex);
-
 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
 		req->ie_len);
-	if (!frame.skb) {
-		mutex_unlock(&priv->conf_mutex);
-		up(&priv->scan.lock);
+	if (!frame.skb)
 		return -ENOMEM;
-	}
 
 	if (req->ie_len)
 		skb_put_data(frame.skb, req->ie, req->ie_len);
 
+	/* will be unlocked in cw1200_scan_work() */
+	down(&priv->scan.lock);
+	mutex_lock(&priv->conf_mutex);
+
 	ret = wsm_set_template_frame(priv, &frame);
 	if (!ret) {
 		/* Host want to be the probe responder. */
 		ret = wsm_set_probe_responder(priv, true);
 	}
 	if (ret) {
-		dev_kfree_skb(frame.skb);
 		mutex_unlock(&priv->conf_mutex);
 		up(&priv->scan.lock);
+		dev_kfree_skb(frame.skb);
 		return ret;
 	}
 
@@ -120,8 +117,8 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 		++priv->scan.n_ssids;
 	}
 
-	dev_kfree_skb(frame.skb);
 	mutex_unlock(&priv->conf_mutex);
+	dev_kfree_skb(frame.skb);
 	queue_work(priv->workqueue, &priv->scan.work);
 	return 0;
 }
-- 
2.30.2



