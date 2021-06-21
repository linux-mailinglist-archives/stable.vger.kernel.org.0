Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BFD3AF00C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhFUQqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233165AbhFUQnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F5A613C3;
        Mon, 21 Jun 2021 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293094;
        bh=d+g7YDR3s4fyFU+lRgbYA9HWwEXhh9+9KRj2Q+msbSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coTs7l4eZVMcJYRpl11Mrn6E/2RBXb4Cvi+qyOwr8UipxNVBBQXjCF8nEP2SHXLW2
         NrEH7ktOh8CbSLMdU5B26epmHlpvkyexu4ULIsB0WQ1y0mtS16zjUqUqCBimvv9beq
         DQxV6co9P26brR0IZtoWtlVzeUwFFrft4KWiTK8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 063/178] net: mhi_net: Update the transmit handler prototype
Date:   Mon, 21 Jun 2021 18:14:37 +0200
Message-Id: <20210621154924.637664835@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

[ Upstream commit 2214fb53006e6cfa6371b706070cb99794c68c3b ]

Update the function prototype of mhi_ndo_xmit to match
ndo_start_xmit. This otherwise leads to run time failures when
CFI is enabled in kernel.

Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mhi/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index f59960876083..8e7f8728998f 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -49,7 +49,7 @@ static int mhi_ndo_stop(struct net_device *ndev)
 	return 0;
 }
 
-static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
 	const struct mhi_net_proto *proto = mhi_netdev->proto;
-- 
2.30.2



