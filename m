Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B59DF3A9
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJUQ4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:56:09 -0400
Received: from forward100j.mail.yandex.net ([5.45.198.240]:33862 "EHLO
        forward100j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfJUQ4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 12:56:09 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 12:56:08 EDT
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 0DA5550E030E
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:41 +0300 (MSK)
Received: from mxback11q.mail.yandex.net (mxback11q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:1f0c:10f2])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 077B161E0009
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:41 +0300 (MSK)
Received: from vla3-2bcfd5e94671.qloud-c.yandex.net (vla3-2bcfd5e94671.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:2bcf:d5e9])
        by mxback11q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 8aQvTQDiCB-oeZCOlwU;
        Mon, 21 Oct 2019 19:50:41 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571676641;
        bh=NHJNQ+yAYu3idmB2k0hCGAymj/wiTSC9Vpn4nP8BGIs=;
        h=In-Reply-To:Subject:To:From:Message-Id:Cc:References:Date;
        b=OOyDBE+CKXfpcryFicl0MzPH6AV4Tshud1fFSdl7OsVLbRDHBoP9Lk9B/xUnopwVy
         IB8T6gwXMLTcB7VXeXaINtZ8Pcb49V01/UHGIlF381B3cR2j2tferi0eA86nmbHj/g
         erqhARjsBbX+YXoBENhxPrLDa6pkdUTcDObcdbu8=
Authentication-Results: mxback11q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-2bcfd5e94671.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id rut2FNHrRJ-oaWS0ncr;
        Mon, 21 Oct 2019 19:50:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     stable@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 4.4,1/2] MIPS: Treat Loongson Extensions as ASEs
Date:   Tue, 22 Oct 2019 00:49:53 +0800
Message-Id: <20191021164956.1731-4-jiaxun.yang@flygoat.com>
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
Cc: stable@vger.kernel.org # v4.4

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/cpu-features.h | 8 ++++++++
 arch/mips/include/asm/cpu.h          | 2 ++
 arch/mips/kernel/cpu-probe.c         | 2 ++
 arch/mips/kernel/proc.c              | 2 ++
 4 files changed, 14 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index d1e04c943f5f..ff60510357f6 100644
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
index 82ad15f11049..08cb7a5661d0 100644
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
index 6b9064499bd3..ee71bda53d4e 100644
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
index f1fab6ff53e6..33c6cdff2331 100644
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
2.23.0

