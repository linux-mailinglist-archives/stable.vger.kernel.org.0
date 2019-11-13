Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABCFA1D3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfKMB7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:59:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730319AbfKMB7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F7E222CF;
        Wed, 13 Nov 2019 01:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610384;
        bh=LweHk9SyP1/gFilCOzPMPDtIyP9pgPKCmKGKDqvX6ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzcnGnSOurDHV6seeM322rq2YMUvKGApg5n4tiIxxvpO+Pqc9qcZjJk9aS3eiu/JU
         pspXxRpupjtVNVRDGFJ66yDiwLB1fTlAlCBFS3uLKlNPIlJFwJbP1itwBDTT61+sz2
         7A+afuxxjGLN84zIMs4loUmHfyWx4nFmlLiBm9k8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 07/68] arm64/numa: Report correct memblock range for the dummy node
Date:   Tue, 12 Nov 2019 20:58:31 -0500
Message-Id: <20191113015932.12655-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
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
index 4b32168cf91a0..b1e42bad69ac3 100644
--- a/arch/arm64/mm/numa.c
+++ b/arch/arm64/mm/numa.c
@@ -424,7 +424,7 @@ static int __init dummy_numa_init(void)
 	if (numa_off)
 		pr_info("NUMA disabled\n"); /* Forced off on command line. */
 	pr_info("Faking a node at [mem %#018Lx-%#018Lx]\n",
-		0LLU, PFN_PHYS(max_pfn) - 1);
+		memblock_start_of_DRAM(), memblock_end_of_DRAM() - 1);
 
 	for_each_memblock(memory, mblk) {
 		ret = numa_add_memblk(0, mblk->base, mblk->base + mblk->size);
-- 
2.20.1

