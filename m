Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D543D61F1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhGZPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhGZPcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 361A46056B;
        Mon, 26 Jul 2021 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315970;
        bh=Lwu2u17oP5W6I352an90ZhfHmTxc4XW2Y6aKNEW9ihY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FF6diDW6/zUMBi2M6SlC20W6KsDfqy8YCU2PNhXRDE29lWBZr6HWP2NhTYHPrb0sL
         t9aHkZMdYEAPFQaMXDe8jheZcwNlGw9YzzDr+MpevTYKnIhRDuQlitzvvedep74Gb7
         xCsfX7zXmIOLSTuayaTkoHnKkSlKnqz72iQ12Rs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Atish Patra <atish.patra@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 136/223] RISC-V: load initrd wherever it fits into memory
Date:   Mon, 26 Jul 2021 17:38:48 +0200
Message-Id: <20210726153850.695299467@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

[ Upstream commit c79e89ecaa246c880292ba68cbe08c9c30db77e3 ]

Requiring that initrd is loaded below RAM start + 256 MiB led to failure
to boot SUSE Linux with GRUB on QEMU, cf.
https://lists.gnu.org/archive/html/grub-devel/2021-06/msg00037.html

Remove the constraint.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Fixes: d7071743db31 ("RISC-V: Add EFI stub support.")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/efi.h b/arch/riscv/include/asm/efi.h
index 6d98cd999680..7b3483ba2e84 100644
--- a/arch/riscv/include/asm/efi.h
+++ b/arch/riscv/include/asm/efi.h
@@ -27,10 +27,10 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define ARCH_EFI_IRQ_FLAGS_MASK (SR_IE | SR_SPIE)
 
-/* Load initrd at enough distance from DRAM start */
+/* Load initrd anywhere in system RAM */
 static inline unsigned long efi_get_max_initrd_addr(unsigned long image_addr)
 {
-	return image_addr + SZ_256M;
+	return ULONG_MAX;
 }
 
 #define alloc_screen_info(x...)		(&screen_info)
-- 
2.30.2



