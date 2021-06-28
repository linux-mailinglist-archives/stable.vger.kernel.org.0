Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF523B610B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhF1Obh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234391AbhF1O3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D89C61C90;
        Mon, 28 Jun 2021 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890380;
        bh=AQ24d0Tb3LPJsOT8LGcUXwiMHqbkRbNGe/J38h75z0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2+tzxTHZZRfzcZsX5CtYmIST0prmiwWG4aqNGOPIxJkSeNH5TMo6it2mb88ScHcf
         /urV3UKAKBM8sIvbIr47FAstc/DcRfqtOp7wx0oQ9OgSHPpCHuk64L1NopEAUUVx5J
         Rppgx2mv9iVklheOR7TEfi9OqkIw2q+JXMWFcDhYjgA1FkNWPiA0oj6B3yVm7UMxrP
         B+MKaemyp55d3JqA+oSIooEczHire3S6idZtNt7fb0wexnwseTTtzq6FtAYq/SriP2
         /6Hh2UWwvQXwhWxJ1mVb6SXpjLYZHPx54U85DNiKLKMtUfc1POf76n1nZi3RPSs7dc
         oXuE+0RcXFdGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 011/101] arm64: Ignore any DMA offsets in the max_zone_phys() calculation
Date:   Mon, 28 Jun 2021 10:24:37 -0400
Message-Id: <20210628142607.32218-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 791ab8b2e3db0c6e4295467d10398800ec29144c upstream.

Currently, the kernel assumes that if RAM starts above 32-bit (or
zone_bits), there is still a ZONE_DMA/DMA32 at the bottom of the RAM and
such constrained devices have a hardwired DMA offset. In practice, we
haven't noticed any such hardware so let's assume that we can expand
ZONE_DMA32 to the available memory if no RAM below 4GB. Similarly,
ZONE_DMA is expanded to the 4GB limit if no RAM addressable by
zone_bits.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20201118185809.1078362-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index a985d292e820..c0a7f0d90b39 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -174,14 +174,21 @@ static void __init reserve_elfcorehdr(void)
 #endif /* CONFIG_CRASH_DUMP */
 
 /*
- * Return the maximum physical address for a zone with a given address size
- * limit. It currently assumes that for memory starting above 4G, 32-bit
- * devices will use a DMA offset.
+ * Return the maximum physical address for a zone accessible by the given bits
+ * limit. If DRAM starts above 32-bit, expand the zone to the maximum
+ * available memory, otherwise cap it at 32-bit.
  */
 static phys_addr_t __init max_zone_phys(unsigned int zone_bits)
 {
-	phys_addr_t offset = memblock_start_of_DRAM() & GENMASK_ULL(63, zone_bits);
-	return min(offset + (1ULL << zone_bits), memblock_end_of_DRAM());
+	phys_addr_t zone_mask = DMA_BIT_MASK(zone_bits);
+	phys_addr_t phys_start = memblock_start_of_DRAM();
+
+	if (phys_start > U32_MAX)
+		zone_mask = PHYS_ADDR_MAX;
+	else if (phys_start > zone_mask)
+		zone_mask = U32_MAX;
+
+	return min(zone_mask, memblock_end_of_DRAM() - 1) + 1;
 }
 
 static void __init zone_sizes_init(unsigned long min, unsigned long max)
-- 
2.30.2

