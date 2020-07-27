Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4D122F00E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgG0OVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731728AbgG0OVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13B52070A;
        Mon, 27 Jul 2020 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859690;
        bh=h1XxfQffSdng9jG/pVznLTCz6+7NXwQpLZd95y/eJKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlyW9E9XeVtcupysc2rmkd+8IaqufcTz3QDNvx3+1hTpkSWoyN/GZtoRj8/rHePvG
         uMGv5QcN9tVKqthSvhRRmKhiqEQi5TGf6A65W/tbHAD+OckgFqyt3RjnXQN0/5v/HP
         wcPAdDBF15xZ7b5sIaX5H8f1vfPzFpsmS9hKbP5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 068/179] dpaa_eth: Fix one possible memleak in dpaa_eth_probe
Date:   Mon, 27 Jul 2020 16:04:03 +0200
Message-Id: <20200727134935.981834348@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 6790711f8ac5faabc43237c0d05d93db431a1ecc ]

When dma_coerce_mask_and_coherent() fails, the alloced netdev need to be freed.

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6bfa7575af942..5f82c1f32f09b 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2938,7 +2938,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 						   DMA_BIT_MASK(40));
 	if (err) {
 		netdev_err(net_dev, "dma_coerce_mask_and_coherent() failed\n");
-		return err;
+		goto free_netdev;
 	}
 
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
-- 
2.25.1



