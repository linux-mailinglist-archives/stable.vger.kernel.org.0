Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55B39628D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhEaO5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhEaOzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 380E661443;
        Mon, 31 May 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469585;
        bh=ToxFAM03NGglVb/WULSpr2V/zGni3WLW+L5SxpRfznM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDWSMyd7RS0IYz5AQJuFLgxCmfVX4h5lU1hQScQZJEDvPxp6LFfsNLJMwKaaHYCtS
         YrV4YPqtH98Q48a7h+8wD8PIWy7LuCBHGlnuGrA+ArBnvNNOlhWIJw3vYwBxkoraaj
         DYi2FcOI1pvP1nglHt4T1QdWWRQsI6Q3pGAYaNLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 255/296] gve: Correct SKB queue index validation.
Date:   Mon, 31 May 2021 15:15:10 +0200
Message-Id: <20210531130712.334260653@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>

[ Upstream commit fbd4a28b4fa66faaa7f510c0adc531d37e0a7848 ]

SKBs with skb_get_queue_mapping(skb) == tx_cfg.num_queues should also be
considered invalid.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index bb57c42872b4..3e04a3973d68 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -593,7 +593,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	struct gve_tx_ring *tx;
 	int nsegs;
 
-	WARN(skb_get_queue_mapping(skb) > priv->tx_cfg.num_queues,
+	WARN(skb_get_queue_mapping(skb) >= priv->tx_cfg.num_queues,
 	     "skb queue index out of range");
 	tx = &priv->tx[skb_get_queue_mapping(skb)];
 	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
-- 
2.30.2



