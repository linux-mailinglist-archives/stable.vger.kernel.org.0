Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D994993B0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386113AbiAXUfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384721AbiAXUa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:30:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C37BB8122D;
        Mon, 24 Jan 2022 20:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDDFC340E5;
        Mon, 24 Jan 2022 20:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056224;
        bh=03Wqyse5WbMn58IU7wn8cQE9JWvTPxZxaYwH/cNb67A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHRVMFtep2t1qpDp5W8ue1yHw0Y7wm0/ZXOi46+sJRPB9XQkul6vSmacwoPMS5Dbv
         cJAqgXr64x/D5WMdYfkOyo+xUSqorO4uQBJfaEFUp9EavSKLute+TyOHJvXf1Uo0n+
         4xYrwimmu3nbr5fihXU9bRUhTo9fVPTM6b+tv24o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jim Quinlan <jim2101024@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Frank Rowand <frank.rowand@sony.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/846] of: unittest: fix warning on PowerPC frame size warning
Date:   Mon, 24 Jan 2022 19:38:50 +0100
Message-Id: <20220124184115.216029653@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 5b85a2a3792ae..242381568f13c 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -911,11 +911,18 @@ static void __init of_unittest_dma_ranges_one(const char *path,
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
@@ -925,6 +932,7 @@ static void __init of_unittest_dma_ranges_one(const char *path,
 			 &dma_addr, expect_dma_addr, np);
 
 		kfree(map);
+		kfree(dev_bogus);
 	}
 	of_node_put(np);
 #endif
-- 
2.34.1



