Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A93CA862
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhGOTA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242368AbhGOS7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 101F2613D3;
        Thu, 15 Jul 2021 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375398;
        bh=ejLs/9B8myPw5TPe2fDeG1oNOhZQi2VNiScpEUlppV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySXL+vcqzcZ/bAlgfVfCt3lHrVSsU80L3OVGGY4J+YgBmVWwOhICgiKt7z5M+pPGV
         8vZXu8eYokTGu6+vYdvDoYPM7BJRF6ifwumnGJiEh9ksbyHtZEpBNcM7T6aOVjwaKF
         wMOH6JaqydClIWI2yMaeHney62P2w84tGxN7wbA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 028/242] net: xilinx_emaclite: Do not print real IOMEM pointer
Date:   Thu, 15 Jul 2021 20:36:30 +0200
Message-Id: <20210715182556.830004577@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 ]

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
 argument 4 to %08lX specifier is cast from pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 007840d4a807..3ffe8d2a1f14 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1193,9 +1193,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08lX mapped to 0x%08lX, irq=%d\n",
-		 (unsigned long __force)ndev->mem_start,
-		 (unsigned long __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08lX mapped to 0x%p, irq=%d\n",
+		 (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:
-- 
2.30.2



