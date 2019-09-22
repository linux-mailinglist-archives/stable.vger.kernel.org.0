Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51174BA54F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408180AbfIVS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438589AbfIVS41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA8C521D7E;
        Sun, 22 Sep 2019 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178586;
        bh=WBnSak/d1Xqtku0jLNdqMwI6cCkMITfUHWXejyzmLG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZtfrGrwMa98nfGNL21PLxgPeCUxijurhaLYolvbzDxiuYAYx7VmBoW/UIcAIPB+m
         ZC63MK1UYghGt3UrlZw6uRrNv2GH2XleLZk+vqeL/B1eqUNcIXoYHro+44LbVSKrzj
         4+4ZPpTCRWnYA+elxKk4uWv3aiNVUlqKLcquDlbM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 095/128] iommu/amd: Silence warnings under memory pressure
Date:   Sun, 22 Sep 2019 14:53:45 -0400
Message-Id: <20190922185418.2158-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 3d708895325b78506e8daf00ef31549476e8586a ]

When running heavy memory pressure workloads, the system is throwing
endless warnings,

smartpqi 0000:23:00.0: AMD-Vi: IOMMU mapping error in map_sg (io-pages:
5 reason: -12)
Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40
07/10/2019
swapper/10: page allocation failure: order:0, mode:0xa20(GFP_ATOMIC),
nodemask=(null),cpuset=/,mems_allowed=0,4
Call Trace:
 <IRQ>
 dump_stack+0x62/0x9a
 warn_alloc.cold.43+0x8a/0x148
 __alloc_pages_nodemask+0x1a5c/0x1bb0
 get_zeroed_page+0x16/0x20
 iommu_map_page+0x477/0x540
 map_sg+0x1ce/0x2f0
 scsi_dma_map+0xc6/0x160
 pqi_raid_submit_scsi_cmd_with_io_request+0x1c3/0x470 [smartpqi]
 do_IRQ+0x81/0x170
 common_interrupt+0xf/0xf
 </IRQ>

because the allocation could fail from iommu_map_page(), and the volume
of this call could be huge which may generate a lot of serial console
output and cosumes all CPUs.

Fix it by silencing the warning in this call site, and there is still a
dev_err() later to notify the failure.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 8d9920ff41344..b892637c320bc 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2533,7 +2533,9 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 			bus_addr  = address + s->dma_address + (j << PAGE_SHIFT);
 			phys_addr = (sg_phys(s) & PAGE_MASK) + (j << PAGE_SHIFT);
-			ret = iommu_map_page(domain, bus_addr, phys_addr, PAGE_SIZE, prot, GFP_ATOMIC);
+			ret = iommu_map_page(domain, bus_addr, phys_addr,
+					     PAGE_SIZE, prot,
+					     GFP_ATOMIC | __GFP_NOWARN);
 			if (ret)
 				goto out_unmap;
 
-- 
2.20.1

