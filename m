Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070DB1BCBA9
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgD1S7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbgD1S2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:28:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED7620730;
        Tue, 28 Apr 2020 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098526;
        bh=G4ZuIOwjKAloRkZZYprDJTrZZXU9WcE+SXGs2WTjMkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxB3RLwAA0DV4fkhqY5UlfnIbxrEJb1Nq8QUYjElBwujyzEpJ6ceJoia7U7RA4od7
         RTo5mjtZObvff41WydLrvRuwy/mzTnn14dAMspK7ZrjnVI7lc8OPv1zzop236liyv8
         Qb3iggrAkln9MhMw+2gGg37Ufi+cunQLzqssXYyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/131] arm64: Fake the IminLine size on systems affected by Neoverse-N1 #1542419
Date:   Tue, 28 Apr 2020 20:23:40 +0200
Message-Id: <20200428182226.263357630@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cache.h | 3 ++-
 arch/arm64/kernel/traps.c      | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index 5ee5bca8c24b1..baa684782358c 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -22,6 +22,7 @@
 #define CTR_L1IP_MASK		3
 #define CTR_DMINLINE_SHIFT	16
 #define CTR_IMINLINE_SHIFT	0
+#define CTR_IMINLINE_MASK	0xf
 #define CTR_ERG_SHIFT		20
 #define CTR_CWG_SHIFT		24
 #define CTR_CWG_MASK		15
@@ -29,7 +30,7 @@
 #define CTR_DIC_SHIFT		29
 
 #define CTR_CACHE_MINLINE_MASK	\
-	(0xf << CTR_DMINLINE_SHIFT | 0xf << CTR_IMINLINE_SHIFT)
+	(0xf << CTR_DMINLINE_SHIFT | CTR_IMINLINE_MASK << CTR_IMINLINE_SHIFT)
 
 #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 253b7f84a5a0d..965595fe68045 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -481,9 +481,15 @@ static void ctr_read_handler(unsigned int esr, struct pt_regs *regs)
 	int rt = (esr & ESR_ELx_SYS64_ISS_RT_MASK) >> ESR_ELx_SYS64_ISS_RT_SHIFT;
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
2.20.1



