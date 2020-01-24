Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD21482FE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404444AbgAXLcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404437AbgAXLc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:32:26 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0BF20718;
        Fri, 24 Jan 2020 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865546;
        bh=x4X64ze7Gkby5ghBKDeSUN+zScMvvgWQel2F1YrZ8vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0w/ngmlS26PEI458v2EHIf5ruK4DRsEaJf98yx//hYKqUs2JkArIto/er/mtq/aA
         9AkXKRTZOUpnsp/LVMUwNMNscPjQzU2CdV60ISrOt9bCLSyKBhr6+rfgksU9AhQBFQ
         ptnmxRzuNm/waCNHjlOfo0cS46CkJxGI0AdZGEW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 559/639] net: sonic: replace dev_kfree_skb in sonic_send_packet
Date:   Fri, 24 Jan 2020 10:32:09 +0100
Message-Id: <20200124093159.342865144@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>

[ Upstream commit 49f6c90bf6805948b597eabb499e500a47cf24be ]

sonic_send_packet will be processed in irq or non-irq
context, so it would better use dev_kfree_skb_any
instead of dev_kfree_skb.

Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index be36f7117d484..5f1875fe47cdf 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -232,7 +232,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
 	if (!laddr) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.20.1



