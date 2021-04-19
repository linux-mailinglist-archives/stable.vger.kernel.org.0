Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A25C36434C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbhDSNQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239702AbhDSNOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 000DA61363;
        Mon, 19 Apr 2021 13:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837987;
        bh=iZf7ClmEIC7bmKfIrlNMIND01K7HbcjvZy41yZ6C9n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Un5n9VASuKvTw95ep9mOUMb7qsCZ4qBEvapqQraztPBdYanFxWJoKgylr+y1nKHIG
         nau9PMOx9wB+z3bQKvjpOId6ACoC4bItvJag782NMc0XlngIUREqpB+vZU2mPpujt6
         utROasu2P1/xEb+koFTVyl8ogumKSM1iMSMd0xX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 105/122] ARM: 9069/1: NOMMU: Fix conversion for_each_membock() to for_each_mem_range()
Date:   Mon, 19 Apr 2021 15:06:25 +0200
Message-Id: <20210419130533.722939823@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 45c2f70cba3a7eff34574103b2e2b901a5f771aa ]

for_each_mem_range() uses a loop variable, yet looking into code it is
not just iteration counter but more complex entity which encodes
information about memblock. Thus condition i == 0 looks fragile.
Indeed, it broke boot of R-class platforms since it never took i == 0
path (due to i was set to 1). Fix that with restoring original flag
check.

Fixes: b10d6bca8720 ("arch, drivers: replace for_each_membock() with for_each_mem_range()")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/pmsa-v7.c | 4 +++-
 arch/arm/mm/pmsa-v8.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/pmsa-v7.c b/arch/arm/mm/pmsa-v7.c
index 88950e41a3a9..59d916ccdf25 100644
--- a/arch/arm/mm/pmsa-v7.c
+++ b/arch/arm/mm/pmsa-v7.c
@@ -235,6 +235,7 @@ void __init pmsav7_adjust_lowmem_bounds(void)
 	phys_addr_t mem_end;
 	phys_addr_t reg_start, reg_end;
 	unsigned int mem_max_regions;
+	bool first = true;
 	int num;
 	u64 i;
 
@@ -263,7 +264,7 @@ void __init pmsav7_adjust_lowmem_bounds(void)
 #endif
 
 	for_each_mem_range(i, &reg_start, &reg_end) {
-		if (i == 0) {
+		if (first) {
 			phys_addr_t phys_offset = PHYS_OFFSET;
 
 			/*
@@ -275,6 +276,7 @@ void __init pmsav7_adjust_lowmem_bounds(void)
 			mem_start = reg_start;
 			mem_end = reg_end;
 			specified_mem_size = mem_end - mem_start;
+			first = false;
 		} else {
 			/*
 			 * memblock auto merges contiguous blocks, remove
diff --git a/arch/arm/mm/pmsa-v8.c b/arch/arm/mm/pmsa-v8.c
index 2de019f7503e..8359748a19a1 100644
--- a/arch/arm/mm/pmsa-v8.c
+++ b/arch/arm/mm/pmsa-v8.c
@@ -95,10 +95,11 @@ void __init pmsav8_adjust_lowmem_bounds(void)
 {
 	phys_addr_t mem_end;
 	phys_addr_t reg_start, reg_end;
+	bool first = true;
 	u64 i;
 
 	for_each_mem_range(i, &reg_start, &reg_end) {
-		if (i == 0) {
+		if (first) {
 			phys_addr_t phys_offset = PHYS_OFFSET;
 
 			/*
@@ -107,6 +108,7 @@ void __init pmsav8_adjust_lowmem_bounds(void)
 			if (reg_start != phys_offset)
 				panic("First memory bank must be contiguous from PHYS_OFFSET");
 			mem_end = reg_end;
+			first = false;
 		} else {
 			/*
 			 * memblock auto merges contiguous blocks, remove
-- 
2.30.2



