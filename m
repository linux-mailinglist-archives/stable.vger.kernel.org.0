Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2E3E694F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfJ0VHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729280AbfJ0VHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:53 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8FB720873;
        Sun, 27 Oct 2019 21:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210471;
        bh=eou04PjLENAoWI783C03L1MqFmKysnwxu0zSh56ekWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRvIaNj3DiSrbEtnetnvx+Ne82fmuybtIxlDn/QjmyRqNZm9w9otrLOUJGaDyO471
         HPtT3Tla/XVJ7tDb9uq3nm5BPOleqD3OolTuJmeY+5dBiFQ3qf5xyblzKqJ51MhL6M
         j8PkGX6rWaisavfCnxdTyl+wQ+sMWIoDaiTdVumY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/119] MIPS: Treat Loongson Extensions as ASEs
Date:   Sun, 27 Oct 2019 22:00:03 +0100
Message-Id: <20191027203307.946766238@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
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
index 721b698bfe3cf..1befd483d5a3b 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -348,6 +348,22 @@
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
index d39324c4adf13..a6fdf13585916 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -433,5 +433,9 @@ enum cpu_type_enum {
 #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
 #define MIPS_ASE_DSP3		0x00000200 /* Signal Processing ASE Rev 3*/
 #define MIPS_ASE_MIPS16E2	0x00000400 /* MIPS16e2 */
+#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
+#define MIPS_ASE_LOONGSON_CAM	0x00001000 /* Loongson CAM */
+#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
+#define MIPS_ASE_LOONGSON_EXT2	0x00004000 /* Loongson EXTensions R2 */
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index cf3fd549e16d0..3007ae1bb616a 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1478,6 +1478,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		case PRID_REV_LOONGSON3B_R1:
 		case PRID_REV_LOONGSON3B_R2:
@@ -1485,6 +1486,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3b");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		}
 
@@ -1845,6 +1847,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		decode_configs(c);
 		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
+		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
+			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
 		break;
 	default:
 		panic("Unknown Loongson Processor ID!");
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index b2de408a259e4..f8d36710cd581 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -124,6 +124,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
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



