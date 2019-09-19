Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47D21B8631
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406156AbfISW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406657AbfISWVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:21:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2622120678;
        Thu, 19 Sep 2019 22:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931659;
        bh=fMTYKkn1JVWInp865hwLQU2k2oWe/XIG6yRkXnaZlh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUrVqofiX6XECOAMRxCnP3AksiEIg4J3DJv5Azj5IiK1CFCdWXGziOxGHQmGMaC+G
         IV3llOROV9R6wcenVqvW78N88B+GV7IkmUMrQgj3qTExVGsjLVeQXqZou7rs0+WQE6
         vSev9px2FSRtbNMxYOD2t0RFtws88Qnu4H2bBRQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 66/74] net: seeq: Fix the function used to release some memory in an error handling path
Date:   Fri, 20 Sep 2019 00:04:19 +0200
Message-Id: <20190919214810.900440107@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e1e54ec7fb55501c33b117c111cb0a045b8eded2 ]

In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
a call to 'get_zeroed_page()' has been turned into a call to
'dma_alloc_coherent()'. Only the remove function has been updated to turn
the corresponding 'free_page()' into 'dma_free_attrs()'.
The error hndling path of the probe function has not been updated.

Fix it now.

Rename the corresponding label to something more in line.

Fixes: 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index c2bd5378ffdaf..3527962f0bdad 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -792,15 +792,16 @@ static int sgiseeq_probe(struct platform_device *pdev)
 		printk(KERN_ERR "Sgiseeq: Cannot register net device, "
 		       "aborting.\n");
 		err = -ENODEV;
-		goto err_out_free_page;
+		goto err_out_free_attrs;
 	}
 
 	printk(KERN_INFO "%s: %s %pM\n", dev->name, sgiseeqstr, dev->dev_addr);
 
 	return 0;
 
-err_out_free_page:
-	free_page((unsigned long) sp->srings);
+err_out_free_attrs:
+	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
 err_out_free_dev:
 	free_netdev(dev);
 
-- 
2.20.1



