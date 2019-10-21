Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6B8DF39D
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfJUQud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:50:33 -0400
Received: from forward106o.mail.yandex.net ([37.140.190.187]:60453 "EHLO
        forward106o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfJUQuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 12:50:32 -0400
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward106o.mail.yandex.net (Yandex) with ESMTP id 79EC750602B9
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:29 +0300 (MSK)
Received: from mxback4q.mail.yandex.net (mxback4q.mail.yandex.net [IPv6:2a02:6b8:c0e:6d:0:640:ed15:d2bd])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id 7457E7F20019
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:29 +0300 (MSK)
Received: from vla3-2bcfd5e94671.qloud-c.yandex.net (vla3-2bcfd5e94671.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:2bcf:d5e9])
        by mxback4q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id MoRgxli1XT-oTke0edu;
        Mon, 21 Oct 2019 19:50:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571676629;
        bh=x+PB1YxBU76EyKSAkVOaQ09/7pebF1Uss8HEt1QS+fE=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=uyK7U3JpbaGPj88VTMVY46QFL4QYHxauKLbgXBLlxQe3MMesozTEZ2wWx+eoyfQqk
         LKFkwqyQItkc6qW/Ozwmll/hsP8mnRiP42OBJ2RHBS+EO4zmaFwwaoQmx5hHWMDGku
         Hd+8mkxFKlaoE02g4V8NGTyBoccFay2MRqxUOvGE=
Authentication-Results: mxback4q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-2bcfd5e94671.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id rut2FNHrRJ-oLWS9n9f;
        Mon, 21 Oct 2019 19:50:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 4.14,1/2] MIPS: Treat Loongson Extensions as ASEs
Date:   Tue, 22 Oct 2019 00:49:51 +0800
Message-Id: <20191021164956.1731-2-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
References: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit: d2f965549006acb865c4638f1f030ebcefdc71f6

Recently, binutils had split Loongson-3 Extensions into four ASEs:
MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
them in cpuinfo so applications can probe supported ASEs at runtime.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org # v4.14
---
 arch/mips/include/asm/cpu-features.h | 16 ++++++++++++++++
 arch/mips/include/asm/cpu.h          |  4 ++++
 arch/mips/kernel/cpu-probe.c         |  4 ++++
 arch/mips/kernel/proc.c              |  4 ++++
 4 files changed, 28 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 721b698bfe3c..1befd483d5a3 100644
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
index d39324c4adf1..a6fdf1358591 100644
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
index cf3fd549e16d..3007ae1bb616 100644
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
index b2de408a259e..f8d36710cd58 100644
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
2.23.0

