Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C5449A308
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366079AbiAXXwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844102AbiAXXHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:07:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1185FC09F48C;
        Mon, 24 Jan 2022 13:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3ACB614B4;
        Mon, 24 Jan 2022 21:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9ECC340E4;
        Mon, 24 Jan 2022 21:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059045;
        bh=Qv3AXBJypUQEhcu/HM/kLS35NH/SfK+kss7qkpXJK+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vn3F6ntYNT0iAziCVwH0js4Me2P7G+0rRVtFUm4T1/8kSJAv2x8aIxfOgPIzoUKjn
         pzxgRPU98DbENNHdsfB8Zvm1uV51ZB0s+DX3izIXIWUDQ8yEDuSxSsl6auA2nzRNYP
         p4mKtcqWNFewsXRpW9sIp+qkSKxSSJFdWyIqeQsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jim Quinlan <jim2101024@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Frank Rowand <frank.rowand@sony.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0487/1039] of: unittest: fix warning on PowerPC frame size warning
Date:   Mon, 24 Jan 2022 19:37:56 +0100
Message-Id: <20220124184141.643180859@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 481ba8682ebf4..02c5cd06ad19c 100644
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



