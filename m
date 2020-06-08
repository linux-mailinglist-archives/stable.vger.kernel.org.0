Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10D1F316B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733105AbgFIBJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgFHXGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D3E207C3;
        Mon,  8 Jun 2020 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657595;
        bh=1Bo6mQ3UXemvfcY+3K6du4CSfs7iEjEpfOdhQeNvJW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa9v6HA9KjtrGk9x6r6bvrXPTUW7Ql3ItsrtWESnorKSSlruutG8Hy+up7uRxrWcI
         zNa2/5CgKYlhZOpLXPrZZwr3g0XQsomm8w8XeMpcvyj3sz/4yxSxu8173pn8xD0Mbu
         RbQ8eJVBg+dLH2Y1ESl/mPpHHu3VAAgSmXn/T27w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gavin Shan <gshan@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 022/274] arm64/kernel: Fix range on invalidating dcache for boot page tables
Date:   Mon,  8 Jun 2020 19:01:55 -0400
Message-Id: <20200608230607.3361041-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit 9d2d75ede59bc1edd8561f2ee9d4702a5ea0ae30 ]

Prior to commit 8eb7e28d4c642c31 ("arm64/mm: move runtime pgds to
rodata"), idmap_pgd_dir, tramp_pg_dir, reserved_ttbr0, swapper_pg_dir,
and init_pg_dir were contiguous at the end of the kernel image. The
maintenance at the end of __create_page_tables assumed these were
contiguous, and affected everything from the start of idmap_pg_dir
to the end of init_pg_dir.

That commit moved all but init_pg_dir into the .rodata section, with
other data placed between idmap_pg_dir and init_pg_dir, but did not
update the maintenance. Hence the maintenance is performed on much
more data than necessary (but as the bootloader previously made this
clean to the PoC there is no functional problem).

As we only alter idmap_pg_dir, and init_pg_dir, we only need to perform
maintenance for these. As the other dirs are in .rodata, the bootloader
will have initialised them as expected and cleaned them to the PoC. The
kernel will initialize them as necessary after enabling the MMU.

This patch reworks the maintenance to only cover the idmap_pg_dir and
init_pg_dir to avoid this unnecessary work.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20200427235700.112220-1-gshan@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  1 +
 arch/arm64/kernel/head.S         | 12 +++++++++---
 arch/arm64/kernel/vmlinux.lds.S  |  1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 538c85e62f86..25f56df7ed9a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -457,6 +457,7 @@ extern pgd_t init_pg_dir[PTRS_PER_PGD];
 extern pgd_t init_pg_end[];
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
+extern pgd_t idmap_pg_end[];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
 
 extern void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd);
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 57a91032b4c2..32f5ecbec0ea 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -394,13 +394,19 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 
 	/*
 	 * Since the page tables have been populated with non-cacheable
-	 * accesses (MMU disabled), invalidate the idmap and swapper page
-	 * tables again to remove any speculatively loaded cache lines.
+	 * accesses (MMU disabled), invalidate those tables again to
+	 * remove any speculatively loaded cache lines.
 	 */
+	dmb	sy
+
 	adrp	x0, idmap_pg_dir
+	adrp	x1, idmap_pg_end
+	sub	x1, x1, x0
+	bl	__inval_dcache_area
+
+	adrp	x0, init_pg_dir
 	adrp	x1, init_pg_end
 	sub	x1, x1, x0
-	dmb	sy
 	bl	__inval_dcache_area
 
 	ret	x28
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 497f9675071d..94402aaf5f5c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -139,6 +139,7 @@ SECTIONS
 
 	idmap_pg_dir = .;
 	. += IDMAP_DIR_SIZE;
+	idmap_pg_end = .;
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	tramp_pg_dir = .;
-- 
2.25.1

