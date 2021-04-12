Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4865735C04E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhDLJMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239740AbhDLJIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CCC6124A;
        Mon, 12 Apr 2021 09:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218242;
        bh=JS/SJUd7qbKW5QxCvd6fSt+MoEbM0T8Q5uOeCAeTN3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clHHF09VrXV14Ula49q4/pZMoVferz3Xcwq2AQSfeEW/zbaFlYoPSs/jPbnw2zzHO
         0ZFFTOZn9qzopkHQtgLRobf+8iw8LsLjICUSZp46srTh9Ioqnuq5WF/Y3nyiYDSRzU
         yf3YWWjivtycPSNI9RF2hDU/KH1lAXCpBzvGVVrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 123/210] drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
Date:   Mon, 12 Apr 2021 10:40:28 +0200
Message-Id: <20210412084020.103579318@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 0720f5f92caa..4d9dc7d15908 100644
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



