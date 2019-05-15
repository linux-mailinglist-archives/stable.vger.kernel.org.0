Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBD1EBBA
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 12:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfEOKFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:05:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725974AbfEOKFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 06:05:10 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4F9w2Zj094651
        for <stable@vger.kernel.org>; Wed, 15 May 2019 06:05:09 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sgfucjr32-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 15 May 2019 06:05:08 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <groug@kaod.org>;
        Wed, 15 May 2019 11:05:07 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 11:05:03 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FA52XK48234672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 10:05:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73DE0A405D;
        Wed, 15 May 2019 10:05:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27EF1A4040;
        Wed, 15 May 2019 10:05:02 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.156.103])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 10:05:02 +0000 (GMT)
Subject: [PATCH] powerpc/pseries: Fix xive=off command line
From:   Greg Kurz <groug@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        pavrampu@in.ibm.com
Date:   Wed, 15 May 2019 12:05:01 +0200
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051510-4275-0000-0000-00000334FAC1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051510-4276-0000-0000-000038447E0B
Message-Id: <155791470178.432724.8008395673479905061.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150065
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On POWER9, if the hypervisor supports XIVE exploitation mode, the guest OS
will unconditionally requests for the XIVE interrupt mode even if XIVE was
deactivated with the kernel command line xive=off. Later on, when the spapr
XIVE init code handles xive=off, it disables XIVE and tries to fall back on
the legacy mode XICS.

This discrepency causes a kernel panic because the hypervisor is configured
to provide the XIVE interrupt mode to the guest :

[    0.008837] kernel BUG at arch/powerpc/sysdev/xics/xics-common.c:135!
[    0.008877] Oops: Exception in kernel mode, sig: 5 [#1]
[    0.008908] LE SMP NR_CPUS=1024 NUMA pSeries
[    0.008939] Modules linked in:
[    0.008964] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W         5.0.13-200.fc29.ppc64le #1
[    0.009018] NIP:  c000000001029ab8 LR: c000000001029aac CTR: c0000000018e0000
[    0.009065] REGS: c0000007f96d7900 TRAP: 0700   Tainted: G        W          (5.0.13-200.fc29.ppc64le)
[    0.009119] MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28000222  XER: 20040000
[    0.009168] CFAR: c0000000001b1e28 IRQMASK: 0
[    0.009168] GPR00: c000000001029aac c0000007f96d7b90 c0000000015e8600 0000000000000000
[    0.009168] GPR04: 0000000000000001 0000000000000000 0000000000000061 646f6d61696e0d0a
[    0.009168] GPR08: 00000007fd8f0000 0000000000000001 c0000000014c44c0 c0000007f96d76cf
[    0.009168] GPR12: 0000000000000000 c0000000018e0000 0000000000000001 0000000000000000
[    0.009168] GPR16: 0000000000000000 0000000000000001 c0000007f96d7c08 c0000000016903d0
[    0.009168] GPR20: c0000007fffe04e8 ffffffffffffffea c000000001620164 c00000000161fe58
[    0.009168] GPR24: c000000000ea6c88 c0000000011151a8 00000000006000c0 c0000007f96d7c34
[    0.009168] GPR28: 0000000000000000 c0000000014b286c c000000001115180 c00000000161dc70
[    0.009558] NIP [c000000001029ab8] xics_smp_probe+0x38/0x98
[    0.009590] LR [c000000001029aac] xics_smp_probe+0x2c/0x98
[    0.009622] Call Trace:
[    0.009639] [c0000007f96d7b90] [c000000001029aac] xics_smp_probe+0x2c/0x98 (unreliable)
[    0.009687] [c0000007f96d7bb0] [c000000001033404] pSeries_smp_probe+0x40/0xa0
[    0.009734] [c0000007f96d7bd0] [c0000000010212a4] smp_prepare_cpus+0x62c/0x6ec
[    0.009782] [c0000007f96d7cf0] [c0000000010141b8] kernel_init_freeable+0x148/0x448
[    0.009829] [c0000007f96d7db0] [c000000000010ba4] kernel_init+0x2c/0x148
[    0.009870] [c0000007f96d7e20] [c00000000000bdd4] ret_from_kernel_thread+0x5c/0x68
[    0.009916] Instruction dump:
[    0.009940] 7c0802a6 60000000 7c0802a6 38800002 f8010010 f821ffe1 3c62001c e863b9a0
[    0.009988] 4b1882d1 60000000 7c690034 5529d97e <0b090000> 3d22001c e929b998 3ce2ff8f

Look for xive=off during prom_init and don't ask for XIVE in this case. One
exception though: if the host only supports XIVE, we still want to boot so
we ignore xive=off.

Similarly, have the spapr XIVE init code to looking at the interrupt mode
negociated during CAS, and ignore xive=off if the hypervisor only supports
XIVE.

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.20
Reported-by: Pavithra R. Prakash <pavrampu@in.ibm.com>
Signed-off-by: Greg Kurz <groug@kaod.org>
---
eac1e731b59e is a v4.16 commit actually but this patch only applies
cleanly to v4.20 and newer. If needed I can send a backport for
older versions.
---
 arch/powerpc/kernel/prom_init.c  |   16 +++++++++++-
 arch/powerpc/sysdev/xive/spapr.c |   52 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 523bb99d7676..c8f7eb845927 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -172,6 +172,7 @@ static unsigned long __prombss prom_tce_alloc_end;
 
 #ifdef CONFIG_PPC_PSERIES
 static bool __prombss prom_radix_disable;
+static bool __prombss prom_xive_disable;
 #endif
 
 struct platform_support {
@@ -808,6 +809,12 @@ static void __init early_cmdline_parse(void)
 	}
 	if (prom_radix_disable)
 		prom_debug("Radix disabled from cmdline\n");
+
+	opt = prom_strstr(prom_cmd_line, "xive=off");
+	if (opt) {
+		prom_xive_disable = true;
+		prom_debug("XIVE disabled from cmdline\n");
+	}
 #endif /* CONFIG_PPC_PSERIES */
 }
 
