Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C113EB82B
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbhHMPLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241344AbhHMPLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB776113E;
        Fri, 13 Aug 2021 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867434;
        bh=ZzV4QEj4kEZU7uAWg4HDmIrIlFVTGr/+FeC+pZdENAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEcOZP1kNR3K+W1+EPwn8P4FS/KZGg60yhkv//1fYW6EKVCkXkgXF637K2adYvNCz
         pWYs57PRnYweOhi+0KZB+VVjrnP/AZN8wHr0ilQ3tSE6IelkklWBUq9zNgI4ZRO3U6
         3dfbFx1hTNy0wPZkoJKmP0Kk8QaUQGNXg8UmFx4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/42] net: fec: fix use-after-free in fec_drv_remove
Date:   Fri, 13 Aug 2021 17:06:38 +0200
Message-Id: <20210813150525.518279512@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 44712965bf12ae1758cec4de53816ed4b914ca1a ]

Smatch says:
	drivers/net/ethernet/freescale/fec_main.c:3994 fec_drv_remove() error: Using fep after free_{netdev,candev}(ndev);
	drivers/net/ethernet/freescale/fec_main.c:3995 fec_drv_remove() error: Using fep after free_{netdev,candev}(ndev);

Since fep pointer is netdev private data, accessing it after free_netdev()
call can cause use-after-free bug. Fix it by moving free_netdev() call at
the end of the function

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: a31eda65ba21 ("net: fec: fix clock count mis-match")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 22f964ef859e..29902b8709f1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3581,13 +3581,13 @@ fec_drv_remove(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-	free_netdev(ndev);
 
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.30.2



