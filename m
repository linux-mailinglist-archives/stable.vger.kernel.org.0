Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F839CAC81
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbfJCQLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387795AbfJCQLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BEE320700;
        Thu,  3 Oct 2019 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119074;
        bh=BbgYBjV7x7pAvwJMekocDCPABSVxLPYEqRRlF634DY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuvL8bb4ksrGINnUkYlDLIqCrh3PATnNhKldoJKMsM3hV83t72Vyst1sh6MQ5dqcQ
         Sg/8DC6OKA2RQk5Nfqo/GyWKwwZApuh2PxaB4EQR9tD01EsOGgeGQIoB205BLseh9X
         92y4ximwFxYCoGMItga6xA/iCpkONePT772S63Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/185] iommu/amd: Silence warnings under memory pressure
Date:   Thu,  3 Oct 2019 17:53:13 +0200
Message-Id: <20191003154504.400090888@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a1174e61daf4e..07b6cf58fd99b 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2568,7 +2568,9 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
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



