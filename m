Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885877552F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 19:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbfGYRLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 13:11:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36407 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388173AbfGYRL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 13:11:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4747922017;
        Thu, 25 Jul 2019 13:11:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 25 Jul 2019 13:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0oMkzd
        cTVtGzV1FIPNYp2IV/eAwGlgBaZWfJm+H5J5g=; b=LoA52znRJpj54M+Kx4BvAG
        k5AYT4iIIJepG/WxRv2rsJfRYjib0EqhL8k8h9Y4skJrs3cG0E9XEdYhJ8SEvZsW
        oOyGajS1Mt56sLn4m8CYOSb87aCmADVFv4cPO3iHAwJLcjiD+4UbnIVjtDtgzEzJ
        zveWhvPW+6CpNLMod41jpZYp41li49IP4+xDbzpxuP7SbLaiKTtpwuRlQsMlFHYf
        5b76PpiMBk0tQWp4PCkeoBFXGk7J/v70Jsq4nfG5Oa8tGNSzVNcRC9BA8RqLpIBr
        a58IvOC51PKSFwDpucgWqlpcTD6vbeHFRATI7eFughLz4BFj7GdKCl8uTxNrD4yA
        ==
X-ME-Sender: <xms:v-I5Xa9HbO65zzL4_YvSMdrSprID-shiN3uC4dkoZn26uaQEwd9kXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkedvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:v-I5XXE_tuQLJwEDcO3Uu1IoeDYCxUJ8tWFgiT9siNU7bFq3fQ4Cbw>
    <xmx:v-I5XUcagNurwj72sbH1AwUwdcEMKe4bRTBmWbK6CTpQ56ovY_CiYg>
    <xmx:v-I5XQkP0N_833AGFgrOp9tnRqlVzoLlSLO3VlLPQtpFnFtjfY-BnQ>
    <xmx:wOI5XfVwa_JG-DgnV-4PzyoG5cUB61gPr6F_M8js7oNeF8wJWt-ifA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D6DC380088;
        Thu, 25 Jul 2019 13:11:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/pseries: Fix xive=off command line" failed to apply to 5.1-stable tree
To:     groug@kaod.org, clg@kaod.org, mpe@ellerman.id.au,
        pavrampu@in.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 19:11:25 +0200
Message-ID: <1564074685138104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3bf9fbdad600b1e4335dd90979f8d6072e4f602 Mon Sep 17 00:00:00 2001
From: Greg Kurz <groug@kaod.org>
Date: Wed, 15 May 2019 12:05:01 +0200
Subject: [PATCH] powerpc/pseries: Fix xive=off command line
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On POWER9, if the hypervisor supports XIVE exploitation mode, the
guest OS will unconditionally requests for the XIVE interrupt mode
even if XIVE was deactivated with the kernel command line xive=off.
Later on, when the spapr XIVE init code handles xive=off, it disables
XIVE and tries to fall back on the legacy mode XICS.

This discrepency causes a kernel panic because the hypervisor is
configured to provide the XIVE interrupt mode to the guest :

  kernel BUG at arch/powerpc/sysdev/xics/xics-common.c:135!
  ...
  NIP xics_smp_probe+0x38/0x98
  LR  xics_smp_probe+0x2c/0x98
  Call Trace:
    xics_smp_probe+0x2c/0x98 (unreliable)
    pSeries_smp_probe+0x40/0xa0
    smp_prepare_cpus+0x62c/0x6ec
    kernel_init_freeable+0x148/0x448
    kernel_init+0x2c/0x148
    ret_from_kernel_thread+0x5c/0x68

Look for xive=off during prom_init and don't ask for XIVE in this
case. One exception though: if the host only supports XIVE, we still
want to boot so we ignore xive=off.

Similarly, have the spapr XIVE init code to looking at the interrupt
mode negotiated during CAS, and ignore xive=off if the hypervisor only
supports XIVE.

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Cc: stable@vger.kernel.org # v4.20
Reported-by: Pavithra R. Prakash <pavrampu@in.ibm.com>
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index bab79c51ba4f..17f1ae7fae2c 100644
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

