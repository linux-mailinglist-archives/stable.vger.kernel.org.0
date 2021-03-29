Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2119C34C8CC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhC2IYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231993AbhC2IGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF19861601;
        Mon, 29 Mar 2021 08:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005211;
        bh=UqKxY8JrXkGafpGGXo/vi1eZjNzvixcPNWB8ebfj0EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vi2Q8NSKDLpChVqC9Z1Cmk+jDgEvvrTQ0oE1Uxtps514fJUAkTrLSINWO6n43s3ap
         aEQ9isRaQTQ9qEnAujq1Xfj1f9TxkrOJbFgkRwA0mT5M9PUZqFA3soHtTGSLIhLGDp
         jpZw+ns9Ca7RV5fn6SFF0FiUBgwZx1ZjxD/WE/dA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/59] can: c_can_pci: c_can_pci_remove(): fix use-after-free
Date:   Mon, 29 Mar 2021 09:58:18 +0200
Message-Id: <20210329075610.142096952@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 0429d6d89f97ebff4f17f13f5b5069c66bde8138 ]

There is a UAF in c_can_pci_remove(). dev is released by
free_c_can_dev() and is used by pci_iounmap(pdev, priv->base) later.
To fix this issue, save the mmio address before releasing dev.

Fixes: 5b92da0443c2 ("c_can_pci: generic module for C_CAN/D_CAN on PCI")
Link: https://lore.kernel.org/r/20210301024512.539039-1-ztong0001@gmail.com
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index d065c0e2d18e..f3e0b2124a37 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -239,12 +239,13 @@ static void c_can_pci_remove(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct c_can_priv *priv = netdev_priv(dev);
+	void __iomem *addr = priv->base;
 
 	unregister_c_can_dev(dev);
 
 	free_c_can_dev(dev);
 
-	pci_iounmap(pdev, priv->base);
+	pci_iounmap(pdev, addr);
 	pci_disable_msi(pdev);
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
-- 
2.30.1



