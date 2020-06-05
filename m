Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8641EFB33
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgFEORH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgFEORG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C34B20835;
        Fri,  5 Jun 2020 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366626;
        bh=mJ93CnXc9YSI6aOXXURM2kusgG8AVDTiDJs40asWSXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaJQDVw66AbIWC9/dDUQRdBCkrn5Oc8I99pDHxBDhoxRgx1uDDgHFC0C+bzz0zOIU
         +joXAF1G1D8+Bf5Df76qF2NU1R8CcAwLc4+jL0s/YY7wVqtLQ7tldJS/PbgA/TPGRj
         xuVEvMH6PJSI5wA6TJitfG8ZEG4HVEbyTB5mARUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 29/43] net: Fix return value about devm_platform_ioremap_resource()
Date:   Fri,  5 Jun 2020 16:14:59 +0200
Message-Id: <20200605140154.050212353@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit ef24d6c3d6965158dfe23ae961d87e9a343e18a2 ]

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ifi_canfd/ifi_canfd.c     | 5 ++++-
 drivers/net/can/sun4i_can.c               | 2 +-
 drivers/net/dsa/b53/b53_srab.c            | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 04d59bede5ea..74503cacf594 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -947,8 +947,11 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 	u32 id, rev;
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
 	irq = platform_get_irq(pdev, 0);
-	if (IS_ERR(addr) || irq < 0)
+	if (irq < 0)
 		return -EINVAL;
 
 	id = readl(addr + IFI_CANFD_IP_ID);
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e3ba8ab0cbf4..e2c6cf4b2228 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -792,7 +792,7 @@ static int sun4ican_probe(struct platform_device *pdev)
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
-		err = -EBUSY;
+		err = PTR_ERR(addr);
 		goto exit;
 	}
 
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 0a1be5259be0..38cd8285ac67 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -609,7 +609,7 @@ static int b53_srab_probe(struct platform_device *pdev)
 
 	priv->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->regs))
-		return -ENOMEM;
+		return PTR_ERR(priv->regs);
 
 	dev = b53_switch_alloc(&pdev->dev, &b53_srab_ops, priv);
 	if (!dev)
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 7a0d785b826c..17243bb5ba91 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1418,7 +1418,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	pep->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pep->base)) {
-		err = -ENOMEM;
+		err = PTR_ERR(pep->base);
 		goto err_netdev;
 	}
 
-- 
2.25.1



