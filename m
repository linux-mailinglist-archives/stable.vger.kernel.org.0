Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B882D8339
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 01:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407279AbgLLAFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 19:05:15 -0500
Received: from aposti.net ([89.234.176.197]:58204 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394791AbgLLAEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 19:04:44 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Zhou Yanjie <zhouyanjie@zoho.com>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0?= <zhouyanjie@wanyeetech.com>,
        od@zcrc.me, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too
Date:   Sat, 12 Dec 2020 00:03:54 +0000
Message-Id: <20201212000354.291665-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The JZ4760 has the HPTLB as well, but has a XBurst CPU with a D0 CPUID.

Disable the HPTLB for all XBurst CPUs with a D0 CPUID. In the case where
there is no HPTLB (e.g. for older SoCs), this won't have any side
effect.

Fixes: b02efeb05699 ("MIPS: Ingenic: Disable abandoned HPTLB function.")
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/mips/kernel/cpu-probe.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index e6853697a056..31cb9199197c 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1830,16 +1830,17 @@ static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
 		 */
 		case PRID_COMP_INGENIC_D0:
 			c->isa_level &= ~MIPS_CPU_ISA_M32R2;
-			break;
+			fallthrough;
 
 		/*
 		 * The config0 register in the XBurst CPUs with a processor ID of
-		 * PRID_COMP_INGENIC_D1 has an abandoned huge page tlb mode, this
-		 * mode is not compatible with the MIPS standard, it will cause
-		 * tlbmiss and into an infinite loop (line 21 in the tlb-funcs.S)
-		 * when starting the init process. After chip reset, the default
-		 * is HPTLB mode, Write 0xa9000000 to cp0 register 5 sel 4 to
-		 * switch back to VTLB mode to prevent getting stuck.
+		 * PRID_COMP_INGENIC_D0 or PRID_COMP_INGENIC_D1 has an abandoned
+		 * huge page tlb mode, this mode is not compatible with the MIPS
+		 * standard, it will cause tlbmiss and into an infinite loop
+		 * (line 21 in the tlb-funcs.S) when starting the init process.
+		 * After chip reset, the default is HPTLB mode, Write 0xa9000000
+		 * to cp0 register 5 sel 4 to switch back to VTLB mode to prevent
+		 * getting stuck.
 		 */
 		case PRID_COMP_INGENIC_D1:
 			write_c0_page_ctrl(XBURST_PAGECTRL_HPTLB_DIS);
-- 
2.29.2

