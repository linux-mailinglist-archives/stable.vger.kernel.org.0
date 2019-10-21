Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2922DF3A0
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfJUQvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:51:05 -0400
Received: from forward100p.mail.yandex.net ([77.88.28.100]:53580 "EHLO
        forward100p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfJUQvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 12:51:05 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id 98D335980DB9
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:51:00 +0300 (MSK)
Received: from mxback8q.mail.yandex.net (mxback8q.mail.yandex.net [IPv6:2a02:6b8:c0e:42:0:640:b38f:32ec])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 94C5561E0002
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:51:00 +0300 (MSK)
Received: from vla3-2bcfd5e94671.qloud-c.yandex.net (vla3-2bcfd5e94671.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:2bcf:d5e9])
        by mxback8q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id zyTQdT2RO4-p0cSVVcF;
        Mon, 21 Oct 2019 19:51:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571676660;
        bh=TPDx+mq7OLSVGHrjpcHTkfVx/giBHfHGvMpB7RSAFjI=;
        h=In-Reply-To:Subject:To:From:Message-Id:Cc:References:Date;
        b=JA9qLVsnwcsMJYgNKb67vygJIehESAy4yG2WAbL27OceM1yVmrrusL/YpGsCM9E9/
         tlc/Wee4JWZ9dHUPEDagro8BT3npevFfJ2ceL7ryS6vcFzE+RVBpD+cTBb07fAvhBm
         ejZIsJ0MXvufL7AzB38lvAW0sf7Jx+xqJ4eLKhnQ=
Authentication-Results: mxback8q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-2bcfd5e94671.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id rut2FNHrRJ-otWSWJlH;
        Mon, 21 Oct 2019 19:50:58 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 4.9,1/2] MIPS: Treat Loongson Extensions as ASEs
Date:   Tue, 22 Oct 2019 00:49:55 +0800
Message-Id: <20191021164956.1731-6-jiaxun.yang@flygoat.com>
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
Cc: stable@vger.kernel.org # v4.9
---
 arch/mips/include/asm/cpu-features.h | 16 ++++++++++++++++
 arch/mips/include/asm/cpu.h          |  4 ++++
 arch/mips/kernel/cpu-probe.c         |  4 ++++
 arch/mips/kernel/proc.c              |  4 ++++
 4 files changed, 28 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index e961c8a7ea66..8c8b92b9b1ee 100644
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
index 9a8372484edc..2cd5ee746360 100644
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
index 921211bcd2ba..0a7b3e513650 100644
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
index 4c01ee5b88c9..dd05ec89cc57 100644
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
2.23.0

