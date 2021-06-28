Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE03B60D9
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhF1Oaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234392AbhF1O3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CD1F61C80;
        Mon, 28 Jun 2021 14:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890381;
        bh=a0ZXIHwPKUOQgh6KHswguKhHKWzW1AzYJXHjhIZf3tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng3uir/gNT59/OS8MuIHSZmRQ3VCCYvhe6ARLs6uBy55frUigqi47+HdnhSE6FYt1
         sTzy9OSc67nHCxDEYbKckTMUuYLqv1zw7ezfv2D9QMJ5rFfzWlA0ejxWcilmR49fvE
         F3W3MdxcsHeTxAmwD9+x8leuSzdQm8hYkv6OOAnKLQfqfedZv7hq8aSGehmc2pH4W6
         F5+Rv7MIIKubDj3li/LWDnfTM0HO6QMBQpu4Q84+ZqNs2HSxHOmODZzfrD280vxTzV
         PspfaH2v5Z4uRqUdDvmqryMcmYt/tESAeiD7UFx60q5m3rbfcEQG8Oi3bq4Bjx5ll2
         puG/d/gZVwOBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        James Morse <james.morse@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 012/101] arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is required
Date:   Mon, 28 Jun 2021 10:24:38 -0400
Message-Id: <20210628142607.32218-13-sashal@kernel.org>
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

commit 2687275a5843d1089687f08fc64eb3f3b026a169 upstream.

mem_init() currently relies on knowing the boundaries of the crashkernel
reservation to map such region with page granularity for later
unmapping via set_memory_valid(..., 0). If the crashkernel reservation
is deferred, such boundaries are not known when the linear mapping is
created. Simply parse the command line for "crashkernel" and, if found,
create the linear map with NO_BLOCK_MAPPINGS.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: James Morse <james.morse@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Link: https://lore.kernel.org/r/20201119175556.18681-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index afdad7607850..58dc93e56617 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -469,6 +469,21 @@ void __init mark_linear_text_alias_ro(void)
 			    PAGE_KERNEL_RO);
 }
 
+static bool crash_mem_map __initdata;
+
+static int __init enable_crash_mem_map(char *arg)
+{
+	/*
+	 * Proper parameter parsing is done by reserve_crashkernel(). We only
+	 * need to know if the linear map has to avoid block mappings so that
+	 * the crashkernel reservations can be unmapped later.
+	 */
+	crash_mem_map = true;
+
+	return 0;
+}
+early_param("crashkernel", enable_crash_mem_map);
+
 static void __init map_mem(pgd_t *pgdp)
 {
 	phys_addr_t kernel_start = __pa_symbol(_text);
@@ -477,7 +492,7 @@ static void __init map_mem(pgd_t *pgdp)
 	int flags = 0;
 	u64 i;
 
-	if (rodata_full || debug_pagealloc_enabled())
+	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -487,11 +502,6 @@ static void __init map_mem(pgd_t *pgdp)
 	 * the following for-loop
 	 */
 	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
-#ifdef CONFIG_KEXEC_CORE
-	if (crashk_res.end)
-		memblock_mark_nomap(crashk_res.start,
-				    resource_size(&crashk_res));
-#endif
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -519,21 +529,6 @@ static void __init map_mem(pgd_t *pgdp)
 	__map_memblock(pgdp, kernel_start, kernel_end,
 		       PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-
-#ifdef CONFIG_KEXEC_CORE
-	/*
-	 * Use page-level mappings here so that we can shrink the region
-	 * in page granularity and put back unused memory to buddy system
-	 * through /sys/kernel/kexec_crash_size interface.
-	 */
-	if (crashk_res.end) {
-		__map_memblock(pgdp, crashk_res.start, crashk_res.end + 1,
-			       PAGE_KERNEL,
-			       NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
-		memblock_clear_nomap(crashk_res.start,
-				     resource_size(&crashk_res));
-	}
-#endif
 }
 
 void mark_rodata_ro(void)
-- 
2.30.2

