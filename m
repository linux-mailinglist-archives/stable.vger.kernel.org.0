Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043CA73C84
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392266AbfGXUAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392283AbfGXUAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7407922ADA;
        Wed, 24 Jul 2019 20:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998403;
        bh=GG9bwFfGR5VftcAMGv5fNl1yA+l5GCq3VkjmvqXOPIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzvaVtD0c7DeFZfVOn3/vzgUa0fdnoUQXyjc8HuoiHfY9HKI1uU2PsAL6YBEQjQgM
         iQtn0Afdy7pL5Fc+NQaw4J8G1xr84xCeKZt5/K/MuCgMpVymB9gD6bYJbKsJ0lrTY1
         0b3rtO6z1OReprFiw6DzIKwKDDd4skDgEbSJnBHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Pavithra R. Prakash" <pavrampu@in.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 354/371] powerpc/pseries: Fix xive=off command line
Date:   Wed, 24 Jul 2019 21:21:46 +0200
Message-Id: <20190724191750.529500174@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit a3bf9fbdad600b1e4335dd90979f8d6072e4f602 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/prom_init.c  |   16 +++++++++++-
 arch/powerpc/sysdev/xive/spapr.c |   52 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -174,6 +174,7 @@ static unsigned long __prombss prom_tce_
 
 #ifdef CONFIG_PPC_PSERIES
 static bool __prombss prom_radix_disable;
+static bool __prombss prom_xive_disable;
 #endif
 
 struct platform_support {
@@ -684,6 +685,12 @@ static void __init early_cmdline_parse(v
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
 
@@ -1092,10 +1099,17 @@ static void __init prom_parse_xive_model
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
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -20,6 +20,7 @@
 #include <linux/cpumask.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
+#include <linux/libfdt.h>
 
 #include <asm/prom.h>
 #include <asm/io.h>
@@ -663,6 +664,55 @@ static bool xive_get_max_prio(u8 *max_pr
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


