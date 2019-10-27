Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61930E657B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfJ0VCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfJ0VCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:02:37 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7442D208C0;
        Sun, 27 Oct 2019 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210155;
        bh=yJSJj+ITuIJKMs7+vc2CHCVTSpYCGIZ3tQbBjXT/Olk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPdlCma7AuZ+pgwjp1tYLFrFWYMcZtdmPj8QixgX61VKzNBCk6sa+rW27rjFLhaBc
         1BmNzAtJDLngTjVxEM+c2qzzrqGEdh9yX+Nh2qu4H0W4drSx/gJCtHUf2byKPycNKG
         cp2YKG1erVbYOLuvUGcO4l0p02Js6GHJWRvf7K5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Yunqiang Su <ysu@wavecomp.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 10/41] MIPS: Treat Loongson Extensions as ASEs
Date:   Sun, 27 Oct 2019 22:00:48 +0100
Message-Id: <20191027203108.485466107@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
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
 arch/mips/include/asm/cpu-features.h | 8 ++++++++
 arch/mips/include/asm/cpu.h          | 2 ++
 arch/mips/kernel/cpu-probe.c         | 2 ++
 arch/mips/kernel/proc.c              | 2 ++
 4 files changed, 14 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index d1e04c943f5f7..ff60510357f63 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -307,6 +307,14 @@
 #define cpu_has_dsp2		(cpu_data[0].ases & MIPS_ASE_DSP2P)
 #endif
 
+#ifndef cpu_has_loongson_mmi
+#define cpu_has_loongson_mmi		__ase(MIPS_ASE_LOONGSON_MMI)
+#endif
+
+#ifndef cpu_has_loongson_ext
+#define cpu_has_loongson_ext		__ase(MIPS_ASE_LOONGSON_EXT)
+#endif
+
 #ifndef cpu_has_mipsmt
 #define cpu_has_mipsmt		(cpu_data[0].ases & MIPS_ASE_MIPSMT)
 #endif
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 82ad15f110492..08cb7a5661d07 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -399,5 +399,7 @@ enum cpu_type_enum {
 #define MIPS_ASE_DSP2P		0x00000040 /* Signal Processing ASE Rev 2 */
 #define MIPS_ASE_VZ		0x00000080 /* Virtualization ASE */
 #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
+#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
+#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 6b9064499bd3d..ee71bda53d4e6 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1016,6 +1016,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		case PRID_REV_LOONGSON3B_R1:
 		case PRID_REV_LOONGSON3B_R2:
@@ -1023,6 +1024,7 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3b");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_EXT);
 			break;
 		}
 
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index f1fab6ff53e63..33c6cdff2331e 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -121,6 +121,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (cpu_has_eva)	seq_printf(m, "%s", " eva");
 	if (cpu_has_htw)	seq_printf(m, "%s", " htw");
 	if (cpu_has_xpa)	seq_printf(m, "%s", " xpa");
+	if (cpu_has_loongson_mmi)	seq_printf(m, "%s", " loongson-mmi");
+	if (cpu_has_loongson_ext)	seq_printf(m, "%s", " loongson-ext");
 	seq_printf(m, "\n");
 
 	if (cpu_has_mmips) {
-- 
2.20.1



