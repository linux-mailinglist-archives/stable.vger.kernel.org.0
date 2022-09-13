Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA85B7548
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiIMPjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiIMPiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:38:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B16F249;
        Tue, 13 Sep 2022 07:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B480B614B5;
        Tue, 13 Sep 2022 14:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DA3C433D6;
        Tue, 13 Sep 2022 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079502;
        bh=AMvkWcumkyw9/k0EQQQuY6LBmsfboRqftOvewoCknF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRW6twSggyTVCRhUYEtRCqVrgl5CpXYQ3nN5JJ8Ux/shAc3N3RKcJlv08QrXyFA0t
         6U1s0l/9ormHJnS9vw6SqDhnsaaLhcGK35xAN9UzhRpE3rMc+s9fsks6GTarlvNvSa
         TQV11e+S539qqxuZbhUgccm9Y6dlllvXtDDwV1PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Qiong <liqiong@nfschina.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/79] parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()
Date:   Tue, 13 Sep 2022 16:07:09 +0200
Message-Id: <20220913140351.370430390@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit d46c742f827fa2326ab1f4faa1cccadb56912341 ]

As the possible failure of the kmalloc(), it should be better
to fix this error path, check and return '-ENOMEM' error code.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/ccio-dma.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 6efab7a06c5fc..73ee74d6e7a3d 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1390,15 +1390,17 @@ ccio_init_resource(struct resource *res, char *name, void __iomem *ioaddr)
 	}
 }
 
-static void __init ccio_init_resources(struct ioc *ioc)
+static int __init ccio_init_resources(struct ioc *ioc)
 {
 	struct resource *res = ioc->mmio_region;
 	char *name = kmalloc(14, GFP_KERNEL);
-
+	if (unlikely(!name))
+		return -ENOMEM;
 	snprintf(name, 14, "GSC Bus [%d/]", ioc->hw_path);
 
 	ccio_init_resource(res, name, &ioc->ioc_regs->io_io_low);
 	ccio_init_resource(res + 1, name, &ioc->ioc_regs->io_io_low_hv);
+	return 0;
 }
 
 static int new_ioc_area(struct resource *res, unsigned long size,
@@ -1552,7 +1554,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 		return -ENOMEM;
 	}
 	ccio_ioc_init(ioc);
-	ccio_init_resources(ioc);
+	if (ccio_init_resources(ioc)) {
+		kfree(ioc);
+		return -ENOMEM;
+	}
 	hppa_dma_ops = &ccio_ops;
 	dev->dev.platform_data = kzalloc(sizeof(struct pci_hba_data), GFP_KERNEL);
 
-- 
2.35.1