@@ -1216,10 +1223,17 @@ static void __init prom_parse_xive_model(u8 val,
 	switch (val) {
 	case OV5_FEAT(OV5_XIVE_EITHER): /* Either Available */
 		prom_debug("XIVE - either mode supported\n");
-		support->xive = true;
+		support->xive = !prom_xive_disable;
 		break;
 	case OV5_FEAT(OV5_XIVE_EXPLOIT): /* Only Exploitation mode */
 		prom_debug("XIVE - exploitation mode supported\n");
+		if (prom_xive_disable) {
+			/*
+			 * If we __have__ to do XIVE, we're better off ignoring
+			 * the command line rather than not booting.
+			 */
+			prom_printf("WARNING: Ignoring cmdline option xive=off\n");
+		}
 		support->xive = true;
 		break;
 	case OV5_FEAT(OV5_XIVE_LEGACY): /* Only Legacy mode */
diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index 575db3b06a6b..2e2d1b8f810f 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -20,6 +20,7 @@
 #include <linux/cpumask.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
+#include <linux/libfdt.h>
 
 #include <asm/prom.h>
 #include <asm/io.h>
@@ -663,6 +664,55 @@ static bool xive_get_max_prio(u8 *max_prio)
 	return true;
 }
 
+static const u8 *get_vec5_feature(unsigned int index)
+{
+	unsigned long root, chosen;
+	int size;
+	const u8 *vec5;
+
+	root = of_get_flat_dt_root();
+	chosen = of_get_flat_dt_subnode_by_name(root, "chosen");
+	if (chosen == -FDT_ERR_NOTFOUND)
+		return NULL;
+
+	vec5 = of_get_flat_dt_prop(chosen, "ibm,architecture-vec-5", &size);
+	if (!vec5)
+		return NULL;
+
+	if (size <= index)
+		return NULL;
+
+	return vec5 + index;
+}
+
+static bool xive_spapr_disabled(void)
+{
+	const u8 *vec5_xive;
+
+	vec5_xive = get_vec5_feature(OV5_INDX(OV5_XIVE_SUPPORT));
+	if (vec5_xive) {
+		u8 val;
+
+		val = *vec5_xive & OV5_FEAT(OV5_XIVE_SUPPORT);
+		switch (val) {
+		case OV5_FEAT(OV5_XIVE_EITHER):
+		case OV5_FEAT(OV5_XIVE_LEGACY):
+			break;
+		case OV5_FEAT(OV5_XIVE_EXPLOIT):
+			/* Hypervisor only supports XIVE */
+			if (xive_cmdline_disabled)
+				pr_warn("WARNING: Ignoring cmdline option xive=off\n");
+			return false;
+		default:
+			pr_warn("%s: Unknown xive support option: 0x%x\n",
+				__func__, val);
+			break;
+		}
+	}
+
+	return xive_cmdline_disabled;
+}
+
 bool __init xive_spapr_init(void)
 {
 	struct device_node *np;
@@ -675,7 +725,7 @@ bool __init xive_spapr_init(void)
 	const __be32 *reg;
 	int i;
 
-	if (xive_cmdline_disabled)
+	if (xive_spapr_disabled())
 		return false;
 
 	pr_devel("%s()\n", __func__);

