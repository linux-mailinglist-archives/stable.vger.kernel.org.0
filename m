Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5D839625E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhEaOzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233310AbhEaOxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 227D761CAE;
        Mon, 31 May 2021 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469532;
        bh=6hIoaJZmcpY6BZ8Ewtn35i/NxBp+ZTtllir+rWm/Vks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClrV541m77vXvPDIoA49MXtK8fmfHdmQZZ8bzRvii2gODTDRmu0pNuU28eT3MZNAS
         Jrms86H32hTSZA30EX9o4/wAwzJkFHxNvS2UYqS7z+lvV0L7LJqSWWh8oNVKm8Ja/l
         51HJtpAJo/3fWn/wJTABxajOHlYstEITkBVoe500=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 233/296] net: fec: fix the potential memory leak in fec_enet_init()
Date:   Mon, 31 May 2021 15:14:48 +0200
Message-Id: <20210531130711.640150163@linuxfoundation.org>
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

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 619fee9eb13b5d29e4267cb394645608088c28a8 ]

If the memory allocated for cbd_base is failed, it should
free the memory allocated for the queues, otherwise it causes
memory leak.

And if the memory allocated for the queues is failed, it can
return error directly.

Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 70aea9c274fe..89393fbc726f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3282,7 +3282,9 @@ static int fec_enet_init(struct net_device *ndev)
 		return ret;
 	}
 
-	fec_enet_alloc_queue(ndev);
+	ret = fec_enet_alloc_queue(ndev);
+	if (ret)
+		return ret;
 
 	bd_size = (fep->total_tx_ring_size + fep->total_rx_ring_size) * dsize;
 
@@ -3290,7 +3292,8 @@ static int fec_enet_init(struct net_device *ndev)
 	cbd_base = dmam_alloc_coherent(&fep->pdev->dev, bd_size, &bd_dma,
 				       GFP_KERNEL);
 	if (!cbd_base) {
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_queue_mem;
 	}
 
 	/* Get the Ethernet address */
@@ -3368,6 +3371,10 @@ static int fec_enet_init(struct net_device *ndev)
 		fec_enet_update_ethtool_stats(ndev);
 
 	return 0;
+
+free_queue_mem:
+	fec_enet_free_queue(ndev);
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.30.2



