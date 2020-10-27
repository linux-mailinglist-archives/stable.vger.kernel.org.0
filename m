Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3761B29B510
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789741AbgJ0PIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790990AbgJ0PFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4347521D24;
        Tue, 27 Oct 2020 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811140;
        bh=bvfBFRDNthHschglZKGPr7aDzYEuc31YlegaI5qE6hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgzAbVKbKBbE2zigPd8ytZj/3duD8Fh3qh7UEbv1RqP7UnENr6+Gaoiz5WhvZmi54
         yrWqZF70GOtRB3vq08mU681DwNxSaSm1rfWHWkrolhhedf7ACIQ2fNpOeylRmYcCle
         QbHzd3uHEXmCgE4r+s5sET9RRStKQ3nZhVHxx0x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 388/633] mtd: hyperbus: hbmc-am654: Fix direct mapping setup flash access
Date:   Tue, 27 Oct 2020 14:52:11 +0100
Message-Id: <20201027135540.908623141@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index f350a0809f880..a808fa28cd9a1 100644
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



