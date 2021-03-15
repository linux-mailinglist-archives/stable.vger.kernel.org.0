Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7697033B939
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhCOOFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhCOOBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C3A64F37;
        Mon, 15 Mar 2021 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816849;
        bh=eZFL0fjm6QqGglO8/NmhKLKerRKIO1ZoyGgkbVFVqdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4bzDurE9g8rczzgtfSqWk73yHSfRZoq+5dezJEeakS5q/djob/sBV6/+ktRb/ISO
         w4CtwIWzoS5x5U14S0iRA3aj7DieHfeWmjatUxM4w5AmgmCTwMRnj6WTK15HsJB68i
         ey1U4GVfpScWERyynJbUGSVkW5cV0H9rL93OrzSs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/168] arm64: mm: use a 48-bit ID map when possible on 52-bit VA builds
Date:   Mon, 15 Mar 2021 14:56:23 +0100
Message-Id: <20210315135555.315021067@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 7ba8f2b2d652cd8d8a2ab61f4be66973e70f9f88 ]

52-bit VA kernels can run on hardware that is only 48-bit capable, but
configure the ID map as 52-bit by default. This was not a problem until
recently, because the special T0SZ value for a 52-bit VA space was never
programmed into the TCR register anwyay, and because a 52-bit ID map
happens to use the same number of translation levels as a 48-bit one.

This behavior was changed by commit 1401bef703a4 ("arm64: mm: Always update
TCR_EL1 from __cpu_set_tcr_t0sz()"), which causes the unsupported T0SZ
value for a 52-bit VA to be programmed into TCR_EL1. While some hardware
simply ignores this, Mark reports that Amberwing systems choke on this,
resulting in a broken boot. But even before that commit, the unsupported
idmap_t0sz value was exposed to KVM and used to program TCR_EL2 incorrectly
as well.

Given that we already have to deal with address spaces being either 48-bit
or 52-bit in size, the cleanest approach seems to be to simply default to
a 48-bit VA ID map, and only switch to a 52-bit one if the placement of the
kernel in DRAM requires it. This is guaranteed not to happen unless the
system is actually 52-bit VA capable.

Fixes: 90ec95cda91a ("arm64: mm: Introduce VA_BITS_MIN")
Reported-by: Mark Salter <msalter@redhat.com>
Link: http://lore.kernel.org/r/20210310003216.410037-1-msalter@redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20210310171515.416643-2-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/mmu_context.h | 5 +----
 arch/arm64/kernel/head.S             | 2 +-
 arch/arm64/mm/mmu.c                  | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 3827ff4040a3..3a5d9f1c91b6 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -63,10 +63,7 @@ extern u64 idmap_ptrs_per_pgd;
 
 static inline bool __cpu_uses_extended_idmap(void)
 {
-	if (IS_ENABLED(CONFIG_ARM64_VA_BITS_52))
-		return false;
-
-	return unlikely(idmap_t0sz != TCR_T0SZ(VA_BITS));
+	return unlikely(idmap_t0sz != TCR_T0SZ(vabits_actual));
 }
 
 /*
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 438de2301cfe..a2e0b3754943 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -337,7 +337,7 @@ __create_page_tables:
 	 */
 	adrp	x5, __idmap_text_end
 	clz	x5, x5
-	cmp	x5, TCR_T0SZ(VA_BITS)	// default T0SZ small enough?
+	cmp	x5, TCR_T0SZ(VA_BITS_MIN) // default T0SZ small enough?
 	b.ge	1f			// .. then skip VA range extension
 
 	adr_l	x6, idmap_t0sz
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d10247fab0fd..99bc0289ab2b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -38,7 +38,7 @@
 #define NO_BLOCK_MAPPINGS	BIT(0)
 #define NO_CONT_MAPPINGS	BIT(1)
 
-u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
+u64 idmap_t0sz = TCR_T0SZ(VA_BITS_MIN);
 u64 idmap_ptrs_per_pgd = PTRS_PER_PGD;
 
 u64 __section(".mmuoff.data.write") vabits_actual;
-- 
2.30.1



