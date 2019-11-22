Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182D8106F17
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbfKVK5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbfKVK5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232F820721;
        Fri, 22 Nov 2019 10:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420231;
        bh=X2bHHl2RcPZJlk2yD2hIgmtodJF2T9sbh3u768snjnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puT73QDVgvVkEJ7iysVzURkB8aAUsneTRbtMUe5Ml9U60cppA54E5dWbEeZC7S5IU
         fS+6qc5GgO+RPS1ZMpu+CuRTdVg0NLJyDbvRdj1QuJaxaCVHsoW9mJ8O4Jdr2EK2Px
         N+AfW5MzeNQJHqNfk4YX1X61XKnGg+vBeGmgxJK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/220] arm64/numa: Report correct memblock range for the dummy node
Date:   Fri, 22 Nov 2019 11:26:42 +0100
Message-Id: <20191122100915.006738285@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



