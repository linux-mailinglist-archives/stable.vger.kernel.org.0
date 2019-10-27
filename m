Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929ABE65BE
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJ0VEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfJ0VEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:04:50 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D22720B7C;
        Sun, 27 Oct 2019 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210288;
        bh=oJ5CUPNbNtT3V+fDsQ5W+ZazwrslLjjgDVeCQQ110oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXo/yQm1otlxVlYS/eUBucfK6oPWmykZhDbPIXiAU+2JNeN8F7VRle/Ni7JJBSbcN
         hiu5iP6QKtDSO83vlu0Uafm8K9Da18spAWO8T2yWmGD4wC7uRi0p2bOfsA+2goiIWw
         bf9cClkxKEELkBasEiOcqWbcmlvHOyAynUfB2UDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/49] MIPS: Treat Loongson Extensions as ASEs
Date:   Sun, 27 Oct 2019 22:00:52 +0100
Message-Id: <20191027203127.430697160@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit d2f965549006acb865c4638f1f030ebcefdc71f6 ]

Recently, binutils had split Loongson-3 Extensions into four ASEs:
MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
them in cpuinfo so applications can probe supported ASEs at runtime.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Yunqiang Su <ysu@wavecomp.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cpu-features.h | 16 ++++++++++++++++
 arch/mips/include/asm/cpu.h          |  4 ++++
 arch/mips/kernel/cpu-probe.c         |  4 ++++
 arch/mips/kernel/proc.c              |  4 ++++
 4 files changed, 28 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index e961c8a7ea662..8c8b92b9b1eeb 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -345,6 +345,22 @@
 #define cpu_has_dsp3		(cpu_data[0].ases & MIPS_ASE_DSP3)
 #endif
 
+#ifndef cpu_has_loongson_mmi
+#define cpu_has_loongson_mmi		__ase(MIPS_ASE_LOONGSON_MMI)
+#endif
+
+#ifndef cpu_has_loongson_cam
+#define cpu_has_loongson_cam		__ase(MIPS_ASE_LOONGSON_CAM)
+#endif
+
+#ifndef cpu_has_loongson_ext
+#define cpu_has_loongson_ext		__ase(MIPS_ASE_LOONGSON_EXT)
+#endif
+
+#ifndef cpu_has_loongson_ext2
+#define cpu_has_loongson_ext2		__ase(MIPS_ASE_LOONGSON_EXT2)
+#endif
+
 #ifndef cpu_has_mipsmt
 #define cpu_has_mipsmt		(cpu_data[0].ases & MIPS_ASE_MIPSMT)
 #endif
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 9a8372484edc0..2cd5ee7463605 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -429,5 +429,9 @@ enum cpu_type_enum {
 #define MIPS_ASE_VZ		0x00000080 /* Virtualization ASE */
 #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
 #define MIPS_ASE_DSP3		0x00000200 /* Signal Processing ASE Rev 3*/
+#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
+#define MIPS_ASE_LOONGSON_CAM	0x00001000 /* Loongson CAM */
+#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
+#define MIPS_ASE_LOONGSON_EXT2	0x00004000 /* Loongson EXTensions R2 */
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 921211bcd2bad..0a7b3e513650f 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1480,6 +1480,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		case PRID_REV_LOONGSON3B_R1:
 		case PRID_REV_LOONGSON3B_R2:
@@ -1487,6 +1488,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3b");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		}
 
@@ -1826,6 +1828,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		decode_configs(c);
 		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
+		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
+			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
 		break;
 	default:
 		panic("Unknown Loongson Processor ID!");
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index 4c01ee5b88c99..dd05ec89cc57e 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -122,6 +122,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (cpu_has_eva)	seq_printf(m, "%s", " eva");
 	if (cpu_has_htw)	seq_printf(m, "%s", " htw");
 	if (cpu_has_xpa)	seq_printf(m, "%s", " xpa");
+	if (cpu_has_loongson_mmi)	seq_printf(m, "%s", " loongson-mmi");
+	if (cpu_has_loongson_cam)	seq_printf(m, "%s", " loongson-cam");
+	if (cpu_has_loongson_ext)	seq_printf(m, "%s", " loongson-ext");
+	if (cpu_has_loongson_ext2)	seq_printf(m, "%s", " loongson-ext2");
 	seq_printf(m, "\n");
 
 	if (cpu_has_mmips) {
-- 
2.20.1



