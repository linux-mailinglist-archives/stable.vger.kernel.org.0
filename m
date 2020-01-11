Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2D137F50
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgAKKSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgAKKST (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:18:19 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9188A2082E;
        Sat, 11 Jan 2020 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737899;
        bh=Y+XNfaE3LXyuKB4B73gODgRnofkdHBQCljhdKRzPBCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPDtrapqqTGAPtSfrUTtCIvUzHmabkl7qa4nG2UfinaG0PPGcGw3OODcYhIegWdrw
         g9e8vFC6Q3sATJMI5gpZOZ33b4ceIJxTGzwDLjiy+Do4LV3qNc2cO78MwAV1g+rOF4
         mABeE3FtjnruEs8DsZ2pis+Chik/J3Hh8HOrbkc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaotao Yin <xiaotao.yin@windriver.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/84] iommu/iova: Init the struct iova to fix the possible memleak
Date:   Sat, 11 Jan 2020 10:50:21 +0100
Message-Id: <20200111094902.979778161@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaotao Yin <xiaotao.yin@windriver.com>

[ Upstream commit 472d26df5e8075eda677b6be730e0fbf434ff2a8 ]

During ethernet(Marvell octeontx2) set ring buffer test:
ethtool -G eth1 rx <rx ring size> tx <tx ring size>
following kmemleak will happen sometimes:

unreferenced object 0xffff000b85421340 (size 64):
  comm "ethtool", pid 867, jiffies 4295323539 (age 550.500s)
  hex dump (first 64 bytes):
    80 13 42 85 0b 00 ff ff ff ff ff ff ff ff ff ff  ..B.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    ff ff ff ff ff ff ff ff 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000001b204ddf>] kmem_cache_alloc+0x1b0/0x350
    [<00000000d9ef2e50>] alloc_iova+0x3c/0x168
    [<00000000ea30f99d>] alloc_iova_fast+0x7c/0x2d8
    [<00000000b8bb2f1f>] iommu_dma_alloc_iova.isra.0+0x12c/0x138
    [<000000002f1a43b5>] __iommu_dma_map+0x8c/0xf8
    [<00000000ecde7899>] iommu_dma_map_page+0x98/0xf8
    [<0000000082004e59>] otx2_alloc_rbuf+0xf4/0x158
    [<000000002b107f6b>] otx2_rq_aura_pool_init+0x110/0x270
    [<00000000c3d563c7>] otx2_open+0x15c/0x734
    [<00000000a2f5f3a8>] otx2_dev_open+0x3c/0x68
    [<00000000456a98b5>] otx2_set_ringparam+0x1ac/0x1d4
    [<00000000f2fbb819>] dev_ethtool+0xb84/0x2028
    [<0000000069b67c5a>] dev_ioctl+0x248/0x3a0
    [<00000000af38663a>] sock_ioctl+0x280/0x638
    [<000000002582384c>] do_vfs_ioctl+0x8b0/0xa80
    [<000000004e1a2c02>] ksys_ioctl+0x84/0xb8

The reason:
When alloc_iova_mem() without initial with Zero, sometimes fpn_lo will
equal to IOVA_ANCHOR by chance, so when return with -ENOMEM(iova32_full)
from __alloc_and_insert_iova_range(), the new_iova will not be freed in
free_iova_mem().

Fixes: bb68b2fbfbd6 ("iommu/iova: Add rbtree anchor node")
Signed-off-by: Xiaotao Yin <xiaotao.yin@windriver.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iova.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index da4516fbf542..34c058c24b9d 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -236,7 +236,7 @@ static DEFINE_MUTEX(iova_cache_mutex);
 
 struct iova *alloc_iova_mem(void)
 {
-	return kmem_cache_alloc(iova_cache, GFP_ATOMIC);
+	return kmem_cache_zalloc(iova_cache, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(alloc_iova_mem);
 
-- 
2.20.1



