Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B4499051
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359362AbiAXT7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358225AbiAXTyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:54:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43F73B81215;
        Mon, 24 Jan 2022 19:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEA2C340E5;
        Mon, 24 Jan 2022 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054078;
        bh=bW+bF1ExHsREagpkrACN8lVvle3DblM3ngq6eFFY7eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gi36GAea6uoH4P9ztcU39Y9vduda6PurWerRvi1wzDJ9DTfAVRkOW7srWbsFUJdEP
         XT6faO1bcDaUE+eTdOqr5Zt/yPbNfnekdlu3IG2Ezh3nm2er/XiTtPe3us8F08H7/Q
         eO2kGHsSKpeXlORFQA+pvYFE9zjzF72hvybSfejk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jim Quinlan <jim2101024@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Frank Rowand <frank.rowand@sony.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/563] of: unittest: fix warning on PowerPC frame size warning
Date:   Mon, 24 Jan 2022 19:40:36 +0100
Message-Id: <20220124184033.811895623@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

[ Upstream commit a8d61a9112ad0c9216ab45d050991e07bc4f3408 ]

The struct device variable "dev_bogus" was triggering this warning
on a PowerPC build:

    drivers/of/unittest.c: In function 'of_unittest_dma_ranges_one.constprop':
    [...] >> The frame size of 1424 bytes is larger than 1024 bytes
             [-Wframe-larger-than=]

This variable is now dynamically allocated.

Fixes: e0d072782c734 ("dma-mapping: introduce DMA range map, supplanting dma_pfn_offset")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20211210184636.7273-2-jim2101024@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 1d4b0b7d0cc10..a5c4c77b6f3e2 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -910,11 +910,18 @@ static void __init of_unittest_dma_ranges_one(const char *path,
 	if (!rc) {
 		phys_addr_t	paddr;
 		dma_addr_t	dma_addr;
-		struct device	dev_bogus;
+		struct device	*dev_bogus;
 
-		dev_bogus.dma_range_map = map;
-		paddr = dma_to_phys(&dev_bogus, expect_dma_addr);
-		dma_addr = phys_to_dma(&dev_bogus, expect_paddr);
+		dev_bogus = kzalloc(sizeof(struct device), GFP_KERNEL);
+		if (!dev_bogus) {
+			unittest(0, "kzalloc() failed\n");
+			kfree(map);
+			return;
+		}
+
+		dev_bogus->dma_range_map = map;
+		paddr = dma_to_phys(dev_bogus, expect_dma_addr);
+		dma_addr = phys_to_dma(dev_bogus, expect_paddr);
 
 		unittest(paddr == expect_paddr,
 			 "of_dma_get_range: wrong phys addr %pap (expecting %llx) on node %pOF\n",
@@ -924,6 +931,7 @@ static void __init of_unittest_dma_ranges_one(const char *path,
 			 &dma_addr, expect_dma_addr, np);
 
 		kfree(map);
+		kfree(dev_bogus);
 	}
 	of_node_put(np);
 #endif
-- 
2.34.1



