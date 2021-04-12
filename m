Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E7E35BE46
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhDLI5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239020AbhDLIzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CF806128B;
        Mon, 12 Apr 2021 08:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217697;
        bh=Krd77hBQBkxzj/KB8aU9+agjS5bKvVQzede4ZgEdJwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJJnbLcFrJUtGCWm7SYVC/PwxD2LC2xSoZhJ7egaDAh7qvtFRyjr2G5iTabxv5m/9
         A9KMF994O90U0KleH4N/TmCiiZuyxKugzE6vSgNRzN+v2INRqJPnizYYxTVY76EFGq
         /M+2ggPogfuNuq8QU0K+ohKQAGHaFt9fCvWvxth0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/188] drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
Date:   Mon, 12 Apr 2021 10:40:27 +0200
Message-Id: <20210412084017.412540900@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 1b479fb801602b22512f53c19b1f93a4fc5d5d9d ]

In pvc_xmit, if __skb_pad(skb, pad, false) failed, it will free
the skb in the first time and goto drop. But the same skb is freed
by kfree_skb(skb) in the second time in drop.

Maintaining the original function unchanged, my patch adds a new
label out to avoid the double free if __skb_pad() failed.

Fixes: f5083d0cee08a ("drivers/net/wan/hdlc_fr: Improvements to the code of pvc_xmit")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_fr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 409e5a7ad8e2..857912ae84d7 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -415,7 +415,7 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		if (pad > 0) { /* Pad the frame with zeros */
 			if (__skb_pad(skb, pad, false))
-				goto drop;
+				goto out;
 			skb_put(skb, pad);
 		}
 	}
@@ -448,8 +448,9 @@ static netdev_tx_t pvc_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 drop:
-	dev->stats.tx_dropped++;
 	kfree_skb(skb);
+out:
+	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 }
 
-- 
2.30.2



