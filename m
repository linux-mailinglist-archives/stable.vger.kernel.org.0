Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CC83C4564
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhGLGZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhGLGYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F20E9610CA;
        Mon, 12 Jul 2021 06:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070880;
        bh=w7CfMYTFz6LkQrEyImXPHHBUegV6pBdKCltI4bcHC9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpJCWSGxcJB2Cf+6jefvqbYtLZaPHR+YvLb/AQ5MibOVhoZBGM/WW09xEPKVvfo7P
         43AEaaCMRjNQExO8+zTg6FbGKSKSS/EIHVjhWUQunYq0+6wMZ7nslSA0w0donkkYRn
         ubD0tRBzwhbBCqN2r3D3dKY9hzQuJqfYT3Jc7Amw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/348] arm64/mm: Fix ttbr0 values stored in struct thread_info for software-pan
Date:   Mon, 12 Jul 2021 08:09:07 +0200
Message-Id: <20210712060722.570590411@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 9163f01130304fab1f74683d7d44632da7bda637 ]

When using CONFIG_ARM64_SW_TTBR0_PAN, a task's thread_info::ttbr0 must be
the TTBR0_EL1 value used to run userspace. With 52-bit PAs, the PA must be
packed into the TTBR using phys_to_ttbr(), but we forget to do this in some
of the SW PAN code. Thus, if the value is installed into TTBR0_EL1 (as may
happen in the uaccess routines), this could result in UNPREDICTABLE
behaviour.

Since hardware with 52-bit PA support almost certainly has HW PAN, which
will be used in preference, this shouldn't be a practical issue, but let's
fix this for consistency.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Fixes: 529c4b05a3cb ("arm64: handle 52-bit addresses in TTBR")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/1623749578-11231-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/mmu_context.h | 4 ++--
 arch/arm64/kernel/setup.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 1355205e5da5..fb564de90aa7 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -184,9 +184,9 @@ static inline void update_saved_ttbr0(struct task_struct *tsk,
 		return;
 
 	if (mm == &init_mm)
-		ttbr = __pa_symbol(reserved_pg_dir);
+		ttbr = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
 	else
-		ttbr = virt_to_phys(mm->pgd) | ASID(mm) << 48;
+		ttbr = phys_to_ttbr(virt_to_phys(mm->pgd)) | ASID(mm) << 48;
 
 	WRITE_ONCE(task_thread_info(tsk)->ttbr0, ttbr);
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 203a0c31f260..f55f4a15a905 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -356,7 +356,7 @@ void __init setup_arch(char **cmdline_p)
 	 * faults in case uaccess_enable() is inadvertently called by the init
 	 * thread.
 	 */
-	init_task.thread_info.ttbr0 = __pa_symbol(reserved_pg_dir);
+	init_task.thread_info.ttbr0 = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
 #endif
 
 #ifdef CONFIG_VT
-- 
2.30.2



