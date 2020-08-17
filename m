Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E4C247598
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgHQTZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgHQPeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D651922D3E;
        Mon, 17 Aug 2020 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678445;
        bh=wDN3etVJB3pHViHml9zghM5nbR6E/xlIJrqYrQXPBLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUWoea6gddEk9Hedaj7Hdg/NAS6cjiTL+Jmh783NSqauscw+oKldprROuM04MRm1d
         9XQpDM6Gdv/s+sesgQQvpHOEeltpprtQKIBJKbWgdIGbtIoDU+OqyiKzkeqzfVCz9h
         KZ9vBbQZh91qXj9xABW9WEAxm2I3ve84LltsPr1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        WANG Xuerui <git@xen0n.name>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 336/464] MIPS: only register FTLBPar exception handler for supported models
Date:   Mon, 17 Aug 2020 17:14:49 +0200
Message-Id: <20200817143849.873631728@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Xuerui <git@xen0n.name>

[ Upstream commit efd1b4ad3d5178a74387bc5ff69a2d4585f586c6 ]

Previously ExcCode 16 is unconditionally treated as the FTLB parity
exception (FTLBPar), but in fact its semantic is implementation-
dependent. Looking at various manuals it seems the FTLBPar exception is
only present on some recent MIPS Technologies cores, so only register
the handler on these.

Fixes: 75b5b5e0a262790f ("MIPS: Add support for FTLBs")
Reviewed-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: WANG Xuerui <git@xen0n.name>
Cc: Paul Burton <paulburton@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-features.h |  4 ++++
 arch/mips/include/asm/cpu.h          |  1 +
 arch/mips/kernel/cpu-probe.c         | 13 +++++++++++++
 arch/mips/kernel/traps.c             |  3 ++-
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 724dfddcab92d..0b1bc7ed913b2 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -568,6 +568,10 @@
 # define cpu_has_mac2008_only	__opt(MIPS_CPU_MAC_2008_ONLY)
 #endif
 
+#ifndef cpu_has_ftlbparex
+# define cpu_has_ftlbparex	__opt(MIPS_CPU_FTLBPAREX)
+#endif
+
 #ifdef CONFIG_SMP
 /*
  * Some systems share FTLB RAMs between threads within a core (siblings in
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 104a509312b30..3a4773714b296 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -425,6 +425,7 @@ enum cpu_type_enum {
 #define MIPS_CPU_MM_SYSAD	BIT_ULL(58)	/* CPU supports write-through SysAD Valid merge */
 #define MIPS_CPU_MM_FULL	BIT_ULL(59)	/* CPU supports write-through full merge */
 #define MIPS_CPU_MAC_2008_ONLY	BIT_ULL(60)	/* CPU Only support MAC2008 Fused multiply-add instruction */
+#define MIPS_CPU_FTLBPAREX	BIT_ULL(61)	/* CPU has FTLB parity exception */
 
 /*
  * CPU ASE encodings
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index def1659fe2621..3404011eb7cff 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1827,6 +1827,19 @@ static inline void cpu_probe_mips(struct cpuinfo_mips *c, unsigned int cpu)
 	default:
 		break;
 	}
+
+	/* Recent MIPS cores use the implementation-dependent ExcCode 16 for
+	 * cache/FTLB parity exceptions.
+	 */
+	switch (__get_cpu_type(c->cputype)) {
+	case CPU_PROAPTIV:
+	case CPU_P5600:
+	case CPU_P6600:
+	case CPU_I6400:
+	case CPU_I6500:
+		c->options |= MIPS_CPU_FTLBPAREX;
+		break;
+	}
 }
 
 static inline void cpu_probe_alchemy(struct cpuinfo_mips *c, unsigned int cpu)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index f655af68176c8..e664d8b43e72b 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2457,7 +2457,8 @@ void __init trap_init(void)
 	if (cpu_has_fpu && !cpu_has_nofpuex)
 		set_except_vector(EXCCODE_FPE, handle_fpe);
 
-	set_except_vector(MIPS_EXCCODE_TLBPAR, handle_ftlb);
+	if (cpu_has_ftlbparex)
+		set_except_vector(MIPS_EXCCODE_TLBPAR, handle_ftlb);
 
 	if (cpu_has_rixiex) {
 		set_except_vector(EXCCODE_TLBRI, tlb_do_page_fault_0);
-- 
2.25.1



