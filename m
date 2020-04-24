Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A28A1B7BC0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgDXQib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:38:31 -0400
Received: from foss.arm.com ([217.140.110.172]:39468 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDXQib (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 12:38:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 308E4C14;
        Fri, 24 Apr 2020 09:38:30 -0700 (PDT)
Received: from melchizedek.cambridge.arm.com (melchizedek.cambridge.arm.com [10.1.196.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B41333F68F;
        Fri, 24 Apr 2020 09:38:29 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org
Subject: [stable:PATCH 2/4 v5.4] arm64: Fake the IminLine size on systems affected by Neoverse-N1 #1542419
Date:   Fri, 24 Apr 2020 17:38:03 +0100
Message-Id: <20200424163805.4087-3-james.morse@arm.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200424163805.4087-1-james.morse@arm.com>
References: <20200424163805.4087-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ee9d90be9ddace01b7fb126567e4b539fbe1f82f ]

Systems affected by Neoverse-N1 #1542419 support DIC so do not need to
perform icache maintenance once new instructions are cleaned to the PoU.
For the errata workaround, the kernel hides DIC from user-space, so that
the unnecessary cache maintenance can be trapped by firmware.

To reduce the number of traps, produce a fake IminLine value based on
PAGE_SIZE.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cache.h | 3 ++-
 arch/arm64/kernel/traps.c      | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index 43da6dd29592..806e9dc2a852 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -11,6 +11,7 @@
 #define CTR_L1IP_MASK		3
 #define CTR_DMINLINE_SHIFT	16
 #define CTR_IMINLINE_SHIFT	0
+#define CTR_IMINLINE_MASK	0xf
 #define CTR_ERG_SHIFT		20
 #define CTR_CWG_SHIFT		24
 #define CTR_CWG_MASK		15
@@ -18,7 +19,7 @@
 #define CTR_DIC_SHIFT		29
 
 #define CTR_CACHE_MINLINE_MASK	\
-	(0xf << CTR_DMINLINE_SHIFT | 0xf << CTR_IMINLINE_SHIFT)
+	(0xf << CTR_DMINLINE_SHIFT | CTR_IMINLINE_MASK << CTR_IMINLINE_SHIFT)
 
 #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 465f0a0f8f0a..4e3e9d9c8151 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -470,9 +470,15 @@ static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
 	int rt = ESR_ELx_SYS64_ISS_RT(esr);
 	unsigned long val = arm64_ftr_reg_user_value(&arm64_ftr_reg_ctrel0);
 
-	if (cpus_have_const_cap(ARM64_WORKAROUND_1542419))
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1542419)) {
+		/* Hide DIC so that we can trap the unnecessary maintenance...*/
 		val &= ~BIT(CTR_DIC_SHIFT);
 
+		/* ... and fake IminLine to reduce the number of traps. */
+		val &= ~CTR_IMINLINE_MASK;
+		val |= (PAGE_SHIFT - 2) & CTR_IMINLINE_MASK;
+	}
+
 	pt_regs_write_reg(regs, rt, val);
 
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);
-- 
2.19.1

