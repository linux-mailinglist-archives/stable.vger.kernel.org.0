Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868C3150B14
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgBCQXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgBCQUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:20:14 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD3952086A;
        Mon,  3 Feb 2020 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746814;
        bh=wmjiu5PEYm5uCqktUKV3PAIyZwrB09SvsJ4xWzYRc48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJxjHly2VMGRQ990amZYplpXeqnQScFG6+E1YcjRiVm+Y0Yz3Iw12g7r70tYAJ84/
         PXzcCBLXWwsyrvQ8+P+6+2o9DP5VH8wbTNp6NBDf5G3xnE0gJXht/u5Dsdu0ZsKijH
         cWVNSvHsxW0ItnuppxQmIYuxjVyivUmHuabzUN+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/53] net: wan: sdla: Fix cast from pointer to integer of different size
Date:   Mon,  3 Feb 2020 16:19:10 +0000
Message-Id: <20200203161906.444105143@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 00c0688cecadbf7ac2f5b4cdb36d912a2d3f0cca ]

Since net_device.mem_start is unsigned long, it should not be cast to
int right before casting to pointer.  This fixes warning (compile
testing on alpha architecture):

    drivers/net/wan/sdla.c: In function ‘sdla_transmit’:
    drivers/net/wan/sdla.c:711:13: warning:
        cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/sdla.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index 421ac5f856994..79fd891509479 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -711,7 +711,7 @@ static netdev_tx_t sdla_transmit(struct sk_buff *skb,
 
 					spin_lock_irqsave(&sdla_lock, flags);
 					SDLA_WINDOW(dev, addr);
-					pbuf = (void *)(((int) dev->mem_start) + (addr & SDLA_ADDR_MASK));
+					pbuf = (void *)(dev->mem_start + (addr & SDLA_ADDR_MASK));
 					__sdla_write(dev, pbuf->buf_addr, skb->data, skb->len);
 					SDLA_WINDOW(dev, addr);
 					pbuf->opp_flag = 1;
-- 
2.20.1



