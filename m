Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2B13960B3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhEaOa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhEaO1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:27:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E5061613;
        Mon, 31 May 2021 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468864;
        bh=rBrdI77HY/HSOdFz+fqOt2pQNvjFD10h6ks7goS58YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XllP85OFXgDsrSDu9rhEwXsdoha/XXTvVrBgHHYA+M57D6ygyJZoDCPdfisznyfNc
         eu2htMXZvgR5Iq+hzK5WDfT5SHFI0nI6SzF9gBW9cJ/OO96U81+4sldQMIWbw4ccrq
         4bvS4GT1eyT5eLhGlzWBYTUcBYdovwYwLWqyi6dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/177] gve: Correct SKB queue index validation.
Date:   Mon, 31 May 2021 15:15:13 +0200
Message-Id: <20210531130653.309315771@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index 30532ee28dd3..b653197b34d1 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -482,7 +482,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	struct gve_tx_ring *tx;
 	int nsegs;
 
-	WARN(skb_get_queue_mapping(skb) > priv->tx_cfg.num_queues,
+	WARN(skb_get_queue_mapping(skb) >= priv->tx_cfg.num_queues,
 	     "skb queue index out of range");
 	tx = &priv->tx[skb_get_queue_mapping(skb)];
 	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
-- 
2.30.2



