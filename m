Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204B856189D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 12:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiF3K4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 06:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiF3K4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 06:56:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B782427D3;
        Thu, 30 Jun 2022 03:56:48 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LYZxw6k3nz9stV;
        Thu, 30 Jun 2022 18:56:04 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 18:56:46 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 18:56:46 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH stable 4.19] swiotlb: skip swiotlb_bounce when orig_addr is zero
Date:   Thu, 30 Jun 2022 19:33:31 +0800
Message-ID: <20220630113331.1544886-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After patch ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
swiotlb_bounce will be called in swiotlb_tbl_map_single unconditionally.
This requires that the physical address must be valid, which is not always
true on stable-4.19 or earlier version.
On stable-4.19, swiotlb_alloc_buffer will call swiotlb_tbl_map_single with
orig_addr equal to zero, which cause such a panic:

Unable to handle kernel paging request at virtual address ffffb77a40000000
...
pc : __memcpy+0x100/0x180
lr : swiotlb_bounce+0x74/0x88
...
Call trace:
 __memcpy+0x100/0x180
 swiotlb_tbl_map_single+0x2c8/0x338
 swiotlb_alloc+0xb4/0x198
 __dma_alloc+0x84/0x1d8
 ...

On stable-4.9 and stable-4.14, swiotlb_alloc_coherent wille call map_single
with orig_addr equal to zero, which can cause same panic.

Fix this by skipping swiotlb_bounce when orig_addr is zero.

Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 kernel/dma/swiotlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8b1360772fc5..b1e2ce2f9c2d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -594,7 +594,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 * unconditional bounce may prevent leaking swiotlb content (i.e.
 	 * kernel memory) to user-space.
 	 */
-	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
+	if (orig_addr)
+		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
-- 
2.25.1

