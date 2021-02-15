Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FC331BD00
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhBOPiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhBOPhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC6A600EF;
        Mon, 15 Feb 2021 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403144;
        bh=ft/YBWz1t9UpptJmcSTd20AycxE77gRkYFZxdGCheSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVgdAeuT/cphymnYGk1HUBEEMlbjEKw1e+UtGds5VdSwcJdmMbcCm1clo3cOLnrBT
         m1xCz5NPbe92S77cvUrQPu3RzHNKAPiIHC0UcIMCCHQeK9BVnJXpgUq2El1f9ahXXr
         4vjPcShFVcWiM9QLEeHgzzsPxbNOZXX/mcBcvGu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/104] riscv: virt_addr_valid must check the address belongs to linear mapping
Date:   Mon, 15 Feb 2021 16:26:50 +0100
Message-Id: <20210215152720.680761820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2d50f76efe481..64a675c5c30ac 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -135,7 +135,10 @@ extern phys_addr_t __phys_addr_symbol(unsigned long x);
 
 #endif /* __ASSEMBLY__ */
 
-#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+#define virt_addr_valid(vaddr)	({						\
+	unsigned long _addr = (unsigned long)vaddr;				\
+	(unsigned long)(_addr) >= PAGE_OFFSET && pfn_valid(virt_to_pfn(_addr));	\
+})
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_NON_EXEC
 
-- 
2.27.0



