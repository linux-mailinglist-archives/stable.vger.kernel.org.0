Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A8D329010
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbhCAUCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242116AbhCATux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0F54650EE;
        Mon,  1 Mar 2021 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621134;
        bh=JPxWOQheFtgc08EUsD0cIxff5awqN/wbHGsrMDFgZmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR9vo+zRiiBzfP7m1wYVpvlKOuVSLQbPx+n2sw4vkRbKiEkuBYHtvkbf+NwpxXoa2
         u9pgX3sUlUOBhe825wbdaVQj7KQBY5gKv4PcRFLvFKIj8NXI83HZm1aft7/+GHKrRC
         DTijqZRuuNoEp9IT7DMC/KsZ2qZW20bEYpD/wy9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Yong Wu <yong.wu@mediatek.com>, Will Deacon <will@kernel.org>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 406/775] iommu: Properly pass gfp_t in _iommu_map() to avoid atomic sleeping
Date:   Mon,  1 Mar 2021 17:09:34 +0100
Message-Id: <20210301161221.648294708@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b8437a3ef8c485903d05d1f261328aaf0c0a6cc2 ]

Sleeping while atomic = bad.  Let's fix an obvious typo to try to avoid it.

The warning that was seen (on a downstream kernel with the problematic
patch backported):

 BUG: sleeping function called from invalid context at mm/page_alloc.c:4726
 in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 9, name: ksoftirqd/0
 CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.93-12508-gc10c93e28e39 #1
 Call trace:
  dump_backtrace+0x0/0x154
  show_stack+0x20/0x2c
  dump_stack+0xa0/0xfc
  ___might_sleep+0x11c/0x12c
  __might_sleep+0x50/0x84
  __alloc_pages_nodemask+0xf8/0x2bc
  __arm_lpae_alloc_pages+0x48/0x1b4
  __arm_lpae_map+0x124/0x274
  __arm_lpae_map+0x1cc/0x274
  arm_lpae_map+0x140/0x170
  arm_smmu_map+0x78/0xbc
  __iommu_map+0xd4/0x210
  _iommu_map+0x4c/0x84
  iommu_map_atomic+0x44/0x58
  __iommu_dma_map+0x8c/0xc4
  iommu_dma_map_page+0xac/0xf0

Fixes: d8c1df02ac7f ("iommu: Move iotlb_sync_map out from __iommu_map")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210201170611.1.I64a7b62579287d668d7c89e105dcedf45d641063@changeid
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c304a6a30d42e..fd5f59373fc62 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2441,7 +2441,7 @@ static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
 	const struct iommu_ops *ops = domain->ops;
 	int ret;
 
-	ret = __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
+	ret = __iommu_map(domain, iova, paddr, size, prot, gfp);
 	if (ret == 0 && ops->iotlb_sync_map)
 		ops->iotlb_sync_map(domain);
 
-- 
2.27.0



