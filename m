Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3385A6A0F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiH3RZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiH3RYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D499BDC5CD;
        Tue, 30 Aug 2022 10:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC60B81D0C;
        Tue, 30 Aug 2022 17:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DE4C433D6;
        Tue, 30 Aug 2022 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880144;
        bh=t/IuHrlcFJzD4wEDVvMD5tRh3tZgRHNPMtfF5B5TnTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8jKk2ywM/nByGACRW36tyvq783qteo2Yi7rOwbVSyZMfZOFe9w7M6stL99dR699P
         uZTQPx2fFB6KHDOMVryMLZV0G5BKXaFIV0sWD+Q9C88RhB1+nGclC2dbrii5pz8YCK
         gUUAh272Xh0hlsd1EljQdVlB2ZQKFuw9hM+f9ExjhEivvUIoK5jiX4W1k5/v2FC96/
         sgJxTQnQ65bnEEoaTwZBSfROzr5glBRMv00svVSlNMqxOi9wLR/UFljbtzi26T92cS
         ToZLBWQhZ5rZOu29EwgqDBOtPCMGDvO85WLpdWk4mpO+w4E/s9jMABfg7SQ5gj+TKi
         AASH8B4I1kG2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiong <liqiong@nfschina.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/23] parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()
Date:   Tue, 30 Aug 2022 13:21:28 -0400
Message-Id: <20220830172141.581086-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172141.581086-1-sashal@kernel.org>
References: <20220830172141.581086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9be007c9420f9..f69ab90b5e22d 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1380,15 +1380,17 @@ ccio_init_resource(struct resource *res, char *name, void __iomem *ioaddr)
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
@@ -1543,7 +1545,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 		return -ENOMEM;
 	}
 	ccio_ioc_init(ioc);
-	ccio_init_resources(ioc);
+	if (ccio_init_resources(ioc)) {
+		kfree(ioc);
+		return -ENOMEM;
+	}
 	hppa_dma_ops = &ccio_ops;
 
 	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
-- 
2.35.1

