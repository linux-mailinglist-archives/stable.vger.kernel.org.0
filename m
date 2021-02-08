Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5E5313C7C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhBHSHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235290AbhBHSDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E211C64EDC;
        Mon,  8 Feb 2021 17:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807158;
        bh=N3IHvP9qsEjKvZNs4XAG/Gl7HN0ZoAJSQ1mcVF/2Ll4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkQUzPV87NeEM75RsLVDPMMuH025VZlvczdauAEJ92tUPHSweIL6JVsxTMoM7xTuc
         F22fEARF1fh3MEZ7sMn2PONBGzMGtBZxfKzvi+3snA5Y069jLb2WTmF/NVcjK2AJFT
         hHfzqJtG9umvJturUo70x2XwwemkL6OGg9R4IrJThlyK+Wnyn1OD2YDW74SRJQvP69
         Ftmd9tTFNUW9yOCpj5kFyQBj9c/NQ4lYMjXB6emi/KMgOlZ4021+urDOUl6ANAdBPn
         IhgSc2ozGqTvoP7qf7X5HrbABKRxJzUWD1gKnrgWJcdb3gSmIgz0M7Vo0+wBbxh+lX
         E2n/ukKgxLG2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Ghiti <alex@ghiti.fr>, Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 14/19] riscv: virt_addr_valid must check the address belongs to linear mapping
Date:   Mon,  8 Feb 2021 12:58:53 -0500
Message-Id: <20210208175858.2092008-14-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit 2ab543823322b564f205cb15d0f0302803c87d11 ]

virt_addr_valid macro checks that a virtual address is valid, ie that
the address belongs to the linear mapping and that the corresponding
 physical page exists.

Add the missing check that ensures the virtual address belongs to the
linear mapping, otherwise __virt_to_phys, when compiled with
CONFIG_DEBUG_VIRTUAL enabled, raises a WARN that is interpreted as a
kernel bug by syzbot.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/page.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 3db261c4810fc..6a30794aa1eea 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -119,7 +119,10 @@ extern unsigned long min_low_pfn;
 
 #endif /* __ASSEMBLY__ */
 
-#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+#define virt_addr_valid(vaddr)	({						\
+	unsigned long _addr = (unsigned long)vaddr;				\
+	(unsigned long)(_addr) >= PAGE_OFFSET && pfn_valid(virt_to_pfn(_addr));	\
+})
 
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-- 
2.27.0

