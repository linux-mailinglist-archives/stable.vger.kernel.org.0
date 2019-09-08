Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5215ACE4C
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbfIHM5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730985AbfIHMsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:22 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7022B2190F;
        Sun,  8 Sep 2019 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946902;
        bh=8svUIhnehzzECOzI2oNIKP/CjJxUGqIVc4hLamT4NC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7KhGZ0ZrzoznRRSvlezVlNBUJ39nKwXScAEpXUqcf2MFvvEX2p6I44KMD1OY61CL
         yYe0Gg1dIuDK8Sa2J/u/sAMqmyx1oJ4qkdC90J7EFuSnof3cOHq1IK45bBRpZDDS82
         shYZ16x1rPVGtfOUqwmQ0MCPUinrDcnVNg9Klqao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/57] IB/mlx4: Fix memory leaks
Date:   Sun,  8 Sep 2019 13:42:08 +0100
Message-Id: <20190908121145.131812089@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5c1baaa82cea2c815a5180ded402a7cd455d1810 ]

In mlx4_ib_alloc_pv_bufs(), 'tun_qp->tx_ring' is allocated through
kcalloc(). However, it is not always deallocated in the following execution
if an error occurs, leading to memory leaks. To fix this issue, free
'tun_qp->tx_ring' whenever an error occurs.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Acked-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/1566159781-4642-1-git-send-email-wenwen@cs.uga.edu
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index e5466d786bb1e..5aaa2a6c431b6 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1668,8 +1668,6 @@ tx_err:
 				    tx_buf_size, DMA_TO_DEVICE);
 		kfree(tun_qp->tx_ring[i].buf.addr);
 	}
-	kfree(tun_qp->tx_ring);
-	tun_qp->tx_ring = NULL;
 	i = MLX4_NUM_TUNNEL_BUFS;
 err:
 	while (i > 0) {
@@ -1678,6 +1676,8 @@ err:
 				    rx_buf_size, DMA_FROM_DEVICE);
 		kfree(tun_qp->ring[i].addr);
 	}
+	kfree(tun_qp->tx_ring);
+	tun_qp->tx_ring = NULL;
 	kfree(tun_qp->ring);
 	tun_qp->ring = NULL;
 	return -ENOMEM;
-- 
2.20.1



