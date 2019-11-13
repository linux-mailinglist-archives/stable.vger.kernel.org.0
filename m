Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECE7FA62B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfKMBu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfKMBu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50EEF222D3;
        Wed, 13 Nov 2019 01:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609856;
        bh=X2bHHl2RcPZJlk2yD2hIgmtodJF2T9sbh3u768snjnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxGYF7N6T823ix//K5F9tGTv4aDkysfaux11/o5U1bisnASR2Hx1lVGwCwA0y9oa3
         8fRX8liRYrUuqJdbSaXgKJiW6iCIyFsiMWdO4LwkSu0i0b1i6FjBkmdmjqum/Yo4n/
         RMPoKHoRGQBRsDhjxRolWrW0E7Zq7emr2tYeDfUs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 024/209] arm64/numa: Report correct memblock range for the dummy node
Date:   Tue, 12 Nov 2019 20:47:20 -0500
Message-Id: <20191113015025.9685-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 77cfe950901e5c13aca2df6437a05f39dd9a929b ]

The dummy node ID is marked into all memory ranges on the system. So the
dummy node really extends the entire memblock.memory. Hence report correct
extent information for the dummy node using memblock range helper functions
instead of the range [0LLU, PFN_PHYS(max_pfn) - 1)].

Fixes: 1a2db30034 ("arm64, numa: Add NUMA support for arm64 platforms")
Acked-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/numa.c b/arch/arm64/mm/numa.c
index 146c04ceaa514..54529b4ed5130 100644
--- a/arch/arm64/mm/numa.c
+++ b/arch/arm64/mm/numa.c
@@ -432,7 +432,7 @@ static int __init dummy_numa_init(void)
 	if (numa_off)
 		pr_info("NUMA disabled\n"); /* Forced off on command line. */
 	pr_info("Faking a node at [mem %#018Lx-%#018Lx]\n",
-		0LLU, PFN_PHYS(max_pfn) - 1);
+		memblock_start_of_DRAM(), memblock_end_of_DRAM() - 1);
 
 	for_each_memblock(memory, mblk) {
 		ret = numa_add_memblk(0, mblk->base, mblk->base + mblk->size);
-- 
2.20.1

