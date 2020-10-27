Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC229B984
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802555AbgJ0PuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801326AbgJ0PkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E71182231B;
        Tue, 27 Oct 2020 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813203;
        bh=d9Luts6JU/UbuZLkP5C9QvdS4KL9oqIXRMHZ9FGV4Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CApov3058Rvy+rfwthfaponXYTjE0fCYx8q6K9ZtY1JvCYLyajIJE/HwXoOBbcUUy
         aiqrS6vwIksfqN1UqX1xXTPTlkkI2f/bqZ/jVwD4rNWhRYYIEsntMS0vV8A/vYbgVf
         MsWcUfaM1kJt+7SbkT8QzCaaEllfG+BP3hjhC48E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 471/757] mtd: hyperbus: hbmc-am654: Fix direct mapping setup flash access
Date:   Tue, 27 Oct 2020 14:52:01 +0100
Message-Id: <20201027135512.605519019@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit aca31ce96814c84d1a41aaa109c15abe61005af7 ]

Setting up of direct mapping should be done with flash node's IO
address space and not with controller's IO region.

Fixes: b6fe8bc67d2d3 ("mtd: hyperbus: move direct mapping setup to AM654 HBMC driver")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20200924081214.16934-3-vigneshr@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/hbmc-am654.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/hyperbus/hbmc-am654.c b/drivers/mtd/hyperbus/hbmc-am654.c
index e0e33f6bf513b..1e70ecfffa39f 100644
--- a/drivers/mtd/hyperbus/hbmc-am654.c
+++ b/drivers/mtd/hyperbus/hbmc-am654.c
@@ -70,7 +70,8 @@ static int am654_hbmc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	ret = of_address_to_resource(np, 0, &res);
+	priv->hbdev.np = of_get_next_child(np, NULL);
+	ret = of_address_to_resource(priv->hbdev.np, 0, &res);
 	if (ret)
 		return ret;
 
@@ -103,7 +104,6 @@ static int am654_hbmc_probe(struct platform_device *pdev)
 	priv->ctlr.dev = dev;
 	priv->ctlr.ops = &am654_hbmc_ops;
 	priv->hbdev.ctlr = &priv->ctlr;
-	priv->hbdev.np = of_get_next_child(dev->of_node, NULL);
 	ret = hyperbus_register_device(&priv->hbdev);
 	if (ret) {
 		dev_err(dev, "failed to register controller\n");
-- 
2.25.1



